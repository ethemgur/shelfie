import 'dart:ui' show Size;

enum TemplateFamily { session, finished, monthStats, monthCalendar, year }

enum ShareFormat {
  /// 1080 × 1920 — Instagram Stories, TikTok, Reels cover.
  story(logicalSize: Size(360, 640)),

  /// 1080 × 1350 — Instagram feed.
  post(logicalSize: Size(360, 450)),

  /// Transparent, content-sized, max 1080 wide. [logicalSize] is the upper
  /// bound; the renderer shrink-wraps the content.
  sticker(logicalSize: Size(360, 640)),

  /// N slides, each rendered at story or post size (see
  /// [TemplateOptions.carouselSlideFormat]).
  carousel(logicalSize: Size(360, 640));

  const ShareFormat({required this.logicalSize});

  /// Layout size in logical pixels. Multiplied by [exportPixelRatio] this
  /// gives the exact export size.
  final Size logicalSize;

  static const double exportPixelRatio = 3.0;

  /// Story safe zones: platform UI overlays the top ~14% and bottom ~18%.
  static const double storySafeTop = 0.14;
  static const double storySafeBottom = 0.18;
}
