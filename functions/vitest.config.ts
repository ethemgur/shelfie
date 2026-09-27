import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    // Emulator tests share one Firestore; run files one at a time.
    fileParallelism: false,
    testTimeout: 30000,
    hookTimeout: 30000,
  },
});
