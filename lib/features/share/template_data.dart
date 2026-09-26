import 'package:flutter/painting.dart';

import 'share_format.dart';

/// Render-ready data for a template family. Built from repositories, never
/// from widgets. Images are [ImageProvider]s so the renderer can precache
/// every one of them before capture.
sealed class TemplateData {
  const TemplateData();

  TemplateFamily get family;

  /// Every image the slide may paint. The renderer resolves all of them
  /// before capture and fails rather than export an image with holes.
  Iterable<ImageProvider> get images;
}

/// F1 Session — offered after every page update.
final class SessionTemplateData extends TemplateData {
  const SessionTemplateData({
    required this.title,
    required this.authors,
    required this.fromPage,
    required this.toPage,
    required this.pageCount,
    required this.username,
    this.cover,
    this.photo,
    this.quote,
    this.mood,
    this.weeklyStreak = 0,
  });

  final String title;
  final List<String> authors;
  final int fromPage;
  final int toPage;
  final int pageCount;
  final String username;
  final ImageProvider? cover;
  final ImageProvider? photo;
  final String? quote;
  final String? mood;
  final int weeklyStreak;

  /// Mirrors `page_updates.pages_read`: corrections record 0.
  int get pagesRead => toPage > fromPage ? toPage - fromPage : 0;

  /// Mirrors `page_updates.progress_pct`: 0–100, two decimals.
  double get progressPct {
    final pct = toPage * 100 / pageCount;
    return pct > 100 ? 100 : (pct * 100).roundToDouble() / 100;
  }

  @override
  TemplateFamily get family => TemplateFamily.session;

  @override
  Iterable<ImageProvider> get images => [?cover, ?photo];
}
