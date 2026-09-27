import { initializeApp } from "firebase-admin/app";

initializeApp();

export { upsertBook } from "./upsertBook";
export { onBlockCreated, onPageUpdateWritten } from "./triggers";
