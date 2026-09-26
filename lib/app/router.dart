import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../dev/spike_screen.dart';
import '../l10n/gen/app_localizations.dart';
import 'env.dart';

abstract final class Routes {
  static const home = '/';
  static const devSpike = '/dev/spike';
}

GoRouter buildRouter() => GoRouter(
  initialLocation: Routes.home,
  routes: [
    GoRoute(path: Routes.home, builder: (_, _) => const _HomePlaceholder()),
    if (Env.isDev)
      GoRoute(path: Routes.devSpike, builder: (_, _) => const SpikeScreen()),
  ],
);

/// Placeholder until the tab shell lands (Phase 1–2).
class _HomePlaceholder extends StatelessWidget {
  const _HomePlaceholder();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appName)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.homeComingSoon),
            if (Env.isDev) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => context.push(Routes.devSpike),
                child: Text(l10n.devSpikeEntry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
