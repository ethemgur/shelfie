import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/env.dart';
import '../../data/remote/remote_providers.dart';

part 'auth_repository.g.dart';

/// Firebase Auth: Apple, Google and email link (Section 6.2).
///
/// Apple and Google use a popup on web and Firebase's provider flow on
/// mobile, which needs no extra native SDKs. See DECISIONS.md.
class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  static const _pendingEmailKey = 'auth.pendingEmail';

  /// Where the email link lands: this site's sign-in page on web, keeping
  /// the page the user was heading to (`?from=`); on mobile, the app's domain
  /// (opening the app needs the deep links from Phase 4).
  static String get _continueUrl {
    if (!kIsWeb) return 'https://${Env.appDomain}/sign-in';
    final from = Uri.base.queryParameters['from'];
    return Uri.base
        .replace(
          path: '/sign-in',
          queryParameters: from == null ? null : {'from': from},
          fragment: null,
        )
        .toString();
  }

  Future<void> sendEmailLink(String email) async {
    final trimmed = email.trim();
    await _auth.sendSignInLinkToEmail(
      email: trimmed,
      actionCodeSettings: ActionCodeSettings(
        url: _continueUrl,
        handleCodeInApp: true,
        androidPackageName: 'com.shelfie.shelfie',
        androidInstallApp: false,
        iOSBundleId: 'com.shelfie.shelfie',
      ),
    );
    // Remembered so the link can complete sign-in without asking again.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pendingEmailKey, trimmed);
  }

  bool isEmailLink(String link) => _auth.isSignInWithEmailLink(link);

  /// The email the link was sent to from this device, if any.
  Future<String?> pendingEmail() async =>
      (await SharedPreferences.getInstance()).getString(_pendingEmailKey);

  Future<void> completeEmailLink(String email, String link) async {
    await _auth.signInWithEmailLink(email: email.trim(), emailLink: link);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingEmailKey);
  }

  Future<void> signInWithApple() => _provider(AppleAuthProvider());

  Future<void> signInWithGoogle() => _provider(GoogleAuthProvider());

  Future<void> _provider(AuthProvider provider) async {
    if (kIsWeb) {
      await _auth.signInWithPopup(provider);
    } else {
      await _auth.signInWithProvider(provider);
    }
  }

  Future<void> signOut() => _auth.signOut();
}

/// The URL the app was opened with, captured before routing rewrites it, so
/// an email sign-in link can be completed.
@Riverpod(keepAlive: true)
String? initialLink(Ref ref) => null;

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepository(ref.watch(firebaseAuthProvider));
