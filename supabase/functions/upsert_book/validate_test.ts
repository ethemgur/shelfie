import { assertEquals, assertThrows } from "jsr:@std/assert@1";
import {
  cleanIsbn,
  isbn10To13,
  isValidIsbn10,
  isValidIsbn13,
  parseUpsertBookInput,
  ValidationError,
} from "./validate.ts";

const opts = { userCoverPrefix: "https://x.supabase.co/storage/v1/object/public/covers/uid-1/" };

const olResult = {
  work: {
    title: "  Pride and Prejudice ",
    authors: ["Jane Austen", " "],
    open_library_work_key: "/works/OL66554W",
    cover_url: "https://covers.openlibrary.org/b/id/1-L.jpg",
    first_published_year: 1813,
  },
  edition: { isbn13: "978-0-14-143951-8", page_count: 480, source: "open_library" },
};

Deno.test("ISBN checksums", () => {
  assertEquals(isValidIsbn13("9780141439518"), true);
  assertEquals(isValidIsbn13("9780141439519"), false);
  assertEquals(isValidIsbn10("0141439513"), true);
  assertEquals(isValidIsbn10("080442957X"), true);
  assertEquals(isValidIsbn10("0141439514"), false);
  assertEquals(isbn10To13("0141439513"), "9780141439518");
  assertEquals(cleanIsbn(" 080-442-957x "), "080442957X");
});

Deno.test("normalises an Open Library result", () => {
  const input = parseUpsertBookInput(olResult, opts);
  assertEquals(input.work.title, "Pride and Prejudice");
  assertEquals(input.work.authors, ["Jane Austen"]);
  assertEquals(input.edition.isbn13, "9780141439518");
  assertEquals(input.edition.format, "print");
});

Deno.test("derives ISBN-13 from ISBN-10", () => {
  const input = parseUpsertBookInput(
    { ...olResult, edition: { isbn10: "0141439513", source: "google_books" } },
    opts,
  );
  assertEquals(input.edition.isbn13, "9780141439518");
});

Deno.test("rejects bad input", () => {
  const bad: unknown[] = [
    null,
    { work: { title: "" }, edition: { source: "open_library" } },
    { ...olResult, edition: { ...olResult.edition, isbn13: "9780141439519" } },
    { ...olResult, edition: { ...olResult.edition, source: "amazon" } },
    { ...olResult, edition: { ...olResult.edition, page_count: 0 } },
    { ...olResult, edition: { ...olResult.edition, format: "scroll" } },
    { ...olResult, work: { ...olResult.work, open_library_work_key: "OL1W; drop" } },
    { ...olResult, work: { ...olResult.work, cover_url: "http://insecure.example/c.jpg" } },
  ];
  for (const body of bad) {
    assertThrows(() => parseUpsertBookInput(body, opts), ValidationError);
  }
});

Deno.test("manual books need an author and a page count", () => {
  const manual = {
    work: { title: "My Zine", authors: ["Me"] },
    edition: { source: "user", page_count: 40, format: "print" },
  };
  assertEquals(parseUpsertBookInput(manual, opts).edition.page_count, 40);
  assertThrows(
    () => parseUpsertBookInput({ ...manual, edition: { source: "user" } }, opts),
    ValidationError,
  );
  assertThrows(
    () => parseUpsertBookInput({ ...manual, work: { title: "My Zine" } }, opts),
    ValidationError,
  );
});

Deno.test("manual books only take covers from the caller's own folder", () => {
  const manual = (cover: string) => ({
    work: { title: "My Zine", authors: ["Me"], open_library_work_key: "/works/OL1W" },
    edition: { source: "user", page_count: 40, cover_url: cover },
  });
  const ok = parseUpsertBookInput(manual(`${opts.userCoverPrefix}a.jpg`), opts);
  assertEquals(ok.work.cover_url, `${opts.userCoverPrefix}a.jpg`);
  assertEquals(ok.work.open_library_work_key, null);
  for (
    const cover of [
      "https://evil.example/a.jpg",
      "https://x.supabase.co/storage/v1/object/public/covers/other-uid/a.jpg",
      `${opts.userCoverPrefix}../other-uid/a.jpg`,
    ]
  ) {
    assertThrows(() => parseUpsertBookInput(manual(cover), opts), ValidationError);
  }
});
