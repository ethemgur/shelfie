import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _seed = Color(0xFFB8482E);

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: brightness,
      ),
      fontFamily: 'Inter',
      // 48dp minimum tap targets.
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
    );
  }
}
