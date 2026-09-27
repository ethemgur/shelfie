# shelfie

Social reading tracker ("Strava for readers"). Log the page you're on, share a
card to Instagram or TikTok, and get kudos from friends. Built in Flutter
(iOS 15+, Android API 24+) with a Firebase backend (Auth, Firestore, Storage,
Cloud Functions, Hosting).

- Choices the spec doesn't cover: [`DECISIONS.md`](DECISIONS.md)
- Status: **Phase 1** (foundations: data model + security rules, auth, profiles, book search, shelves)

## Layout

```
lib/
  app/        app widget, router, theme, env config
  core/       pure helpers (ISBN, dates)
  data/       models (freezed) and remote clients (Firebase, Open Library, Google Books)
  dev/        dev-flavour-only tools (rendering spike)
  features/
    auth/ onboarding/ books/ library/ profile/ settings/ feed/
    share/    template engine, styles, off-screen renderer, share targets
  l10n/       ARB strings (+ generated code in l10n/gen)
test/
  unit/       pure logic and renderer tests
  golden/     exported share images, pixel-compared
  e2e/        Playwright test of the web build (see test/e2e/README.md)
functions/    Cloud Functions (TypeScript) + rules/functions tests (emulators)
firestore.rules, storage.rules, firestore.indexes.json, firebase.json
env/          per-flavour build config (copy *.example.json)
```

## Running

Against the local Firebase emulators (no Firebase project needed):

```bash
cd functions && npm install && npm run build && cd ..
npx --prefix functions firebase emulators:start --project demo-shelfie \
  --only auth,firestore,storage,functions
flutter run -d chrome --dart-define=USE_FIREBASE_EMULATORS=true
```

Against a real project:

```bash
cp env/dev.example.json env/dev.json      # fill in FIREBASE_*, META_APP_ID
flutter run --flavor dev --dart-define-from-file=env/dev.json   # Android
flutter run --dart-define-from-file=env/dev.json                # iOS (no flavour schemes yet)
```

In the dev flavour, Settings links to the **rendering spike**. It renders
`session_minimal` at 1080×1920 and a 3-slide carousel, shows the export time,
and shares to Instagram Stories or the system sheet (download on web).

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

## Firebase backend

Security rules and Cloud Functions live at the repo root and in `functions/`:

```bash
cd functions
npm install
npm run test:unit        # upsertBook input validation
npm run test:emulator    # security rules + functions, against the emulators
```

### Project setup (one time)

This uses the same Firebase project as the web hosting below.

1. **Upgrade the project to the Blaze plan** (Firebase console → Usage and
   billing). Cloud Functions and Storage need it; a closed beta should stay
   within the free tier.
2. **Register a Web app**: Project settings → Your apps → Add app → Web. The
   hosted web app reads its config from it automatically.
3. **Authentication → Sign-in method**: enable Email/Password with **Email
   link (passwordless sign-in)**, Google, and Apple (Apple needs a Services ID
   from Apple Developer). Under Settings → Authorized domains, check that the
   `web.app` / `firebaseapp.com` domains are listed.
4. **Firestore**: create the database (production mode, a region near your
   users, e.g. `eur3`). **Storage**: Get started (same region).
5. **Deploy permissions**: in Google Cloud IAM, give the `github-deployer`
   service account the **Firebase Admin**, **Cloud Functions Admin** and
   **Service Account User** roles.
6. In GitHub → Settings → Secrets and variables → Actions → **Variables**, set
   `DEPLOY_FIREBASE_BACKEND` = `true`. Optionally add `GOOGLE_BOOKS_API_KEY`.

On the next push to `main`, the Deploy workflow deploys the rules, indexes and
Cloud Functions, and the web app.

Mobile builds also need Android and iOS apps registered in the project. Their
config goes into `env/<flavor>.json` (`FIREBASE_*`).

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
