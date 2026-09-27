// Security rules tests (Phase 1 acceptance: users cannot read others'
// private data). Runs against the Firestore and Storage emulators:
//   npm run test:emulator   (from functions/)
//
// Cast: A = author, B = stranger, C = follows A, D = blocked by A.
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
  type RulesTestContext,
  type RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import {
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  query,
  serverTimestamp,
  setDoc,
  Timestamp,
  updateDoc,
  where,
  writeBatch,
} from "firebase/firestore";
import { ref, uploadBytes } from "firebase/storage";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";

const A = "author";
const B = "stranger";
const C = "follower";
const D = "blocked";
const WORK = "OL1W";
const EDITION = "9780000000002";

let env: RulesTestEnvironment;
const as = (uid: string) => env.authenticatedContext(uid).firestore();
const anon = () => env.unauthenticatedContext().firestore();

beforeAll(async () => {
  env = await initializeTestEnvironment({
    projectId: "demo-shelfie",
    firestore: { rules: readFileSync(resolve(__dirname, "../../../firestore.rules"), "utf8") },
    storage: { rules: readFileSync(resolve(__dirname, "../../../storage.rules"), "utf8") },
  });
});

afterAll(() => env.cleanup());

const profile = (username: string) => ({
  username,
  displayName: username.toUpperCase(),
  weeklyPageGoal: 150,
  defaultVisibility: "followers",
  timezone: "UTC",
  createdAt: Timestamp.now(),
});

const update = (id: string, visibility: string, extra: Record<string, unknown> = {}) => ({
  userId: A,
  userBookId: `${A}_${WORK}`,
  workId: WORK,
  fromPage: 0,
  toPage: 50,
  pagesRead: 50,
  pageCount: 384,
  progressPct: 13.02,
  isFinish: false,
  quote: `${id} quote`,
  visibility,
  localDate: "2026-09-01",
  createdAt: Timestamp.fromMillis(Date.parse("2026-09-01T10:00:00Z") + Number(id.slice(-1)) * 1000),
  receivedAt: Timestamp.now(),
  deletedAt: null,
  ...extra,
});

beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (ctx: RulesTestContext) => {
    const db = ctx.firestore();
    for (const uid of [A, B, C, D]) {
      await setDoc(doc(db, "profiles", uid), profile(uid));
      await setDoc(doc(db, "usernames", uid), { uid });
    }
    await setDoc(doc(db, "works", WORK), { title: "Work One", titleLower: "work one", authors: ["Someone"] });
    await setDoc(doc(db, "editions", EDITION), { workId: WORK, isbn13: EDITION, pageCount: 384, source: "open_library" });
    await setDoc(doc(db, "userBooks", `${A}_${WORK}`), {
      userId: A, workId: WORK, editionId: EDITION, shelf: "currently_reading", currentPage: 120,
      source: "app", createdAt: Timestamp.now(), updatedAt: Timestamp.now(),
    });
    await setDoc(doc(db, "userBooks", `${D}_${WORK}`), {
      userId: D, workId: WORK, shelf: "want_to_read", currentPage: 0,
      source: "app", createdAt: Timestamp.now(), updatedAt: Timestamp.now(),
    });
    await setDoc(doc(db, "pageUpdates", "pu1"), update("pu1", "public"));
    await setDoc(doc(db, "pageUpdates", "pu2"), update("pu2", "followers"));
    await setDoc(doc(db, "pageUpdates", "pu3"), update("pu3", "private"));
    await setDoc(doc(db, "pageUpdates", "pu4"), update("pu4", "public", { deletedAt: Timestamp.now() }));
    await setDoc(doc(db, "follows", `${C}_${A}`), { followerId: C, followeeId: A, createdAt: Timestamp.now() });
    await setDoc(doc(db, "blocks", `${A}_${D}`), { blockerId: A, blockedId: D, createdAt: Timestamp.now() });
    await setDoc(doc(db, "reports", "r1"), { reporterId: A, targetType: "profile", targetId: D, reason: "spam", createdAt: Timestamp.now() });
    await setDoc(doc(db, "notifications", "n1"), { userId: A, type: "new_follower", actorId: C, payload: {}, readAt: null, createdAt: Timestamp.now() });
    await setDoc(doc(db, "shareEvents", "s1"), { userId: A, templateId: "session_minimal", family: "session", format: "story", target: "system_share", createdAt: Timestamp.now() });
    await setDoc(doc(db, "profiles", A, "deviceTokens", "token-a"), { platform: "android", updatedAt: Timestamp.now() });
    await setDoc(doc(db, "comments", "cB"), { pageUpdateId: "pu1", userId: B, body: "Nice", anchorPct: null, createdAt: Timestamp.now(), deletedAt: null });
  });
});

const visibleQuotes = async (uid: string) => {
  const db = as(uid);
  const quotes: string[] = [];
  for (const id of ["pu1", "pu2", "pu3", "pu4"]) {
    try {
      quotes.push((await getDoc(doc(db, "pageUpdates", id))).get("quote"));
    } catch {
      // not visible
    }
  }
  return quotes;
};

describe("signed out", () => {
  it("reads nothing", async () => {
    await assertFails(getDoc(doc(anon(), "profiles", A)));
    await assertFails(getDoc(doc(anon(), "works", WORK)));
    await assertFails(getDoc(doc(anon(), "pageUpdates", "pu1")));
    await assertFails(getDoc(doc(anon(), "userBooks", `${A}_${WORK}`)));
  });
});

describe("stranger B", () => {
  it("reads profiles, the catalogue and public shelves", async () => {
    await assertSucceeds(getDoc(doc(as(B), "profiles", A)));
    await assertSucceeds(getDoc(doc(as(B), "works", WORK)));
    await assertSucceeds(getDoc(doc(as(B), "editions", EDITION)));
    await assertSucceeds(getDocs(query(collection(as(B), "userBooks"), where("userId", "==", A))));
  });

  it("sees only A's public, non-deleted update", async () => {
    expect(await visibleQuotes(B)).toEqual(["pu1 quote"]);
  });

  it("can list A's public updates but not everything of A's", async () => {
    await assertSucceeds(getDocs(query(collection(as(B), "pageUpdates"),
      where("userId", "==", A), where("visibility", "==", "public"), where("deletedAt", "==", null))));
    await assertFails(getDocs(query(collection(as(B), "pageUpdates"), where("userId", "==", A))));
  });

  it("cannot see other users' private collections", async () => {
    const db = as(B);
    await assertFails(getDoc(doc(db, "blocks", `${A}_${D}`)));
    await assertFails(getDoc(doc(db, "reports", "r1")));
    await assertFails(getDoc(doc(db, "notifications", "n1")));
    await assertFails(getDoc(doc(db, "shareEvents", "s1")));
    await assertFails(getDoc(doc(db, "profiles", A, "deviceTokens", "token-a")));
    await assertFails(getDoc(doc(db, "profiles", A, "weeklyResults", "2026-09-07")));
  });

  it("cannot write the catalogue", async () => {
    await assertFails(setDoc(doc(as(B), "works", "vandal"), { title: "Vandalised" }));
    await assertFails(setDoc(doc(as(B), "editions", "vandal"), { workId: WORK, source: "user" }));
    await assertFails(updateDoc(doc(as(B), "works", WORK), { title: "Vandalised" }));
  });

  it("cannot touch A's profile, shelves or updates", async () => {
    await assertFails(updateDoc(doc(as(B), "profiles", A), { displayName: "hacked" }));
    await assertFails(setDoc(doc(as(B), "userBooks", `${A}_OL2W`), {
      userId: A, workId: WORK, shelf: "read", currentPage: 0, source: "app",
      createdAt: serverTimestamp(), updatedAt: serverTimestamp(),
    }));
    await assertFails(updateDoc(doc(as(B), "userBooks", `${A}_${WORK}`), { shelf: "dnf", updatedAt: serverTimestamp() }));
    await assertFails(deleteDoc(doc(as(B), "userBooks", `${A}_${WORK}`)));
    await assertFails(updateDoc(doc(as(B), "pageUpdates", "pu1"), { deletedAt: serverTimestamp() }));
    await assertFails(setDoc(doc(as(B), "pageUpdates", "pu9"), {
      ...update("pu9", "public"), userId: B, receivedAt: serverTimestamp(),
    }));
  });

  it("can check for a shelf entry that doesn't exist yet", async () => {
    await assertSucceeds(getDoc(doc(as(B), "userBooks", `${B}_${WORK}`)));
  });

  it("can shelve a book on their own shelf only, one entry per work", async () => {
    const mine = {
      userId: B, workId: WORK, editionId: EDITION, shelf: "want_to_read", currentPage: 0, source: "app",
      createdAt: serverTimestamp(), updatedAt: serverTimestamp(),
    };
    await assertFails(setDoc(doc(as(B), "userBooks", "random-id"), mine));
    await assertSucceeds(setDoc(doc(as(B), "userBooks", `${B}_${WORK}`), mine));
    await assertSucceeds(updateDoc(doc(as(B), "userBooks", `${B}_${WORK}`), {
      shelf: "read", rating: 4.5, reviewLine: "Loved it", finishedAt: "2026-09-26", updatedAt: serverTimestamp(),
    }));
    await assertFails(updateDoc(doc(as(B), "userBooks", `${B}_${WORK}`), { rating: 4.3, updatedAt: serverTimestamp() }));
    await assertFails(updateDoc(doc(as(B), "userBooks", `${B}_${WORK}`), { shelf: "abandoned", updatedAt: serverTimestamp() }));
  });

  it("cannot follow on someone else's behalf", async () => {
    await assertFails(setDoc(doc(as(B), "follows", `${C}_${B}`), { followerId: C, followeeId: B, createdAt: serverTimestamp() }));
    await assertSucceeds(setDoc(doc(as(B), "follows", `${B}_${A}`), { followerId: B, followeeId: A, createdAt: serverTimestamp() }));
  });

  it("gives kudos and comments only on visible updates", async () => {
    const kudos = (id: string) => setDoc(doc(as(B), "kudos", `${B}_${id}`), { userId: B, pageUpdateId: id, createdAt: serverTimestamp() });
    await assertSucceeds(kudos("pu1"));
    await assertFails(kudos("pu2")); // followers-only, B doesn't follow A
    await assertFails(kudos("pu3")); // private
    await assertFails(kudos("pu4")); // deleted
    const comment = (id: string) => setDoc(doc(collection(as(B), "comments")), {
      pageUpdateId: id, userId: B, body: "Hi", anchorPct: null, createdAt: serverTimestamp(), deletedAt: null,
    });
    await assertSucceeds(comment("pu1"));
    await assertFails(comment("pu3"));
  });
});

describe("usernames", () => {
  const claim = (uid: string, username: string) => {
    const db = as(uid);
    const batch = writeBatch(db);
    batch.set(doc(db, "usernames", username), { uid });
    batch.set(doc(db, "profiles", uid), { ...profile(username), createdAt: serverTimestamp() });
    return batch.commit();
  };

  it("a new user claims a free username with their profile", async () => {
    await assertSucceeds(claim("newbie", "newbie_1"));
  });

  it("taken usernames can't be claimed", async () => {
    await assertFails(claim("newbie", A));
  });

  it("a profile needs its username claimed in the same write", async () => {
    await assertFails(setDoc(doc(as("newbie"), "profiles", "newbie"), { ...profile("newbie_2"), createdAt: serverTimestamp() }));
  });

  it("usernames must be valid and can't be renamed here", async () => {
    await assertFails(claim("newbie", "No Spaces"));
    await assertFails(updateDoc(doc(as(A), "profiles", A), { username: "renamed" }));
  });
});

describe("follower C", () => {
  it("sees public and followers-only updates, not private or deleted", async () => {
    expect(await visibleQuotes(C)).toEqual(["pu1 quote", "pu2 quote"]);
  });

  it("sees B's comment on a visible update but can't delete it", async () => {
    await assertSucceeds(getDoc(doc(as(C), "comments", "cB")));
    await assertFails(deleteDoc(doc(as(C), "comments", "cB")));
  });
});

describe("blocked D", () => {
  it("sees none of A's updates or shelves", async () => {
    expect(await visibleQuotes(D)).toEqual([]);
    await assertFails(getDocs(query(collection(as(D), "userBooks"), where("userId", "==", A))));
  });

  it("cannot give kudos to or follow A", async () => {
    await assertFails(setDoc(doc(as(D), "kudos", `${D}_pu1`), { userId: D, pageUpdateId: "pu1", createdAt: serverTimestamp() }));
    await assertFails(setDoc(doc(as(D), "follows", `${D}_${A}`), { followerId: D, followeeId: A, createdAt: serverTimestamp() }));
  });
});

describe("author A", () => {
  it("sees all own updates including private and deleted", async () => {
    expect(await visibleQuotes(A)).toEqual(["pu1 quote", "pu2 quote", "pu3 quote", "pu4 quote"]);
  });

  it("cannot see shelves of someone A blocked", async () => {
    await assertFails(getDocs(query(collection(as(A), "userBooks"), where("userId", "==", D))));
  });

  it("sees own reports, notifications and device tokens", async () => {
    await assertSucceeds(getDoc(doc(as(A), "reports", "r1")));
    await assertSucceeds(getDocs(query(collection(as(A), "notifications"), where("userId", "==", A))));
    await assertSucceeds(getDoc(doc(as(A), "profiles", A, "deviceTokens", "token-a")));
  });

  it("can only mark notifications read", async () => {
    await assertSucceeds(updateDoc(doc(as(A), "notifications", "n1"), { readAt: serverTimestamp() }));
    await assertFails(updateDoc(doc(as(A), "notifications", "n1"), { type: "kudos" }));
    await assertFails(setDoc(doc(as(A), "notifications", "n2"), { userId: A, type: "kudos" }));
  });

  it("can delete comments on own update", async () => {
    await assertSucceeds(deleteDoc(doc(as(A), "comments", "cB")));
  });

  it("logs page updates only against own books, with exact pagesRead", async () => {
    const mine = { ...update("pu5", "public"), receivedAt: serverTimestamp() };
    await assertSucceeds(setDoc(doc(as(A), "pageUpdates", "pu5"), mine));
    await assertFails(setDoc(doc(as(A), "pageUpdates", "pu6"), { ...mine, pagesRead: 49 }));
    await assertFails(setDoc(doc(as(A), "pageUpdates", "pu7"), { ...mine, minutes: 30 }));
  });

  it("soft-deletes but never hard-deletes updates", async () => {
    await assertSucceeds(updateDoc(doc(as(A), "pageUpdates", "pu1"), { deletedAt: serverTimestamp() }));
    await assertFails(deleteDoc(doc(as(A), "pageUpdates", "pu2")));
    await assertFails(updateDoc(doc(as(A), "pageUpdates", "pu2"), { toPage: 99 }));
  });
});

describe("storage", () => {
  const png = new Uint8Array([137, 80, 78, 71]);
  it("users upload images only into their own folder", async () => {
    const storage = env.authenticatedContext(B).storage();
    await assertSucceeds(uploadBytes(ref(storage, `avatars/${B}/a.jpg`), png, { contentType: "image/jpeg" }));
    await assertFails(uploadBytes(ref(storage, `avatars/${A}/a.jpg`), png, { contentType: "image/jpeg" }));
    await assertFails(uploadBytes(ref(storage, `covers/${B}/a.txt`), png, { contentType: "text/plain" }));
    await assertFails(uploadBytes(ref(env.unauthenticatedContext().storage(), `covers/${B}/b.jpg`), png, { contentType: "image/jpeg" }));
  });
});
