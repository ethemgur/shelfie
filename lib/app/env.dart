import 'package:flutter/services.dart' show appFlavor;

enum Flavor { dev, prod }

/// Build-time configuration, injected with
/// `--flavor <dev|prod> --dart-define-from-file=env/<flavor>.json`.
///
/// Nothing here is secret: the Supabase anon key and Meta App ID ship inside
/// the app binary anyway. Service-role keys never belong in this file.
abstract final class Env {
  static Flavor get flavor => switch (appFlavor ??
      const String.fromEnvironment('FLAVOR', defaultValue: 'dev')) {
    'prod' => Flavor.prod,
    _ => Flavor.dev,
  };

  static bool get isDev => flavor == Flavor.dev;

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Needed for Instagram Stories sharing (`source_application`).
  static const metaAppId = String.fromEnvironment('META_APP_ID');

  /// Optional browser API key for Google Books (the keyless quota is shared
  /// and runs out). Restrict it by HTTP referrer / app id in Google Cloud.
  static const googleBooksApiKey = String.fromEnvironment(
    'GOOGLE_BOOKS_API_KEY',
  );

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Public domain used in share footers and deep links. Placeholder until
  /// the final name is chosen.
  static const appDomain = String.fromEnvironment(
    'APP_DOMAIN',
    defaultValue: 'shelfie.app',
  );
}
