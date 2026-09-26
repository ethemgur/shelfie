import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'app/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Clean URLs on web (/book/123, not /#/book/123) so links can be shared.
  usePathUrlStrategy();
  // Pushed pages (e.g. a book) update the address bar, so web URLs can be
  // shared and reloaded.
  GoRouter.optionURLReflectsImperativeAPIs = true;

  if (!Env.isConfigured) {
    runApp(const NotConfiguredApp());
    return;
  }
  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabaseAnonKey,
  );
  runApp(const ProviderScope(child: ShelfieApp()));
}
