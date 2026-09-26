# shelfie

A Flutter app (Web + Android), built and coded entirely through Claude, deployed
automatically via GitHub Actions.

- **Web** deploys to Firebase Hosting on every push to `main`.
- **Android** builds a debug APK and sends it to your testers via Firebase App
  Distribution on every push to `main`.
- Pull requests run `flutter analyze` + `flutter test` via CI before merge.

## One-time setup (Google Cloud Console / Firebase + GitHub)

You already created the GCP project. Do the following once to wire up
deploys. None of this requires writing code.

### 1. Turn the GCP project into a Firebase project

1. Go to the [Firebase console](https://console.firebase.google.com/).
2. Click **Add project** → choose **your existing Google Cloud project**
   from the dropdown (don't create a new one).
3. Finish the wizard (Google Analytics is optional, you can skip it).

### 2. Register the Web and Android apps in Firebase

In **Project settings** (gear icon) → **Your apps**:

- **Add app → Web**. Nickname it e.g. `shelfie-web`. You don't need the SDK
  snippet it shows you — registering it is enough to create your default
  Hosting site (`<project-id>.web.app`).
- **Add app → Android**. Package name must be exactly:
  ```
  com.shelfie.shelfie
  ```
  You can skip downloading `google-services.json` (not needed for
  Hosting/App Distribution; only needed if you later add other Firebase
  SDKs like Auth/Firestore to the app itself).
- After creating the Android app, copy its **App ID** shown in the app card
  — looks like `1:1234567890:android:abcdef123456`. You'll need it below.

### 3. Create testers group for Android builds

**Firebase console → Release & Monitor → App Distribution → Testers & Groups**
→ create a group named exactly `testers` → add your own email as a tester.
You'll get an email invite/link each time a new build is distributed.

### 4. Create a service account for GitHub Actions

In [Google Cloud Console](https://console.cloud.google.com/iam-admin/serviceaccounts)
(same project):

1. **IAM & Admin → Service Accounts → Create service account.**
   Name it e.g. `github-actions-deploy`.
2. Grant it these roles:
   - `Firebase Hosting Admin`
   - `Firebase App Distribution Admin`
3. Open the new service account → **Keys** tab → **Add key → Create new key
   → JSON**. This downloads a `.json` file — keep it secret, don't commit it.

### 5. Add GitHub repository secrets

In the GitHub repo → **Settings → Secrets and variables → Actions → New
repository secret**, add:

| Secret name | Value |
|---|---|
| `GCP_SA_KEY` | Paste the **entire contents** of the JSON key file from step 4 |
| `FIREBASE_PROJECT_ID` | Your Firebase/GCP project ID (Project settings → General) |
| `FIREBASE_ANDROID_APP_ID` | The Android App ID from step 2 (`1:...:android:...`) |

### 6. Trigger it

Push to `main` (or merge a PR into it). Check the **Actions** tab:

- `deploy-web` job prints the live Hosting URL — open it in a browser.
- `distribute-android` job sends the APK to Firebase; testers get an email
  with an install link.

## Local development

This repo is built to be edited via Claude Code, but if you want to run it
yourself:

```bash
flutter pub get
flutter run -d chrome   # web
flutter run              # android device/emulator
```
