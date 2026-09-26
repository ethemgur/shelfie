// Pure input validation/normalisation for `upsert_book`. No I/O, so it can be
// unit-tested with `deno test`.

export type BookFormat = "print" | "ebook" | "audiobook";
export type EditionSource = "open_library" | "google_books" | "user";

export interface WorkInput {
  title: string;
  subtitle: string | null;
  authors: string[];
  first_published_year: number | null;
  cover_url: string | null;
  open_library_work_key: string | null;
}

export interface EditionInput {
  isbn13: string | null;
  isbn10: string | null;
  format: BookFormat;
  page_count: number | null;
  publisher: string | null;
  published_date: string | null;
  language: string | null;
  cover_url: string | null;
  source: EditionSource;
}

export interface UpsertBookInput {
  work: WorkInput;
  edition: EditionInput;
}

export class ValidationError extends Error {}

const FORMATS: BookFormat[] = ["print", "ebook", "audiobook"];
const SOURCES: EditionSource[] = ["open_library", "google_books", "user"];

/** Strips spaces/hyphens and upper-cases a trailing x. */
export function cleanIsbn(raw: string): string {
  return raw.replace(/[\s-]/g, "").toUpperCase();
}

export function isValidIsbn13(isbn: string): boolean {
  if (!/^97[89]\d{10}$/.test(isbn)) return false;
  let sum = 0;
  for (let i = 0; i < 12; i++) sum += Number(isbn[i]) * (i % 2 === 0 ? 1 : 3);
  return (10 - (sum % 10)) % 10 === Number(isbn[12]);
}

export function isValidIsbn10(isbn: string): boolean {
  if (!/^\d{9}[\dX]$/.test(isbn)) return false;
  let sum = 0;
  for (let i = 0; i < 10; i++) {
    const digit = isbn[i] === "X" ? 10 : Number(isbn[i]);
    sum += digit * (10 - i);
  }
  return sum % 11 === 0;
}

export function isbn10To13(isbn10: string): string {
  const core = "978" + isbn10.slice(0, 9);
  let sum = 0;
  for (let i = 0; i < 12; i++) sum += Number(core[i]) * (i % 2 === 0 ? 1 : 3);
  return core + ((10 - (sum % 10)) % 10);
}

function str(value: unknown, field: string, max: number): string | null {
  if (value === undefined || value === null) return null;
  if (typeof value !== "string") throw new ValidationError(`${field} must be a string`);
  const trimmed = value.trim();
  if (trimmed.length === 0) return null;
  if (trimmed.length > max) throw new ValidationError(`${field} is too long`);
  return trimmed;
}

function int(value: unknown, field: string, min: number, max: number): number | null {
  if (value === undefined || value === null) return null;
  if (typeof value !== "number" || !Number.isInteger(value) || value < min || value > max) {
    throw new ValidationError(`${field} must be an integer between ${min} and ${max}`);
  }
  return value;
}

/**
 * An https URL, or — when [requiredPrefix] is given — a URL starting with it
 * (which may be http for the local dev stack).
 */
function httpsUrl(value: unknown, field: string, requiredPrefix: string | null): string | null {
  const url = str(value, field, 2000);
  if (url === null) return null;
  if (requiredPrefix !== null) {
    if (!url.startsWith(requiredPrefix) || url.includes("..")) {
      throw new ValidationError(`${field} must be a photo you uploaded`);
    }
    return url;
  }
  try {
    if (new URL(url).protocol !== "https:") throw new Error();
  } catch {
    throw new ValidationError(`${field} must be an https URL`);
  }
  return url;
}

export interface ParseOptions {
  /**
   * Public URL prefix of the caller's own folder in the `covers` bucket,
   * e.g. `https://x.supabase.co/storage/v1/object/public/covers/<uid>/`.
   * Manually added books may only use cover photos from there.
   */
  userCoverPrefix: string;
}

/**
 * Validates and normalises the request body. ISBNs are cleaned and
 * checksum-verified; an ISBN-10 alone also yields its ISBN-13.
 */
export function parseUpsertBookInput(body: unknown, options: ParseOptions): UpsertBookInput {
  if (typeof body !== "object" || body === null) {
    throw new ValidationError("body must be an object");
  }
  const { work, edition } = body as Record<string, unknown>;
  if (typeof work !== "object" || work === null) throw new ValidationError("work is required");
  if (typeof edition !== "object" || edition === null) {
    throw new ValidationError("edition is required");
  }
  const w = work as Record<string, unknown>;
  const e = edition as Record<string, unknown>;

  const title = str(w.title, "work.title", 500);
  if (title === null) throw new ValidationError("work.title is required");

  if (w.authors !== undefined && !Array.isArray(w.authors)) {
    throw new ValidationError("work.authors must be an array");
  }
  const authors = ((w.authors as unknown[] | undefined) ?? [])
    .map((a, i) => str(a, `work.authors[${i}]`, 200))
    .filter((a): a is string => a !== null);
  if (authors.length > 20) throw new ValidationError("work.authors has too many entries");

  const olKey = str(w.open_library_work_key, "work.open_library_work_key", 40);
  if (olKey !== null && !/^\/works\/OL\d+W$/.test(olKey)) {
    throw new ValidationError("work.open_library_work_key must look like /works/OL123W");
  }

  const source = e.source as EditionSource;
  if (!SOURCES.includes(source)) throw new ValidationError("edition.source is invalid");
  const format = (e.format ?? "print") as BookFormat;
  if (!FORMATS.includes(format)) throw new ValidationError("edition.format is invalid");

  let isbn13 = e.isbn13 == null ? null : cleanIsbn(String(e.isbn13));
  let isbn10 = e.isbn10 == null ? null : cleanIsbn(String(e.isbn10));
  if (isbn13 === "") isbn13 = null;
  if (isbn10 === "") isbn10 = null;
  if (isbn13 !== null && !isValidIsbn13(isbn13)) {
    throw new ValidationError("edition.isbn13 is invalid");
  }
  if (isbn10 !== null && !isValidIsbn10(isbn10)) {
    throw new ValidationError("edition.isbn10 is invalid");
  }
  if (isbn13 === null && isbn10 !== null) isbn13 = isbn10To13(isbn10);

  const pageCount = int(e.page_count, "edition.page_count", 1, 20000);
  if (source === "user") {
    if (authors.length === 0) throw new ValidationError("manual books need an author");
    if (pageCount === null) throw new ValidationError("manual books need a page count");
  }

  let workCover = httpsUrl(
    w.cover_url,
    "work.cover_url",
    source === "user" ? options.userCoverPrefix : null,
  );
  const editionCover = httpsUrl(
    e.cover_url,
    "edition.cover_url",
    source === "user" ? options.userCoverPrefix : null,
  );
  if (source === "user") workCover = workCover ?? editionCover;

  return {
    work: {
      title,
      subtitle: str(w.subtitle, "work.subtitle", 500),
      authors,
      first_published_year: int(w.first_published_year, "work.first_published_year", -3000, 3000),
      cover_url: workCover,
      open_library_work_key: source === "user" ? null : olKey,
    },
    edition: {
      isbn13,
      isbn10,
      format,
      page_count: pageCount,
      publisher: str(e.publisher, "edition.publisher", 300),
      published_date: str(e.published_date, "edition.published_date", 50),
      language: str(e.language, "edition.language", 20),
      cover_url: editionCover,
      source,
    },
  };
}
