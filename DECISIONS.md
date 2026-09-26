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
