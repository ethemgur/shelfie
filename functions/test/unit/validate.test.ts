import { describe, expect, it } from "vitest";
import {
  cleanIsbn,
  editionDocId,
  isbn10To13,
  isValidIsbn10,
  isValidIsbn13,
  parseUpsertBookInput,
  ValidationError,
  workDocId,
} from "../../src/validate";

const uid = "uid-1";

const olResult = {
  work: {
    title: "  Pride and Prejudice ",
    authors: ["Jane Austen", " "],
    openLibraryWorkKey: "/works/OL66554W",
    coverUrl: "https://covers.openlibrary.org/b/id/1-L.jpg",
    firstPublishedYear: 1813,
  },
  edition: { isbn13: "978-0-14-143951-8", pageCount: 480, source: "open_library" },
};

describe("ISBN helpers", () => {
  it("checks checksums and converts ISBN-10", () => {
    expect(isValidIsbn13("9780141439518")).toBe(true);
    expect(isValidIsbn13("9780141439519")).toBe(false);
    expect(isValidIsbn10("0141439513")).toBe(true);
    expect(isValidIsbn10("080442957X")).toBe(true);
    expect(isValidIsbn10("0141439514")).toBe(false);
    expect(isbn10To13("0141439513")).toBe("9780141439518");
    expect(cleanIsbn(" 080-442-957x ")).toBe("080442957X");
  });
});

describe("parseUpsertBookInput", () => {
  it("normalises an Open Library result", () => {
    const input = parseUpsertBookInput(olResult, uid);
    expect(input.work.title).toBe("Pride and Prejudice");
    expect(input.work.authors).toEqual(["Jane Austen"]);
    expect(input.edition.isbn13).toBe("9780141439518");
    expect(input.edition.format).toBe("print");
  });

  it("derives ISBN-13 from ISBN-10", () => {
    const input = parseUpsertBookInput(
      { ...olResult, edition: { isbn10: "0141439513", source: "google_books" } },
      uid,
    );
    expect(input.edition.isbn13).toBe("9780141439518");
  });

  it("rejects bad input", () => {
    const bad: unknown[] = [
      null,
      { work: { title: "" }, edition: { source: "open_library" } },
      { ...olResult, edition: { ...olResult.edition, isbn13: "9780141439519" } },
      { ...olResult, edition: { ...olResult.edition, source: "amazon" } },
      { ...olResult, edition: { ...olResult.edition, pageCount: 0 } },
      { ...olResult, edition: { ...olResult.edition, format: "scroll" } },
      { ...olResult, work: { ...olResult.work, openLibraryWorkKey: "OL1W; drop" } },
      { ...olResult, work: { ...olResult.work, coverUrl: "http://insecure.example/c.jpg" } },
    ];
    for (const body of bad) {
      expect(() => parseUpsertBookInput(body, uid)).toThrow(ValidationError);
    }
  });

  it("manual books need an author and a page count", () => {
    const manual = { work: { title: "My Zine", authors: ["Me"] }, edition: { source: "user", pageCount: 40 } };
    expect(parseUpsertBookInput(manual, uid).edition.pageCount).toBe(40);
    expect(() => parseUpsertBookInput({ ...manual, edition: { source: "user" } }, uid)).toThrow(ValidationError);
    expect(() => parseUpsertBookInput({ ...manual, work: { title: "My Zine" } }, uid)).toThrow(ValidationError);
  });

  it("manual books only take covers from the caller's own folder", () => {
    const manual = (coverPath: string) => ({
      work: { title: "My Zine", authors: ["Me"], openLibraryWorkKey: "/works/OL1W" },
      edition: { source: "user", pageCount: 40, coverUrl: "https://evil.example/x.jpg" },
      coverPath,
    });
    const ok = parseUpsertBookInput(manual(`covers/${uid}/a.jpg`), uid);
    expect(ok.coverPath).toBe(`covers/${uid}/a.jpg`);
    expect(ok.work.openLibraryWorkKey).toBeNull();
    expect(ok.edition.coverUrl).toBeNull(); // URLs from the client are ignored
    for (const path of ["covers/other/a.jpg", `covers/${uid}/../other/a.jpg`, "avatars/uid-1/a.jpg"]) {
      expect(() => parseUpsertBookInput(manual(path), uid)).toThrow(ValidationError);
    }
  });
});

describe("deterministic ids", () => {
  it("works use the Open Library id; editions the ISBN, else a content key", () => {
    const input = parseUpsertBookInput(olResult, uid);
    expect(workDocId(input.work)).toBe("OL66554W");
    expect(editionDocId("OL66554W", input.edition)).toBe("9780141439518");
    const noIsbn = parseUpsertBookInput({ ...olResult, edition: { source: "open_library", pageCount: 432 } }, uid);
    expect(editionDocId("OL66554W", noIsbn.edition)).toBe("OL66554W_open_library_print_432");
    const manual = parseUpsertBookInput(
      { work: { title: "Z", authors: ["Me"] }, edition: { source: "user", pageCount: 4 } },
      uid,
    );
    expect(workDocId(manual.work)).toBeNull();
    expect(editionDocId("w", manual.edition)).toBeNull();
  });
});
