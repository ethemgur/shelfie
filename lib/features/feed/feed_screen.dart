import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../l10n/gen/app_localizations.dart';

/// Feed tab. The feed itself arrives in Phase 4; until then this points
/// people at the part of the loop that works.
class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabFeed)),
      body: _ComingSoon(
        icon: Icons.dynamic_feed_outlined,
        message: l10n.feedComingSoon,
        action: l10n.findABook,
        onAction: () => context.go(Routes.search),
      ),
    );
  }
}

/// Update tab. The page update flow arrives in Phase 2.
class UpdatePlaceholderScreen extends StatelessWidget {
  const UpdatePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabUpdate)),
      body: _ComingSoon(
        icon: Icons.edit_note,
        message: l10n.updateComingSoon,
        action: l10n.openLibrary,
        onAction: () => context.go(Routes.library),
      ),
    );
  }
}

class _ComingSoon extends StatelessWidget {
  const _ComingSoon({
    required this.icon,
    required this.message,
    required this.action,
    required this.onAction,
  });

  final IconData icon;
  final String message;
  final String action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.tonal(onPressed: onAction, child: Text(action)),
          ],
        ),
      ),
    );
  }
}
