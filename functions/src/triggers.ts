import { getFirestore } from "firebase-admin/firestore";
import { onDocumentCreated, onDocumentWritten } from "firebase-functions/v2/firestore";

const region = "europe-west1";

/** Blocking removes existing follows in both directions (Section 5). */
export const onBlockCreated = onDocumentCreated(
  { document: "blocks/{blockId}", region },
  async (event) => {
    const block = event.data?.data();
    if (!block) return;
    const { blockerId, blockedId } = block as { blockerId: string; blockedId: string };
    const db = getFirestore();
    const batch = db.batch();
    batch.delete(db.doc(`follows/${blockerId}_${blockedId}`));
    batch.delete(db.doc(`follows/${blockedId}_${blockerId}`));
    await batch.commit();
  },
);

/**
 * `userBooks.currentPage` = `toPage` of the latest non-deleted update (by
 * `createdAt`), Section 8.1. Leaves it alone when a book has no updates left
 * (e.g. imported history).
 */
export const onPageUpdateWritten = onDocumentWritten(
  { document: "pageUpdates/{updateId}", region },
  async (event) => {
    const data = event.data?.after.data() ?? event.data?.before.data();
    if (!data) return;
    const userBookId = data.userBookId as string;
    const db = getFirestore();
    const latest = await db
      .collection("pageUpdates")
      .where("userBookId", "==", userBookId)
      .where("deletedAt", "==", null)
      .orderBy("createdAt", "desc")
      .limit(1)
      .get();
    if (latest.empty) return;
    const page = latest.docs[0].get("toPage") as number;
    const bookRef = db.doc(`userBooks/${userBookId}`);
    await db.runTransaction(async (tx) => {
      const book = await tx.get(bookRef);
      if (book.exists && book.get("currentPage") !== page) {
        tx.update(bookRef, { currentPage: page });
      }
    });
  },
);
