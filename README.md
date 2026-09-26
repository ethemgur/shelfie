# shelfie

Social reading tracker ("Strava for readers"). Log the page you're on, share a
card to Instagram or TikTok, and get kudos from friends. Built in Flutter
(iOS 15+, Android API 24+) with a Supabase backend.

- Choices the spec doesn't cover: [`DECISIONS.md`](DECISIONS.md)
- Status: **Phase 1** (foundations: schema + RLS, auth, profiles, book search, shelves)

## Layout

```
lib/
  app/        app widget, router, theme, env config
  core/       pure helpers (ISBN, dates)
  data/       models (freezed) and remote clients (Supabase, Open Library, Google Books)
  dev/        dev-flavour-only tools (rendering spike)
  features/
    auth/ onboarding/ books/ library/ profile/ settings/ feed/
    share/    template engine, styles, off-screen renderer, share targets
  l10n/       ARB strings (+ generated code in l10n/gen)
test/
  unit/       pure logic and renderer tests
  golden/     exported share images, pixel-compared
  e2e/        Playwright test of the web build (see test/e2e/README.md)
supabase/     config.toml, migrations/, functions/, tests/ (pgTAP), templates/
env/          per-flavour build config (copy *.example.json)
```

## Running

```bash
cp env/dev.example.json env/dev.json      # fill in SUPABASE_*, META_APP_ID
flutter pub get
flutter run --flavor dev --dart-define-from-file=env/dev.json   # Android
flutter run --dart-define-from-file=env/dev.json                # iOS (no flavour schemes yet)
```

In the dev flavour, the home screen links to the **rendering spike**. It
renders `session_minimal` at 1080×1920 and a 3-slide carousel with a network
cover, shows the export time, and shares to Instagram Stories or the system
sheet.

## Tests

```bash
flutter analyze
flutter test                     # unit + golden
flutter test --update-goldens    # after an intentional visual change (on Linux)
```

After changing a `@freezed` model or `@riverpod` provider:

```bash
dart run build_runner build
```

## Supabase

Migrations live in `supabase/migrations/` and are managed with the Supabase CLI:

```bash
npx supabase start                   # local stack (needs Docker)
npx supabase migration new <name>
npx supabase db reset                # re-apply all migrations locally
npx supabase test db                 # RLS policy tests (supabase/tests)
npx supabase functions serve         # Edge Functions locally
cd supabase/functions && deno test upsert_book/
```

### Hosted project setup (one time)

1. Create a project at [supabase.com](https://supabase.com).
2. **GitHub → Settings → Secrets and variables → Actions**:
   - Secrets: `SUPABASE_ACCESS_TOKEN` (from supabase.com → Account → Access
     Tokens) and `SUPABASE_DB_PASSWORD` (the database password).
   - Variables: `SUPABASE_PROJECT_REF` (e.g. `abcdefghijklmnop`),
     `SUPABASE_URL` (`https://<ref>.supabase.co`), `SUPABASE_ANON_KEY` (the
     publishable / anon key, which is safe to expose), and optionally
     `GOOGLE_BOOKS_API_KEY`.

   On the next push to `main`, the Deploy workflow applies the migrations,
   deploys `upsert_book`, and builds the web app against the project.
3. In the Supabase dashboard, **Authentication**:
   - URL Configuration: Site URL `https://<firebase-project>.web.app`;
     additional redirect URLs `https://<firebase-project>.web.app`,
     `https://*--<firebase-project>.web.app` (PR previews),
     `com.shelfie.shelfie://login-callback/`.
   - Email Templates → Magic Link and Confirm signup: paste
     `supabase/templates/magic_link.html`, which includes the 6-digit code.
   - Providers: enable Google and Apple (each needs its OAuth client set up
     in Google Cloud / Apple Developer).

## Web deploy

Every push to `main` builds the Flutter web app and deploys it to Firebase
Hosting. Pull requests get a 7-day preview URL. This needs one GitHub secret,
`FIREBASE_SERVICE_ACCOUNT`. The web build must keep compiling (see
`DECISIONS.md`).

### One-time setup

Only one GitHub secret is needed: `FIREBASE_SERVICE_ACCOUNT`. The project ID is
read from inside it.

#### 1. Add Firebase to your Google Cloud project

1. Open the [Firebase console](https://console.firebase.google.com/).
2. Choose **Create a project** and pick **your existing Google Cloud project**
   (look for "Add Firebase to Google Cloud project"), rather than creating a
   new one.
3. Google Analytics is optional; skip it.

#### 2. Turn on Hosting

In the Firebase console, open **Build → Hosting → Get started** and click
through the wizard (Next / Continue to console). You don't need to run any of
the commands it shows you.

#### 3. Create a service account key for GitHub Actions

In the [Google Cloud console → IAM & Admin → Service accounts](https://console.cloud.google.com/iam-admin/serviceaccounts)
(make sure your project is selected at the top):

1. **Create service account**, name it `github-deployer`, then **Create and continue**.
2. Add these two roles, then **Done**:
   - `Firebase Hosting Admin`
   - `API Keys Viewer`
3. Click the new service account → **Keys** tab → **Add key → Create new key
   → JSON → Create**. A `.json` file downloads. Don't commit or share it.

#### 4. Add the key to GitHub

GitHub repo → **Settings → Secrets and variables → Actions → New repository
secret**:

- **Name:** `FIREBASE_SERVICE_ACCOUNT`
- **Secret:** paste the entire contents of the JSON file

#### 5. Deploy

Push to `main`, or run it by hand from **Actions → Deploy → Run workflow**.
The live URL is `https://<project-id>.web.app`.
