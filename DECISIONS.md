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

### Database
- The schema follows Section 5 exactly, with these additions:
  - Check constraints on the enum-like text columns (`editions.source`,
    `user_books.source`, `page_updates.mood`, `share_events.format` and
    `target`), plus an ISBN format check.
  - `editions.created_by` (who added a `source = 'user'` edition). It
    references `auth.users`, so manual adds work even before a profile exists.
  - A few extra indexes (`user_books.work_id`, `kudos.page_update_id`,
    `blocks.blocked_id`, `page_updates (user_book_id, created_at)`), and a
    `simple` full-text index on `works.title`.
  - `display_name` is limited to 1–50 characters.
- **Follows RLS isn't in the spec.** Everyone signed in can read follows
  (needed for counts), except rows involving someone in a block with the
  viewer. You can only create follows as yourself, never across a block, and
  only delete your own.
- **Comments** are hard-deleted by their author or by the update's owner. The
  `deleted_at` column stays for moderation.
- `notifications`: users may only update `read_at`, enforced with a
  column-level grant.
- Block checks go through `is_blocked_between()` (SECURITY DEFINER), so a
  user's queries respect blocks without them being able to see who blocked
  them.
- RPC parameters are prefixed (`p_cursor`, `p_limit`, …) because `limit` is a
  reserved word. The RPCs other than `username_available` are stubs with their
  final signatures.
- Storage: public `avatars` and `covers` buckets. Users can only write inside
  their own `<user id>/` folder.

### upsert_book
- Dedupes by ISBN-13 first, then by Open Library work key. For a known ISBN
  it fills in missing fields (page count, cover, ISBN-10, publisher) and never
  overwrites existing ones. Editions without an ISBN are reused when source,
  format and page count match.
- A manual (`source = 'user'`) book may only use a cover photo from the
  caller's own `covers/<uid>/` folder.

### Auth
- Apple and Google use Supabase's **OAuth redirect flow** on every platform (a
  browser tab on mobile, a same-tab redirect on web), not the native SDKs.
  This needs no per-platform client setup and works on web. Native Sign in
  with Apple can replace it before App Store review if needed.
- The magic-link email also carries a 6-digit code (`supabase/templates/`),
  for when the link opens in a different browser or device than the app.
- The mobile auth callback is `com.shelfie.shelfie://login-callback/`.
- Onboarding state lives on the server: a missing profile means onboarding
  step 2. So a killed app resumes at the right step. Steps 3–7 and
  `onboarding_completed_at` come with their phases.
- A deep link opened while signed out is remembered (`?from=`) and opened after
  sign-in and profile setup.

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
- Writes to `user_books` go straight to Supabase in Phase 1. Phase 2 moves them
  behind the offline outbox.
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
  on the web build.
