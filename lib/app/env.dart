import 'package:flutter/services.dart' show appFlavor;

enum Flavor { dev, prod }

/// Build-time configuration, injected with
/// `--flavor <dev|prod> --dart-define-from-file=env/<flavor>.json`.
///
/// Nothing here is secret: Firebase client config and the Meta App ID ship
/// inside the app binary anyway. Service-account keys never belong here.
abstract final class Env {
  static Flavor get flavor => switch (appFlavor ??
      const String.fromEnvironment('FLAVOR', defaultValue: 'dev')) {
    'prod' => Flavor.prod,
    _ => Flavor.dev,
  };

  static bool get isDev => flavor == Flavor.dev;

  /// Firebase client config (Firebase console → Project settings → Your
  /// apps). On web builds served by Firebase Hosting these can be left empty:
  /// the app reads `/__/firebase/init.json` instead.
  static const firebaseApiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
  );
  static const firebaseMessagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );
  static const firebaseStorageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
  );
  static const firebaseAuthDomain = String.fromEnvironment(
    'FIREBASE_AUTH_DOMAIN',
  );
  static const firebaseAppIdWeb = String.fromEnvironment('FIREBASE_APP_ID_WEB');
  static const firebaseAppIdAndroid = String.fromEnvironment(
    'FIREBASE_APP_ID_ANDROID',
  );
  static const firebaseAppIdIos = String.fromEnvironment('FIREBASE_APP_ID_IOS');

  /// Talk to the local Firebase emulators (`firebase emulators:start`)
  /// instead of a real project.
  static const useEmulators = bool.fromEnvironment('USE_FIREBASE_EMULATORS');

  /// Host running the emulators (10.0.2.2 from an Android emulator).
  static const emulatorHost = String.fromEnvironment(
    'FIREBASE_EMULATOR_HOST',
    defaultValue: '127.0.0.1',
  );

  /// Needed for Instagram Stories sharing (`source_application`).
  static const metaAppId = String.fromEnvironment('META_APP_ID');

  /// Optional browser API key for Google Books (the keyless quota is shared
  /// and runs out). Restrict it by HTTP referrer / app id in Google Cloud.
  static const googleBooksApiKey = String.fromEnvironment(
    'GOOGLE_BOOKS_API_KEY',
  );

  /// Public domain used in share footers and deep links. Placeholder until
  /// the final name is chosen.
  static const appDomain = String.fromEnvironment(
    'APP_DOMAIN',
    defaultValue: 'shelfie.app',
  );
}
