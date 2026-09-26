import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../dev/spike_screen.dart';
import '../features/auth/session_gate.dart';
import '../features/auth/sign_in_screen.dart';
import '../features/books/book_page.dart';
import '../features/books/manual_add_screen.dart';
import '../features/books/scan_screen.dart';
import '../features/books/search_screen.dart';
import '../features/feed/feed_screen.dart';
import '../features/library/library_screen.dart';
import '../features/onboarding/profile_setup_screen.dart';
import '../features/profile/you_screen.dart';
import '../features/settings/settings_screen.dart';
import '../l10n/gen/app_localizations.dart';
import 'env.dart';
import 'routes.dart';
import 'shell.dart';

/// Where [status] sends someone trying to open [location], or null to allow.
/// Signed-out users land on sign-in and come back to [location] afterwards.
String? sessionRedirect(SessionStatus status, Uri location) {
  final path = location.path;
  final from = location.queryParameters['from'];
  final onPreApp = Routes.preApp.contains(path) || path == '/';

  // Sends to [target], remembering where the user was headed. From one
  // onboarding page to the next, keep the original destination.
  String withFrom(String target) {
    final destination = onPreApp ? from : location.toString();
    return destination == null
        ? target
        : Uri(path: target, queryParameters: {'from': destination}).toString();
  }

  switch (status) {
    case SessionStatus.loading:
      return path == Routes.loading ? null : withFrom(Routes.loading);
    case SessionStatus.error:
      return path == Routes.sessionError ? null : Routes.sessionError;
    case SessionStatus.signedOut:
      return path == Routes.signIn ? null : withFrom(Routes.signIn);
    case SessionStatus.needsProfile:
      return path == Routes.onboardingProfile
          ? null
          : withFrom(Routes.onboardingProfile);
    case SessionStatus.ready:
      if (onPreApp) {
        final safe =
            from != null && from.startsWith('/') && !from.startsWith('//');
        return safe ? from : Routes.feed;
      }
      return null;
  }
}

GoRouter buildRouter(SessionGate gate) => GoRouter(
  initialLocation: Routes.feed,
  refreshListenable: gate,
  redirect: (context, state) => sessionRedirect(gate.status, state.uri),
  routes: [
    GoRoute(
      path: Routes.loading,
      builder: (_, _) =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    ),
    GoRoute(
      path: Routes.sessionError,
      builder: (context, _) => _SessionErrorScreen(gate: gate),
    ),
    GoRoute(path: Routes.signIn, builder: (_, _) => const SignInScreen()),
    GoRoute(
      path: Routes.onboardingProfile,
      builder: (_, _) => const ProfileSetupScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (_, _, shell) => AppShell(shell: shell),
      branches: [
        for (final (path, screen) in [
          (Routes.feed, const FeedScreen()),
          (Routes.search, const SearchScreen()),
          (Routes.update, const UpdatePlaceholderScreen()),
          (Routes.library, const LibraryScreen()),
          (Routes.you, const YouScreen()),
        ])
          StatefulShellBranch(
            routes: [GoRoute(path: path, builder: (_, _) => screen)],
          ),
      ],
    ),
    GoRoute(
      path: Routes.bookPattern,
      builder: (_, state) => BookPage(
        key: ValueKey(state.uri.toString()),
        workId: state.pathParameters['workId']!,
        editionId: state.uri.queryParameters['edition'],
      ),
    ),
    GoRoute(path: Routes.scan, builder: (_, _) => const ScanScreen()),
    GoRoute(path: Routes.manualAdd, builder: (_, _) => const ManualAddScreen()),
    GoRoute(path: Routes.settings, builder: (_, _) => const SettingsScreen()),
    if (Env.isDev)
      GoRoute(path: Routes.devSpike, builder: (_, _) => const SpikeScreen()),
  ],
);

class _SessionErrorScreen extends StatelessWidget {
  const _SessionErrorScreen({required this.gate});

  final SessionGate gate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.sessionLoadError),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: gate.refresh,
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
