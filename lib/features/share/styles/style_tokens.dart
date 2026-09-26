import 'package:flutter/painting.dart';

enum ShareTexture { none, paper, grain }

/// Visual tokens for share images. Templates read only from these (plus the
/// optional cover accent), so every template renders in every style.
///
/// Phase 0 ships `minimal`; `cosyPaper`, `bold` and `dark` arrive in Phase 3.
class StyleTokens {
  const StyleTokens({
    required this.id,
    required this.background,
    required this.surface,
    required this.text,
    required this.mutedText,
    required this.accent,
    required this.progressTrack,
    required this.displayFontFamily,
    required this.bodyFontFamily,
    required this.cornerRadius,
    this.texture = ShareTexture.none,
  });

  final String id;
  final Color background;
  final Color surface;
  final Color text;
  final Color mutedText;

  /// Default accent, used when no cover accent passes the contrast check.
  final Color accent;
  final Color progressTrack;
  final String displayFontFamily;
  final String bodyFontFamily;
  final double cornerRadius;
  final ShareTexture texture;

  static const minimal = StyleTokens(
    id: 'minimal',
    background: Color(0xFFFAF8F5),
    surface: Color(0xFFFFFFFF),
    text: Color(0xFF1B1A19),
    mutedText: Color(0xFF6B6661),
    accent: Color(0xFFB8482E),
    progressTrack: Color(0xFFE6E1DA),
    displayFontFamily: 'Fraunces',
    bodyFontFamily: 'Inter',
    cornerRadius: 12,
  );

  static const values = [minimal];
}
