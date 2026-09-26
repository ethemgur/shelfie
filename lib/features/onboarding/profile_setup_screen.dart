import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../l10n/gen/app_localizations.dart';
import '../auth/auth_repository.dart';
import '../auth/session_gate.dart';
import '../profile/profile_repository.dart';

/// Onboarding step 2: username (live availability check), display name,
/// optional avatar. Username can't be skipped.
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _username = TextEditingController();
  final _displayName = TextEditingController();
  Timer? _debounce;
  UsernameStatus? _usernameStatus;
  bool _checking = false;
  bool _saving = false;
  Uint8List? _avatar;
  int _checkGeneration = 0;

  @override
  void dispose() {
    _debounce?.cancel();
    _username.dispose();
    _displayName.dispose();
    super.dispose();
  }

  void _onUsernameChanged(String value) {
    _debounce?.cancel();
    final generation = ++_checkGeneration;
    setState(() {
      _usernameStatus = null;
      _checking = value.isNotEmpty;
    });
    if (value.isEmpty) return;
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      try {
        final status = await ref
            .read(profileRepositoryProvider)
            .checkUsername(value);
        if (!mounted || generation != _checkGeneration) return;
        setState(() {
          _usernameStatus = status;
          _checking = false;
        });
      } catch (_) {
        if (mounted && generation == _checkGeneration) {
          setState(() => _checking = false);
        }
      }
    });
  }

  Future<void> _pickAvatar() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (mounted) setState(() => _avatar = bytes);
  }

  bool get _canSave =>
      !_saving &&
      _usernameStatus == UsernameStatus.available &&
      _displayName.text.trim().isNotEmpty;

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    try {
      await ref
          .read(profileRepositoryProvider)
          .create(
            username: _username.text,
            displayName: _displayName.text,
            avatarJpeg: _avatar,
          );
      await ref.read(sessionGateProvider).refresh();
    } on UsernameTakenException {
      setState(() => _usernameStatus = UsernameStatus.taken);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.genericError)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final status = _usernameStatus;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileSetupTitle),
        actions: [
          TextButton(
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
            child: Text(l10n.signOut),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Semantics(
                      button: true,
                      label: l10n.profileSetupAvatar,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _pickAvatar,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: _avatar == null
                              ? null
                              : MemoryImage(_avatar!),
                          child: _avatar == null
                              ? const Icon(Icons.add_a_photo_outlined, size: 32)
                              : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.profileSetupAvatarHint,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _username,
                    autocorrect: false,
                    onChanged: _onUsernameChanged,
                    decoration: InputDecoration(
                      labelText: l10n.profileSetupUsername,
                      prefixText: '@',
                      border: const OutlineInputBorder(),
                      helperText: status == null && !_checking
                          ? l10n.profileSetupUsernameRules
                          : null,
                      errorText: switch (status) {
                        UsernameStatus.invalid =>
                          l10n.profileSetupUsernameRules,
                        UsernameStatus.taken => l10n.profileSetupUsernameTaken,
                        _ => null,
                      },
                      suffixIcon: _checking
                          ? const Padding(
                              padding: EdgeInsets.all(14),
                              child: SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : status == UsernameStatus.available
                          ? Icon(
                              Icons.check_circle,
                              color: theme.colorScheme.primary,
                              semanticLabel: l10n.profileSetupUsernameAvailable,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _displayName,
                    maxLength: 50,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: l10n.profileSetupDisplayName,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _canSave ? _save : null,
                    child: _saving
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.continueLabel),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
