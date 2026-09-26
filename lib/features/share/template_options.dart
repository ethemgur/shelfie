import 'share_format.dart';

/// User-controlled toggles from the composer. Templates ignore options that
/// don't apply to them.
class TemplateOptions {
  const TemplateOptions({
    this.showQuote = true,
    this.showMood = true,
    this.showStreak = true,
    this.showRating = true,
    this.showDates = true,
    this.carouselSlideFormat = ShareFormat.story,
  }) : assert(
         carouselSlideFormat == ShareFormat.story ||
             carouselSlideFormat == ShareFormat.post,
       );

  final bool showQuote;
  final bool showMood;
  final bool showStreak;
  final bool showRating;
  final bool showDates;

  /// Slide size for [ShareFormat.carousel].
  final ShareFormat carouselSlideFormat;
}
