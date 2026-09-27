// Pure input validation/normalisation for `upsertBook`. No I/O, so it can be
// unit-tested without emulators.

export type BookFormat = "print" | "ebook" | "audiobook";
export type EditionSource = "open_library" | "google_books" | "user";

export interface WorkInput {
  title: string;
  subtitle: string | null;
  authors: string[];
  firstPublishedYear: number | null;
  coverUrl: string | null;
  openLibraryWorkKey: string | null;
}

export interface EditionInput {
  isbn13: string | null;
  isbn10: string | null;
  format: BookFormat;
  pageCount: number | null;
  publisher: string | null;
  publishedDate: string | null;
  language: string | null;
  coverUrl: string | null;
  source: EditionSource;
}

export interface UpsertBookInput {
  work: WorkInput;
  edition: EditionInput;
  /**
   * Manual books only: Storage path of the uploaded cover photo, always
   * inside the caller's own `covers/<uid>/` folder.
   */
  coverPath: string | null;
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

function httpsUrl(value: unknown, field: string): string | null {
  const url = str(value, field, 2000);
  if (url === null) return null;
  let parsed: URL;
  try {
    parsed = new URL(url);
  } catch {
    throw new ValidationError(`${field} must be an https URL`);
  }
  if (parsed.protocol !== "https:") throw new ValidationError(`${field} must be an https URL`);
  return url;
}

/**
 * Validates and normalises the request body. ISBNs are cleaned and
 * checksum-verified; an ISBN-10 alone also yields its ISBN-13.
 */
export function parseUpsertBookInput(body: unknown, uid: string): UpsertBookInput {
  if (typeof body !== "object" || body === null) throw new ValidationError("body must be an object");
  const { work, edition, coverPath } = body as Record<string, unknown>;
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

  const olKey = str(w.openLibraryWorkKey, "work.openLibraryWorkKey", 40);
  if (olKey !== null && !/^\/works\/OL\d+W$/.test(olKey)) {
    throw new ValidationError("work.openLibraryWorkKey must look like /works/OL123W");
  }

  const source = e.source as EditionSource;
  if (!SOURCES.includes(source)) throw new ValidationError("edition.source is invalid");
  const format = (e.format ?? "print") as BookFormat;
  if (!FORMATS.includes(format)) throw new ValidationError("edition.format is invalid");

  let isbn13 = e.isbn13 == null ? null : cleanIsbn(String(e.isbn13));
  let isbn10 = e.isbn10 == null ? null : cleanIsbn(String(e.isbn10));
  if (isbn13 === "") isbn13 = null;
  if (isbn10 === "") isbn10 = null;
  if (isbn13 !== null && !isValidIsbn13(isbn13)) throw new ValidationError("edition.isbn13 is invalid");
  if (isbn10 !== null && !isValidIsbn10(isbn10)) throw new ValidationError("edition.isbn10 is invalid");
  if (isbn13 === null && isbn10 !== null) isbn13 = isbn10To13(isbn10);

  const pageCount = int(e.pageCount, "edition.pageCount", 1, 20000);
  let cover: string | null = null;
  if (source === "user") {
    if (authors.length === 0) throw new ValidationError("manual books need an author");
    if (pageCount === null) throw new ValidationError("manual books need a page count");
    cover = str(coverPath, "coverPath", 300);
    if (cover !== null && (!cover.startsWith(`covers/${uid}/`) || cover.includes(".."))) {
      throw new ValidationError("coverPath must be a photo you uploaded");
    }
  }

  return {
    work: {
      title,
      subtitle: str(w.subtitle, "work.subtitle", 500),
      authors,
      firstPublishedYear: int(w.firstPublishedYear, "work.firstPublishedYear", -3000, 3000),
      // Manual books get their cover from coverPath (resolved server-side).
      coverUrl: source === "user" ? null : httpsUrl(w.coverUrl, "work.coverUrl"),
      openLibraryWorkKey: source === "user" ? null : olKey,
    },
    edition: {
      isbn13,
      isbn10,
      format,
      pageCount,
      publisher: str(e.publisher, "edition.publisher", 300),
      publishedDate: str(e.publishedDate, "edition.publishedDate", 50),
      language: str(e.language, "edition.language", 20),
      coverUrl: source === "user" ? null : httpsUrl(e.coverUrl, "edition.coverUrl"),
      source,
    },
    coverPath: cover,
  };
}

/**
 * Deterministic document ids make dedupe race-free: two concurrent adds of
 * the same book write the same document.
 *  - work: the Open Library id (`OL66554W`), else random
 *  - edition: the ISBN-13, else `<workId>_<source>_<format>_<pages>`, and
 *    manual editions are always new (random).
 */
export function workDocId(work: WorkInput): string | null {
  return work.openLibraryWorkKey?.replace("/works/", "") ?? null;
}

export function editionDocId(workId: string, edition: EditionInput): string | null {
  if (edition.isbn13 !== null) return edition.isbn13;
  if (edition.source === "user") return null;
  return `${workId}_${edition.source}_${edition.format}_${edition.pageCount ?? "x"}`;
}
