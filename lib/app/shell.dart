import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/gen/app_localizations.dart';

/// Bottom tab bar: Feed · Search · ⊕ Update · Library · You (Section 6.1).
/// The centre slot is a prominent circular button.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dynamic_feed_outlined),
            selectedIcon: const Icon(Icons.dynamic_feed),
            label: l10n.tabFeed,
          ),
          NavigationDestination(
            icon: const Icon(Icons.search),
            label: l10n.tabSearch,
          ),
          NavigationDestination(
            icon: CircleAvatar(
              radius: 22,
              backgroundColor: scheme.primary,
              child: Icon(Icons.add, color: scheme.onPrimary, size: 28),
            ),
            label: l10n.tabUpdate,
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_library_outlined),
            selectedIcon: const Icon(Icons.local_library),
            label: l10n.tabLibrary,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.tabYou,
          ),
        ],
      ),
    );
  }
}
