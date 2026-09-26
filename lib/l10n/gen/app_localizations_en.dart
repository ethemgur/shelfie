// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Shelfie';

  @override
  String get homeComingSoon => 'Your reading loop starts here.';

  @override
  String get devSpikeEntry => 'Rendering spike';

  @override
  String sharePagesDelta(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages',
      one: '1 page',
    );
    return '+$_temp0';
  }

  @override
  String sharePageRange(int from, int to) {
    return 'p.$from → $to';
  }

  @override
  String shareProgressPercent(String percent) {
    return '$percent%';
  }

  @override
  String shareWeeklyStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count week streak',
      one: '1 week streak',
    );
    return '$_temp0';
  }

  @override
  String shareProfileFooter(String domain, String username) {
    return '$domain/@$username';
  }

  @override
  String shareSlideCounter(int index, int total) {
    return '$index / $total';
  }

  @override
  String get spikeTitle => 'Rendering spike';

  @override
  String get spikeRenderStory => 'Render session_minimal (story)';

  @override
  String get spikeRenderCarousel => 'Render 3-slide carousel';

  @override
  String get spikeShareInstagram => 'Instagram Stories';

  @override
  String get spikeShareSystem => 'Share…';

  @override
  String get spikeRendering => 'Rendering…';

  @override
  String spikeResult(int count, int width, int height, int millis) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count images',
      one: '1 image',
    );
    return '$_temp0 · $width×$height · $millis ms';
  }

  @override
  String spikeError(String message) {
    return 'Render failed: $message';
  }

  @override
  String spikeCarouselHeadline(int index) {
    return 'Slide $index';
  }
}
