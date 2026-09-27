import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'app/app.dart';
import 'app/firebase_setup.dart';
import 'features/auth/auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Captured before routing rewrites the URL: it may be an email sign-in link.
  final initialLink = Uri.base.toString();
  // Clean URLs on web (/book/123, not /#/book/123) so links can be shared.
  usePathUrlStrategy();
  // Pushed pages (e.g. a book) update the address bar, so web URLs can be
  // shared and reloaded.
  GoRouter.optionURLReflectsImperativeAPIs = true;

  if (!await initFirebase()) {
    runApp(const NotConfiguredApp());
    return;
  }
  runApp(
    ProviderScope(
      overrides: [initialLinkProvider.overrideWithValue(initialLink)],
      child: const ShelfieApp(),
    ),
  );
}
