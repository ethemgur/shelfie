// upsert_book: the only write path into the `works` / `editions` catalogue
// (clients have read-only RLS). Takes a search result or a manual entry,
// dedupes by ISBN-13 and Open Library work key, and returns the ids.
//
// POST { work: {...}, edition: {...} } -> { work_id, edition_id }

import { createClient, type SupabaseClient } from "npm:@supabase/supabase-js@2";
import {
  type EditionInput,
  parseUpsertBookInput,
  type UpsertBookInput,
  ValidationError,
  type WorkInput,
} from "./validate.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

const UNIQUE_VIOLATION = "23505";

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return json({ error: "method not allowed" }, 405);

  const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
  const authHeader = req.headers.get("Authorization") ?? "";
  const asUser = createClient(supabaseUrl, Deno.env.get("SUPABASE_ANON_KEY")!, {
    global: { headers: { Authorization: authHeader } },
  });
  const { data: { user } } = await asUser.auth.getUser(authHeader.replace(/^Bearer /, ""));
  if (!user) return json({ error: "not signed in" }, 401);

  let input: UpsertBookInput;
  try {
    const publicUrl = Deno.env.get("PUBLIC_SUPABASE_URL") ?? supabaseUrl;
    input = parseUpsertBookInput(await req.json(), {
      userCoverPrefix: `${publicUrl}/storage/v1/object/public/covers/${user.id}/`,
    });
  } catch (e) {
    if (e instanceof ValidationError || e instanceof SyntaxError) {
      return json({ error: e.message }, 400);
    }
    throw e;
  }

  const admin = createClient(supabaseUrl, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!, {
    auth: { persistSession: false },
  });
  try {
    return json(await upsertBook(admin, input, user.id));
  } catch (e) {
    console.error("upsert_book failed", e);
    return json({ error: "could not save book" }, 500);
  }
});

async function upsertBook(db: SupabaseClient, input: UpsertBookInput, userId: string) {
  const { work, edition } = input;

  // 1. Same ISBN-13 → same edition. Fill in blanks, never overwrite.
  if (edition.isbn13 !== null) {
    const existing = await findEditionByIsbn(db, edition.isbn13);
    if (existing) {
      await fillEditionBlanks(db, existing, edition);
      return { work_id: existing.work_id, edition_id: existing.id };
    }
  }

  // 2. Work by Open Library key, else a new work.
  const workId = await findOrCreateWork(db, work);

  // 3. Edition without ISBN: reuse an identical ISBN-less edition of the work.
  if (edition.isbn13 === null && edition.source !== "user") {
    let query = db.from("editions").select("id").eq("work_id", workId).is("isbn13", null)
      .eq("source", edition.source).eq("format", edition.format);
    query = edition.page_count === null
      ? query.is("page_count", null)
      : query.eq("page_count", edition.page_count);
    const { data } = await query.limit(1).maybeSingle();
    if (data) return { work_id: workId, edition_id: data.id };
  }

  const { data, error } = await db.from("editions").insert({
    ...edition,
    work_id: workId,
    created_by: edition.source === "user" ? userId : null,
  }).select("id, work_id").single();
  if (error?.code === UNIQUE_VIOLATION && edition.isbn13 !== null) {
    // Lost a race with another insert of the same ISBN.
    const raced = await findEditionByIsbn(db, edition.isbn13);
    if (raced) return { work_id: raced.work_id, edition_id: raced.id };
  }
  if (error) throw error;
  return { work_id: data.work_id, edition_id: data.id };
}

type EditionRow = {
  id: string;
  work_id: string;
  page_count: number | null;
  cover_url: string | null;
  isbn10: string | null;
  publisher: string | null;
};

async function findEditionByIsbn(db: SupabaseClient, isbn13: string): Promise<EditionRow | null> {
  const { data, error } = await db.from("editions")
    .select("id, work_id, page_count, cover_url, isbn10, publisher")
    .eq("isbn13", isbn13).maybeSingle();
  if (error) throw error;
  return data;
}

async function fillEditionBlanks(db: SupabaseClient, row: EditionRow, input: EditionInput) {
  const patch: Record<string, unknown> = {};
  if (row.page_count === null && input.page_count !== null) patch.page_count = input.page_count;
  if (row.cover_url === null && input.cover_url !== null) patch.cover_url = input.cover_url;
  if (row.isbn10 === null && input.isbn10 !== null) patch.isbn10 = input.isbn10;
  if (row.publisher === null && input.publisher !== null) patch.publisher = input.publisher;
  if (Object.keys(patch).length === 0) return;
  const { error } = await db.from("editions").update(patch).eq("id", row.id);
  if (error) throw error;
}

async function findOrCreateWork(db: SupabaseClient, work: WorkInput): Promise<string> {
  const key = work.open_library_work_key;
  if (key !== null) {
    const { data, error } = await db.from("works").select("id, cover_url")
      .eq("open_library_work_key", key).maybeSingle();
    if (error) throw error;
    if (data) {
      if (data.cover_url === null && work.cover_url !== null) {
        await db.from("works").update({ cover_url: work.cover_url }).eq("id", data.id);
      }
      return data.id;
    }
  }
  const { data, error } = await db.from("works").insert(work).select("id").single();
  if (error?.code === UNIQUE_VIOLATION && key !== null) {
    const { data: raced } = await db.from("works").select("id")
      .eq("open_library_work_key", key).single();
    if (raced) return raced.id;
  }
  if (error) throw error;
  return data.id;
}
