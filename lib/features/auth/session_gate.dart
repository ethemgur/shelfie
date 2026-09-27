import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/models.dart';
import '../../data/remote/remote_providers.dart';
import '../profile/profile_repository.dart';

part 'session_gate.g.dart';

enum SessionStatus { loading, signedOut, needsProfile, ready, error }

/// Tracks sign-in and whether the user has a profile yet; the router
/// redirects on every change. Onboarding state lives on the server (does a
/// profile exist?), so a killed app resumes at the right step.
class SessionGate extends ChangeNotifier {
  SessionGate(this._auth, this._profiles) {
    _sub = _auth.authStateChanges().listen((_) => _load());
  }

  final FirebaseAuth _auth;
  final ProfileRepository _profiles;
  late final StreamSubscription<User?> _sub;

  SessionStatus _status = SessionStatus.loading;
  SessionStatus get status => _status;

  Profile? _profile;
  Profile? get profile => _profile;

  int _generation = 0;

  Future<void> _load() async {
    final generation = ++_generation;
    final user = _auth.currentUser;
    if (user == null) {
      _set(SessionStatus.signedOut, null);
      return;
    }
    try {
      final profile = await _profiles.profile(user.uid);
      if (generation != _generation) return;
      _set(
        profile == null ? SessionStatus.needsProfile : SessionStatus.ready,
        profile,
      );
    } catch (e) {
      debugPrint('Profile load failed: $e');
      if (generation == _generation) _set(SessionStatus.error, null);
    }
  }

  /// Re-reads the profile, e.g. after creating it.
  Future<void> refresh() => _load();

  void _set(SessionStatus status, Profile? profile) {
    _status = status;
    _profile = profile;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

@Riverpod(keepAlive: true)
SessionGate sessionGate(Ref ref) {
  final gate = SessionGate(
    ref.watch(firebaseAuthProvider),
    ref.watch(profileRepositoryProvider),
  );
  ref.onDispose(gate.dispose);
  return gate;
}

/// The signed-in user's profile, or null before onboarding.
@Riverpod(keepAlive: true)
Profile? currentProfile(Ref ref) {
  final gate = ref.watch(sessionGateProvider);
  void onChange() => ref.invalidateSelf();
  gate.addListener(onChange);
  ref.onDispose(() => gate.removeListener(onChange));
  return gate.profile;
}
