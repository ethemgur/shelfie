# Web end-to-end test

Clicks through Phase 1 in headless Chromium against a local Supabase stack:
sign-in (magic-link code from Mailpit), profile setup, search, book page,
shelves, change edition, manual add, the rendering spike's export buttons and
sign-out, then checks the resulting rows in Postgres.

```bash
npx supabase start
npx supabase functions serve &                 # upsert_book
flutter build web --release --no-web-resources-cdn \
  --dart-define=SUPABASE_URL=http://127.0.0.1:54321 \
  --dart-define=SUPABASE_ANON_KEY=<ANON_KEY from `npx supabase status`>
cd test/e2e && npm install && npx playwright install chromium
npx serve -s ../../build/web -l 3000 &
npm test                                       # SHOTS=/tmp/shots for screenshots
```

Open Library / Google Books responses are fixtures in the script, so results
don't depend on those services. Flutter web draws to a canvas, so the test
turns on Flutter's semantics tree and finds elements by accessibility role and
label. A failing lookup often means a missing or wrong semantics label.

Environment variables: `APP_URL` (default `http://localhost:3000`),
`SHOTS` (screenshot folder), `CHROMIUM_PATH` (use an existing Chromium), and
`FUNCTIONS_PROXY` (send `upsert_book` calls to another URL, e.g. a host
`deno run` of the function if the Docker edge runtime can't reach npm).
