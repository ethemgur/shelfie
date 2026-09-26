import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads the bundled fonts so golden tests render real glyphs, exactly as
/// share images do on device.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _loadFont('Inter', [
    'assets/fonts/Inter-Regular.ttf',
    'assets/fonts/Inter-SemiBold.ttf',
    'assets/fonts/Inter-ExtraBold.ttf',
  ]);
  await _loadFont('Fraunces', ['assets/fonts/Fraunces-SemiBold.ttf']);
  await testMain();
}

Future<void> _loadFont(String family, List<String> assets) async {
  final loader = FontLoader(family);
  for (final asset in assets) {
    loader.addFont(rootBundle.load(asset));
  }
  await loader.load();
}
