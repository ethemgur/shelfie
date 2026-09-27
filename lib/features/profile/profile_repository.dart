import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/models.dart';
import '../../data/remote/remote_providers.dart';

part 'profile_repository.g.dart';

enum UsernameStatus { invalid, available, taken }

/// `profiles/{uid}` plus `usernames/{username}` → `{uid}`, which makes
/// usernames unique (see firestore.rules).
class ProfileRepository {
  ProfileRepository(this._db, this._auth, this._storage);

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  static final usernamePattern = RegExp(r'^[a-z0-9_]{3,20}$');

  Future<Profile?> profile(String userId) async {
    final doc = await _db.collection('profiles').doc(userId).get();
    return doc.exists ? Profile.fromJson(withId(doc)) : null;
  }

  Future<UsernameStatus> checkUsername(String username) async {
    final normalized = username.trim().toLowerCase();
    if (!usernamePattern.hasMatch(normalized)) return UsernameStatus.invalid;
    final doc = await _db.collection('usernames').doc(normalized).get();
    return doc.exists ? UsernameStatus.taken : UsernameStatus.available;
  }

  /// Creates the signed-in user's profile and claims the username in one
  /// batch. Throws [UsernameTakenException] if someone claimed it since it
  /// was checked.
  Future<Profile> create({
    required String username,
    required String displayName,
    Uint8List? avatarJpeg,
  }) async {
    final userId = _auth.currentUser!.uid;
    final name = username.trim().toLowerCase();
    String? avatarPath;
    String? avatarUrl;
    if (avatarJpeg != null) {
      avatarPath =
          'avatars/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref(avatarPath);
      await ref.putData(
        avatarJpeg,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      avatarUrl = await ref.getDownloadURL();
    }
    String timezone;
    try {
      timezone = (await FlutterTimezone.getLocalTimezone()).identifier;
    } catch (_) {
      timezone = 'UTC';
    }
    final batch = _db.batch()
      ..set(_db.collection('usernames').doc(name), {'uid': userId})
      ..set(_db.collection('profiles').doc(userId), {
        'username': name,
        'displayName': displayName.trim(),
        'avatarPath': avatarPath,
        'avatarUrl': avatarUrl,
        'bio': null,
        'weeklyPageGoal': 150,
        'defaultVisibility': 'followers',
        'timezone': timezone,
        'onboardingCompletedAt': null,
        'createdAt': FieldValue.serverTimestamp(),
      });
    try {
      await batch.commit();
    } on FirebaseException catch (e) {
      // A taken username is an existing doc, which the rules refuse to
      // overwrite.
      if (e.code == 'permission-denied' &&
          (await checkUsername(name)) == UsernameStatus.taken) {
        throw const UsernameTakenException();
      }
      rethrow;
    }
    return (await profile(userId))!;
  }
}

class UsernameTakenException implements Exception {
  const UsernameTakenException();
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) => ProfileRepository(
  ref.watch(firestoreProvider),
  ref.watch(firebaseAuthProvider),
  ref.watch(storageProvider),
);
