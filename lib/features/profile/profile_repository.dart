import 'dart:typed_data';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/models.dart';
import '../../data/remote/remote_providers.dart';

part 'profile_repository.g.dart';

enum UsernameStatus { invalid, available, taken }

class ProfileRepository {
  ProfileRepository(this._db);

  final SupabaseClient _db;

  static final usernamePattern = RegExp(r'^[a-z0-9_]{3,20}$');

  Future<Profile?> profile(String userId) async {
    final row = await _db
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return row == null ? null : Profile.fromJson(row);
  }

  Future<UsernameStatus> checkUsername(String username) async {
    final normalized = username.trim().toLowerCase();
    if (!usernamePattern.hasMatch(normalized)) return UsernameStatus.invalid;
    final available = await _db.rpc<bool>(
      'username_available',
      params: {'p_username': normalized},
    );
    return available ? UsernameStatus.available : UsernameStatus.taken;
  }

  /// Creates the signed-in user's profile. Throws [UsernameTakenException] if
  /// someone claimed the name since it was checked.
  Future<Profile> create({
    required String username,
    required String displayName,
    Uint8List? avatarJpeg,
  }) async {
    final userId = _db.auth.currentUser!.id;
    String? avatarPath;
    if (avatarJpeg != null) {
      avatarPath =
          '$userId/avatar-${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _db.storage
          .from('avatars')
          .uploadBinary(
            avatarPath,
            avatarJpeg,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );
    }
    String timezone;
    try {
      timezone = (await FlutterTimezone.getLocalTimezone()).identifier;
    } catch (_) {
      timezone = 'UTC';
    }
    try {
      final row = await _db
          .from('profiles')
          .insert({
            'id': userId,
            'username': username.trim().toLowerCase(),
            'display_name': displayName.trim(),
            'avatar_path': avatarPath,
            'timezone': timezone,
          })
          .select()
          .single();
      return Profile.fromJson(row);
    } on PostgrestException catch (e) {
      if (e.code == '23505') throw const UsernameTakenException();
      rethrow;
    }
  }

  String? avatarUrl(Profile profile) => profile.avatarPath == null
      ? null
      : _db.storage.from('avatars').getPublicUrl(profile.avatarPath!);
}

class UsernameTakenException implements Exception {
  const UsernameTakenException();
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) =>
    ProfileRepository(ref.watch(supabaseProvider));
