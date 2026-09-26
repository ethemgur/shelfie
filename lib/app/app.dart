import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/gen/app_localizations.dart';
import 'router.dart';
import 'theme.dart';

class ShelfieApp extends StatefulWidget {
  const ShelfieApp({super.key});

  @override
  State<ShelfieApp> createState() => _ShelfieAppState();
}

class _ShelfieAppState extends State<ShelfieApp> {
  late final GoRouter _router = buildRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
