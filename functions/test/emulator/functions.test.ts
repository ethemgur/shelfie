// Cloud Functions against the emulators: upsertBook (callable) and the
// Firestore triggers. Run with `npm run test:emulator`.
import { deleteApp as deleteAdminApp, initializeApp as initAdmin } from "firebase-admin/app";
import { getFirestore as adminFirestore, Timestamp } from "firebase-admin/firestore";
import { deleteApp, initializeApp } from "firebase/app";
import { connectAuthEmulator, createUserWithEmailAndPassword, getAuth } from "firebase/auth";
import { connectFunctionsEmulator, getFunctions, httpsCallable } from "firebase/functions";
import { connectStorageEmulator, getStorage, ref, uploadBytes } from "firebase/storage";
import { afterAll, beforeAll, describe, expect, it } from "vitest";

const projectId = "demo-shelfie";
const admin = initAdmin({ projectId, storageBucket: `${projectId}.appspot.com` }, "admin");
const db = adminFirestore(admin);
const app = initializeApp({ projectId, apiKey: "demo-key", storageBucket: `${projectId}.appspot.com` });
const auth = getAuth(app);
const functions = getFunctions(app, "europe-west1");
const storage = getStorage(app);
connectAuthEmulator(auth, "http://127.0.0.1:9099", { disableWarnings: true });
connectFunctionsEmulator(functions, "127.0.0.1", 5001);
connectStorageEmulator(storage, "127.0.0.1", 9199);

type Ids = { workId: string; editionId: string };
const upsertBook = httpsCallable<unknown, Ids>(functions, "upsertBook");
let uid: string;

beforeAll(async () => {
  const cred = await createUserWithEmailAndPassword(auth, `fn${Date.now()}@test.dev`, "password123");
  uid = cred.user.uid;
});

afterAll(async () => {
  await deleteApp(app);
  await deleteAdminApp(admin);
});

async function eventually<T>(read: () => Promise<T>, done: (v: T) => boolean): Promise<T> {
  for (let i = 0; i < 40; i++) {
    const value = await read();
    if (done(value)) return value;
    await new Promise((r) => setTimeout(r, 250));
  }
  return read();
}

const pride = (edition: Record<string, unknown>) => ({
  work: { title: "Pride and Prejudice", authors: ["Jane Austen"], openLibraryWorkKey: "/works/OL66554W" },
  edition: { source: "open_library", ...edition },
});

describe("upsertBook", () => {
  it("dedupes by ISBN and fills blanks without overwriting", async () => {
    const first = (await upsertBook(pride({ isbn13: "9780141439518" }))).data;
    const again = (await upsertBook(pride({ isbn13: "9780141439518", pageCount: 480, publisher: "Penguin" }))).data;
    const viaIsbn10 = (await upsertBook(pride({ isbn10: "0141439513", pageCount: 999 }))).data;
    expect(first).toEqual({ workId: "OL66554W", editionId: "9780141439518" });
    expect(again).toEqual(first);
    expect(viaIsbn10).toEqual(first);
    const edition = (await db.doc("editions/9780141439518").get()).data()!;
    expect(edition.pageCount).toBe(480); // filled once, not overwritten by 999
    expect(edition.publisher).toBe("Penguin");
    expect((await db.doc("works/OL66554W").get()).get("titleLower")).toBe("pride and prejudice");
  });

  it("reuses ISBN-less editions with the same source, format and pages", async () => {
    const a = (await upsertBook(pride({ pageCount: 432 }))).data;
    const b = (await upsertBook(pride({ pageCount: 432 }))).data;
    const c = (await upsertBook(pride({ pageCount: 500 }))).data;
    expect(a).toEqual(b);
    expect(c.editionId).not.toBe(a.editionId);
    expect(c.workId).toBe("OL66554W");
  });

  it("adds manual books with the caller's own cover photo", async () => {
    const coverPath = `covers/${uid}/zine.jpg`;
    await uploadBytes(ref(storage, coverPath), new Uint8Array([255, 216, 255]), { contentType: "image/jpeg" });
    const ids = (await upsertBook({
      work: { title: "My Zine", authors: ["Me"] },
      edition: { source: "user", pageCount: 40 },
      coverPath,
    })).data;
    const edition = (await db.doc(`editions/${ids.editionId}`).get()).data()!;
    expect(edition.createdBy).toBe(uid);
    expect(edition.coverUrl).toContain("zine.jpg");
    expect((await db.doc(`works/${ids.workId}`).get()).get("coverUrl")).toBe(edition.coverUrl);
  });

  it("rejects invalid input and missing covers", async () => {
    await expect(upsertBook({ work: { title: "" }, edition: { source: "open_library" } }))
      .rejects.toMatchObject({ code: "functions/invalid-argument" });
    await expect(upsertBook({
      work: { title: "Z", authors: ["Me"] },
      edition: { source: "user", pageCount: 4 },
      coverPath: `covers/${uid}/missing.jpg`,
    })).rejects.toMatchObject({ code: "functions/invalid-argument" });
  });

  it("requires sign-in", async () => {
    const other = initializeApp({ projectId, apiKey: "demo-key" }, "signed-out");
    const fns = getFunctions(other, "europe-west1");
    connectFunctionsEmulator(fns, "127.0.0.1", 5001);
    await expect(httpsCallable(fns, "upsertBook")(pride({})))
      .rejects.toMatchObject({ code: "functions/unauthenticated" });
    await deleteApp(other);
  });
});

describe("triggers", () => {
  it("blocking removes follows in both directions", async () => {
    await db.doc("follows/x_y").set({ followerId: "x", followeeId: "y", createdAt: Timestamp.now() });
    await db.doc("follows/y_x").set({ followerId: "y", followeeId: "x", createdAt: Timestamp.now() });
    await db.doc("blocks/x_y").set({ blockerId: "x", blockedId: "y", createdAt: Timestamp.now() });
    const left = await eventually(
      async () => (await db.collection("follows").where("followerId", "in", ["x", "y"]).get()).size,
      (n) => n === 0,
    );
    expect(left).toBe(0);
  });

  it("currentPage follows the latest non-deleted update", async () => {
    const book = db.doc("userBooks/u_OL9W");
    await book.set({ userId: "u", workId: "OL9W", shelf: "currently_reading", currentPage: 0 });
    const put = (id: string, toPage: number, minute: number, deletedAt: Timestamp | null = null) =>
      db.doc(`pageUpdates/${id}`).set({
        userId: "u", userBookId: "u_OL9W", workId: "OL9W", toPage, deletedAt,
        createdAt: Timestamp.fromMillis(Date.parse("2026-09-01T10:00:00Z") + minute * 60000),
      });
    await put("p1", 50, 1);
    await put("p2", 120, 2);
    const page = (await eventually(async () => (await book.get()).get("currentPage"), (p) => p === 120));
    expect(page).toBe(120);
    await db.doc("pageUpdates/p2").update({ deletedAt: Timestamp.now() });
    expect(await eventually(async () => (await book.get()).get("currentPage"), (p) => p === 50)).toBe(50);
  });
});
