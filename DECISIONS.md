# Decisions

Choices the MVP spec doesn't cover, newest phase last. Each entry says what was
decided, why, and what would change it.

## Phase 0 — Setup & rendering spike

### Working name and ids
Confirmed by the founder as the placeholders to use until the final name is
chosen.
- `[APP_NAME]` is **Shelfie** (the repo name) until the final name is chosen.
  It lives in `lib/l10n/app_en.arb` (`appName`), the Android `app_name`
  resValue and iOS `CFBundleDisplayName`.
- Bundle/application id: `com.shelfie.shelfie` (the existing Android id; iOS
  matches). The dev flavour appends `.dev` on Android.
- Domain placeholder: `shelfie.app` (`APP_DOMAIN` in `env/*.json`).

### Toolchain
- Flutter **3.47.5** stable / Dart 3.13.4, the revision pinned in `.metadata`.
- Dependencies are added in the phase that first needs them. Phase 0 adds
  `flutter_riverpod`, `go_router`, `share_plus`, `path_provider`,
  `cached_network_image`, `intl` and `flutter_localizations`. Codegen
  (`riverpod_generator`, `freezed`, `json_serializable`, `drift`) arrives with
  the first models in Phase 1–2.
- Localisation uses `gen-l10n`. The output goes to `lib/l10n/gen/` and is
  committed so the analyzer and IDE work straight after a clone.
- Feature folders from Section 4 are created when their first file lands, so
  there are no empty placeholder directories.

### Flavours and env config
- Android has `dev` / `prod` product flavours.
- Config is injected with `--dart-define-from-file=env/<flavor>.json`. The
  `*.example.json` files are committed and the real ones are gitignored. None
  of these values is secret: the anon key and Meta App ID ship in the binary
  anyway.
- **iOS flavour schemes are not set up yet.** Creating Xcode build
  configurations and schemes needs Xcode, and hand-editing `project.pbxproj`
  is error-prone. For now iOS builds without `--flavor`, and `Env` falls back
  to the `FLAVOR` define. To do on a Mac before TestFlight.

### Fonts
- The bundled fonts are Inter (400/600/800) for body text and Fraunces (600)
  for display text. They are static TTFs from Google Fonts, under the SIL OFL
  (licences in `assets/fonts/`).
- Japanese and Arabic fallback fonts (Noto Sans JP / Noto Sans Arabic) are
  **not bundled yet**. They are needed for the non-Latin golden fixtures in
  Phase 3. Turkish is covered by Inter and Fraunces.

### Share rendering
- Slides render in a **detached render tree** (`ShareRenderer`) rather than an
  on-screen `RepaintBoundary`, which the spec describes as off-screen. This
  keeps export independent of the composer's preview and makes it testable.
  Captures use `toImage(pixelRatio: 3.0)` at logical 360×640 (story) and
  360×450 (post), which gives exactly 1080×1920 and 1080×1350.
- Exports pin `TextScaler.noScaling`, so a user's dynamic-type setting never
  changes a shared image. The app UI itself still scales.
- Every image in `TemplateData.images` is resolved and **held live** until
  capture finishes. A failed load throws `ImagePrecacheException` rather than
  exporting an image with a hole. A *missing* cover (null) renders a
  title placeholder, which is expected.
- Covers use a hairline border instead of a blurred drop shadow, because the
  shadow rendered as a hard band in the software renderer used by goldens.
- Covers are sized from the available height (`ShareCover.maxWidth` is an
  upper bound), so long quotes and titles shrink the cover rather than
  overflow.
- Golden images are the exported PNGs at full resolution. They are generated
  on Linux (same as CI's `ubuntu-latest`), so regenerate them on Linux with
  `flutter test --update-goldens`.
- The spike's 3-slide carousel (`lib/dev/spike_carousel_template.dart`) is
  dev-only and **not registered** in `TemplateRegistry`. The real carousel is
  `year_carousel` in Phase 3.

### Instagram Stories channel (`share/instagram`)
- On Android, the `InstagramFileProvider` subclass (authority
  `<applicationId>.instagramshare`) exposes only `<cache>/share/`, which is
  where `ShareExporter` writes. It is a subclass so it can't clash with
  `share_plus`'s provider. The `<queries>` entry for `com.instagram.android`
  covers Android 11+ package visibility.
- On iOS, the channel code lives in `AppDelegate.swift` so no Xcode project
  edits are needed. `LSApplicationQueriesSchemes` includes
  `instagram-stories`.
- If `META_APP_ID` is empty or Instagram isn't installed, sharing falls back to
  the system share sheet.

### Flutter web deploy (kept)
- Before this spec, the repo deployed the Flutter **web** build to Firebase
  Hosting on every push to `main`. The spec lists a web app as a non-goal, but
  the founder chose to **keep this deploy**, so the web build must keep
  compiling. Plugins without web support need a web-safe fallback or a
  conditional import.
- Flutter already uses `web/` for its web platform, so the Section 10 landing
  page will go in `landing/`.

## Phase 1 — Foundations

### Backend: Firebase instead of Supabase
- **Founder decision** (after Phase 1 was first built on Supabase): the
  backend is Firebase. The spec's Supabase pieces map to:

  | Spec (Supabase)             | Firebase                                   |
  |-----------------------------|--------------------------------------------|
  | Postgres tables             | Cloud Firestore collections                |
  | RLS policies                | `firestore.rules`, `storage.rules`         |
  | Supabase Auth               | Firebase Auth (Apple, Google, email link)  |
  | Storage buckets             | Cloud Storage for Firebase                 |
  | Edge Function `upsert_book` | Callable Cloud Function `upsertBook`       |
  | Triggers                    | Firestore-triggered Cloud Functions        |
  | RPCs (`get_feed`, …)        | Callable functions, built in their phase   |
  | `pg_cron` jobs              | Scheduled Cloud Functions (Phases 4–5)     |

- **Blaze plan required.** Cloud Functions and Cloud Storage need the
  pay-as-you-go plan. It has a free tier that a closed beta should stay inside.
- Functions run in `europe-west1`.
- The **Firebase emulators** stand in for the backend in tests (rules,
  functions, and the web end-to-end test).

### Data model (Firestore)
- Collections follow Section 5, with camelCase fields: `profiles`, `works`,
  `editions`, `userBooks`, `pageUpdates`, `follows`, `blocks`, `kudos`,
  `comments`, `reports`, `notifications`, `shareEvents`. `deviceTokens` and
  `weeklyResults` are subcollections of `profiles/{uid}`.
- **Document ids encode relationships**, so rules can check them with
  `exists()` and duplicates are impossible:
  - `userBooks/{uid}_{workId}` gives one entry per user per work, like the
    spec's `unique (user_id, work_id)`.
  - `follows/{followerId}_{followeeId}`, `blocks/{blockerId}_{blockedId}`
    and `kudos/{uid}_{pageUpdateId}`.
  - `usernames/{username}` → `{uid}` makes usernames unique. It is written in
    the same batch as the profile, and the rules require both.
  - `works/{OL id}` (e.g. `OL66554W`) and `editions/{isbn13}` make catalogue
    dedupe race-free. Editions without an ISBN use
    `{workId}_{source}_{format}_{pages}`; manual books get random ids.
- `pagesRead` and `progressPct` were generated columns. Clients now write them,
  and the rules check that `pagesRead` equals `max(toPage - fromPage, 0)`.
  `receivedAt` must be the server time.
- Page updates are soft-deleted only (`deletedAt`). They are never
  hard-deleted, and after creation only `deletedAt`, `photoPath`, `note`,
  `quote`, `mood` and `visibility` can change.
- Local dates (`startedAt`, `finishedAt`, `localDate`) are `yyyy-MM-dd`
  strings, as the spec's `date` columns were. Instants are Firestore
  timestamps.
- Catalogue search is a title prefix match on a stored `titleLower`. Firestore
  has no `ILIKE`; Open Library and Google Books cover author search.

### Security rules
- They port every Section 5 RLS rule; the emulator tests in
  `functions/test/emulator` cover them.
- Firestore rules aren't filters: a list query must itself constrain the
  fields a rule reads, e.g. `where userId == X`. Three reads can't be expressed
  that way:
  - lists of other people's **comments** and **kudos**, and
  - "friends reading this" (block checks across many authors).

  These will be served by callable functions with block filtering in
  **Phase 4**. For now, clients can only `get` single comments/kudos, and
  list their own kudos.
- **Follows rules aren't in the spec.** Everyone signed in can read follows
  (needed for counts). You can only follow as yourself, never across a block,
  and only unfollow yourself.
- Comments are hard-deleted by their author or by the update's owner.
- `notifications`: users may only change `readAt`, and only to the server time.
- The **onBlockCreated** function removes follows both ways.
  **onPageUpdateWritten** keeps `userBooks.currentPage` equal to the latest
  non-deleted update.
- Storage: `avatars/{uid}/` and `covers/{uid}/` hold images up to 5 MB, and
  users write only to their own folder. Reads are public.

### upsertBook
- Dedupes by ISBN-13 first, then by Open Library work key. For a known ISBN
  it fills in missing fields (page count, cover, ISBN-10, publisher) and never
  overwrites existing ones.
- A manual book sends the Storage **path** of its cover (`coverPath`). The
  function checks it's in the caller's own `covers/<uid>/` folder and that the
  file exists, then stores its download URL. Cover URLs sent by the client for
  manual books are ignored.

### Auth
- Apple and Google use `signInWithPopup` on web and Firebase's
  `signInWithProvider` on mobile, so no extra native SDKs are needed. Native
  Sign in with Apple can replace it before App Store review if needed.
- Email sign-in uses **Firebase email links**, which replace the magic link.
  Firebase has no 6-digit-code option. The address is remembered on the
  device, and a link opened elsewhere asks for the address to finish.
- On web the link returns to `/sign-in` and keeps the `?from=` destination.
  **On mobile, completing an email link needs the Phase 4 deep links**
  (App Links / Universal Links on the app domain). Until then, mobile users
  should sign in with Apple or Google.
- Onboarding state lives on the server: a missing profile means onboarding
  step 2. So a killed app resumes at the right step. Steps 3–7 and
  `onboardingCompletedAt` come with their phases.
- A deep link opened while signed out is remembered (`?from=`) and opened after
  sign-in and profile setup.

### Firebase config
- **Web needs no build-time config.** On Firebase Hosting (live site and PR
  previews), the app reads `/__/firebase/init.json` at startup. That file
  exists once a Web app is registered in the Firebase project.
- Mobile builds take the `FIREBASE_*` dart-defines (see `env/*.example.json`).
  This avoids committing `google-services.json`, `GoogleService-Info.plist` or
  a generated `firebase_options.dart`.
- `USE_FIREBASE_EMULATORS=true` points the app at the local emulators, using
  the offline `demo-shelfie` project.

### Books
- Search runs our catalogue, Open Library and Google Books **in parallel** and
  merges them in that priority order. Results are deduped by ISBN-13 and Open
  Library work key, as the spec says. Key-less Google Books results are also
  deduped by normalised title + first author, since otherwise they duplicate
  Open Library works.
- Open Library search results are work-level (no ISBN; median page count).
  The exact edition comes from an ISBN scan or from **Change edition**, which
  lists Open Library's editions of the work.
- Google Books takes an optional `GOOGLE_BOOKS_API_KEY`. The keyless quota is
  shared per IP and runs out.
- When shelving a work without a chosen edition, the default edition is the
  one with a page count, preferring print.
- The Book page hides **Update page** until the update flow exists (Phase 2).
  Rating and one-line take are editable for books on the Read shelf.

### App
- Shell: 5 tabs (Section 6.1). Feed and Update are honest "coming next"
  screens, each with a working button, rather than dead ends.
- **Library** in Phase 1 is a read-only shelf list with counts, so the
  acceptance criterion ("add a book to a shelf") can be seen in the app.
  Sorting, search, swipe actions and quick Update are Phase 2.
- Writes to `userBooks` go straight to Firestore, which queues them while
  offline. The spec asks for drift + an outbox (Section 8.6); Phase 2 will
  decide whether Firestore's offline cache already covers that.
- Codegen (`freezed`, `json_serializable`, `riverpod_generator`) output is
  committed. CI checks that it's up to date.

### Web
- Path URL strategy, and `optionURLReflectsImperativeAPIs`, so pushed pages
  (e.g. `/book/<id>`) show in the address bar and can be shared or reloaded.
- Covers use `WebHtmlElementStrategy.fallback`: hosts without CORS headers
  fall back to a plain `<img>`.
- The rendering spike on web has no file system and no Instagram channel.
  Exports stay in memory; **Share…** uses the Web Share API and falls back to
  downloading, and **Download** saves the PNGs. The Instagram button is
  hidden. If the cover host blocks cross-origin reads, the export is redone
  without the cover and says so.
- `test/e2e/` has a Playwright test that clicks through the whole Phase 1 flow
  on the web build, against the Firebase emulators.
