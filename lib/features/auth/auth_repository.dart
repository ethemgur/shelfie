import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/remote/remote_providers.dart';

part 'auth_repository.g.dart';

/// Supabase Auth: Apple, Google and email magic link (Section 6.2).
///
/// Apple and Google use Supabase's OAuth redirect flow on every platform
/// (browser tab on mobile, same-tab redirect on web), which needs no native
/// SDK setup. See DECISIONS.md.
class AuthRepository {
  AuthRepository(this._auth);

  final GoTrueClient _auth;

  /// Where auth redirects land: the current site on web, the app's custom
  /// scheme on mobile (registered in AndroidManifest.xml / Info.plist).
  static String? get redirectUrl =>
      kIsWeb ? Uri.base.origin : 'com.shelfie.shelfie://login-callback/';

  Future<void> sendMagicLink(String email) =>
      _auth.signInWithOtp(email: email.trim(), emailRedirectTo: redirectUrl);

  /// Signs in with the 6-digit code from the magic-link email, for when the
  /// link opens in a different browser or device.
  Future<void> verifyEmailCode(String email, String code) => _auth.verifyOTP(
    email: email.trim(),
    token: code.trim(),
    type: OtpType.email,
  );

  Future<void> signInWithApple() => _oauth(OAuthProvider.apple);

  Future<void> signInWithGoogle() => _oauth(OAuthProvider.google);

  Future<void> _oauth(OAuthProvider provider) => _auth.signInWithOAuth(
    provider,
    redirectTo: redirectUrl,
    authScreenLaunchMode: kIsWeb
        ? LaunchMode.platformDefault
        : LaunchMode.externalApplication,
  );

  Future<void> signOut() => _auth.signOut();
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepository(ref.watch(supabaseProvider).auth);
