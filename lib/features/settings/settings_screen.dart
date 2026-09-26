import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/env.dart';
import '../../app/routes.dart';
import '../../l10n/gen/app_localizations.dart';
import '../auth/auth_repository.dart';

/// Settings (Section 6.10). Phase 1 has sign-out and the "No generative AI"
/// statement; the rest arrives in Phase 5.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.auto_awesome_outlined),
            title: Text(l10n.settingsNoAiTitle),
            subtitle: Text(l10n.settingsNoAiBody),
          ),
          if (Env.isDev)
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: Text(l10n.devSpikeEntry),
              onTap: () => context.push(Routes.devSpike),
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.signOut),
            onTap: () async {
              await ref.read(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
    );
  }
}
