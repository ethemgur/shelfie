# Web end-to-end test

Clicks through Phase 1 in headless Chromium against the Firebase emulators:
email-link sign-in (link read from the Auth emulator), profile setup, search,
book page, shelves, change edition, manual add with a cover photo (Storage), the
rendering spike's export buttons and sign-out. It then checks the resulting
documents in Firestore. Each run starts from empty emulators.

```bash
cd functions && npm install && npm run build && cd ..
npx --prefix functions firebase emulators:start --project demo-shelfie \
  --only auth,firestore,storage,functions &
flutter build web --release --dart-define=USE_FIREBASE_EMULATORS=true
cd test/e2e && npm install && npx playwright install chromium
npx serve -s ../../build/web -l 3000 &
npm test                                       # SHOTS=/tmp/shots for screenshots
```

Open Library / Google Books responses are fixtures in the script, so results
don't depend on those services. Flutter web draws to a canvas, so the test
turns on Flutter's semantics tree and finds elements by accessibility role and
label. A failing lookup often means a missing or wrong semantics label.

Environment variables:
- `APP_URL` (default `http://localhost:3000`)
- `SHOTS`: screenshot folder
- `CHROMIUM_PATH`: use an existing Chromium
- `FIREBASE_JS_DIR`: serve the Firebase JS SDK from a local `firebase` npm
  package (e.g. `functions/node_modules/firebase`) instead of gstatic.com,
  for machines without internet access. Add `--no-web-resources-cdn` to the
  build for the same reason.
