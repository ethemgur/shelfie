import { getFirestore, FieldValue, type Transaction } from "firebase-admin/firestore";
import { getDownloadURL, getStorage } from "firebase-admin/storage";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { logger } from "firebase-functions";
import {
  editionDocId,
  type EditionInput,
  parseUpsertBookInput,
  type UpsertBookInput,
  ValidationError,
  workDocId,
  type WorkInput,
} from "./validate";

/**
 * The only write path into the `works` / `editions` catalogue (clients have
 * read-only rules). Takes a search result or a manual entry, dedupes by
 * ISBN-13 and Open Library work key, and returns the ids.
 *
 * Callable: { work, edition, coverPath? } -> { workId, editionId }
 */
export const upsertBook = onCall({ region: "europe-west1" }, async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Sign in first.");

  let input: UpsertBookInput;
  try {
    input = parseUpsertBookInput(request.data, uid);
  } catch (e) {
    if (e instanceof ValidationError) throw new HttpsError("invalid-argument", e.message);
    throw e;
  }

  if (input.coverPath !== null) {
    const file = getStorage().bucket().file(input.coverPath);
    const [exists] = await file.exists();
    if (!exists) throw new HttpsError("invalid-argument", "Cover photo not found.");
    const url = await getDownloadURL(file);
    input.work.coverUrl = url;
    input.edition.coverUrl = url;
  }

  try {
    return await upsert(input, uid);
  } catch (e) {
    logger.error("upsertBook failed", e);
    throw new HttpsError("internal", "Could not save the book.");
  }
});

async function upsert(input: UpsertBookInput, uid: string) {
  const db = getFirestore();
  // Transactions need every read before any write: resolve all refs first.
  return db.runTransaction(async (tx) => {
    const { work, edition } = input;

    // 1. Same ISBN-13 → same edition. Fill in blanks, never overwrite.
    if (edition.isbn13 !== null) {
      const ref = db.collection("editions").doc(edition.isbn13);
      const snap = await tx.get(ref);
      if (snap.exists) {
        fillBlanks(tx, ref, snap.data()!, edition, ["pageCount", "coverUrl", "isbn10", "publisher"]);
        return { workId: snap.get("workId") as string, editionId: ref.id };
      }
    }

    // 2. Work by Open Library key (deterministic id), else a new work.
    const workKey = workDocId(work);
    const workRef = workKey === null
      ? db.collection("works").doc()
      : db.collection("works").doc(workKey);
    const workSnap = workKey === null ? null : await tx.get(workRef);

    // 3. Edition by deterministic id, else a new one.
    const editionKey = editionDocId(workRef.id, edition);
    const editionRef = editionKey === null
      ? db.collection("editions").doc()
      : db.collection("editions").doc(editionKey);
    const editionSnap = editionKey === null ? null : await tx.get(editionRef);

    // Writes.
    if (workSnap?.exists) {
      fillBlanks(tx, workRef, workSnap.data()!, work, ["coverUrl"]);
    } else {
      tx.create(workRef, {
        ...work,
        // Lower-cased title for prefix search in the catalogue.
        titleLower: work.title.toLowerCase(),
        createdAt: FieldValue.serverTimestamp(),
      });
    }
    if (!editionSnap?.exists) {
      tx.create(editionRef, {
        ...edition,
        workId: workRef.id,
        createdBy: edition.source === "user" ? uid : null,
        createdAt: FieldValue.serverTimestamp(),
      });
    }
    return { workId: workRef.id, editionId: editionRef.id };
  });
}

function fillBlanks<T extends WorkInput | EditionInput>(
  tx: Transaction,
  ref: FirebaseFirestore.DocumentReference,
  existing: FirebaseFirestore.DocumentData,
  input: T,
  fields: (keyof T & string)[],
) {
  const patch: Record<string, unknown> = {};
  for (const field of fields) {
    if (existing[field] == null && input[field] != null) patch[field] = input[field];
  }
  if (Object.keys(patch).length > 0) tx.update(ref, patch);
}
