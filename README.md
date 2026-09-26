# shelfie

A Flutter app (Web + Android), built and coded entirely through Claude.

- **Every push to `main`** runs analyze + tests, builds the web app and deploys
  it to **Firebase Hosting** at `https://<project-id>.web.app`.
- **Every pull request** runs the same checks and deploys a temporary
  **preview URL** (valid 7 days), posted as a comment on the PR.
- Android platform code is kept in the repo (same widgets/layout), but isn't
  built or distributed by CI yet.

## One-time setup

Only one GitHub secret is needed: `FIREBASE_SERVICE_ACCOUNT`. The project ID is
read from inside it.

### 1. Add Firebase to your Google Cloud project

1. Open the [Firebase console](https://console.firebase.google.com/).
2. Choose **Create a project** and pick **your existing Google Cloud project**
   (look for "Add Firebase to Google Cloud project"), rather than creating a
   new one.
3. Google Analytics is optional; skip it.

### 2. Turn on Hosting

In the Firebase console, open **Build → Hosting → Get started** and click
through the wizard (Next / Continue to console). You don't need to run any of
the commands it shows you.

### 3. Create a service account key for GitHub Actions

In the [Google Cloud console → IAM & Admin → Service accounts](https://console.cloud.google.com/iam-admin/serviceaccounts)
(make sure your project is selected at the top):

1. **Create service account**, name it `github-deployer`, then **Create and continue**.
2. Add these two roles, then **Done**:
   - `Firebase Hosting Admin`
   - `API Keys Viewer`
3. Click the new service account → **Keys** tab → **Add key → Create new key
   → JSON → Create**. A `.json` file downloads. Don't commit or share it.

### 4. Add the key to GitHub

GitHub repo → **Settings → Secrets and variables → Actions → New repository
secret**:

- **Name:** `FIREBASE_SERVICE_ACCOUNT`
- **Secret:** paste the entire contents of the JSON file

### 5. Deploy

Push to `main`, or run it by hand from **Actions → Deploy → Run workflow**.
The live URL is `https://<project-id>.web.app`.

## Local development

This repo is edited through Claude Code, but to run it yourself:

```bash
flutter pub get
flutter run -d chrome   # web
flutter run             # android device/emulator
```
