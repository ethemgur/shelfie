# shelfie

A Flutter app (Web + Android), built and coded entirely through Claude.

- **Web** builds and deploys to **GitHub Pages** automatically on every push
  to `main`. This is the only deploy target for now — Android platform code
  is kept in the repo (same layout/widgets will run on Android later) but
  isn't built or distributed by CI yet.
- Pull requests run `flutter analyze` + `flutter test` via CI before merge.

## One-time setup (GitHub only — no Google Cloud needed)

1. Repo → **Settings → Pages**.
2. Under **Build and deployment → Source**, choose **GitHub Actions**.

That's it. No secrets, no service accounts.

## Trigger a deploy

Push to `main` (or merge a PR into it). Check the **Actions** tab → the
`deploy-web` job prints the live Pages URL, something like:

```
https://ethemgur.github.io/shelfie/
```

## Local development

This repo is built to be edited via Claude Code, but if you want to run it
yourself:

```bash
flutter pub get
flutter run -d chrome   # web
flutter run              # android device/emulator
```
