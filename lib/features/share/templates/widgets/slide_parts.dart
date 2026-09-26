import 'package:flutter/widgets.dart';

import '../../../../app/env.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../share_format.dart';
import '../../styles/style_tokens.dart';

/// Full-bleed slide background with the story safe zones applied as padding.
class SlideFrame extends StatelessWidget {
  const SlideFrame({
    super.key,
    required this.style,
    required this.format,
    required this.child,
    this.horizontalPadding = 28,
  });

  final StyleTokens style;
  final ShareFormat format;
  final Widget child;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final size = format.logicalSize;
    final padding = format == ShareFormat.story
        ? EdgeInsets.fromLTRB(
            horizontalPadding,
            size.height * ShareFormat.storySafeTop,
            horizontalPadding,
            size.height * ShareFormat.storySafeBottom,
          )
        : EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24);
    return ColoredBox(
      color: style.background,
      child: Padding(padding: padding, child: child),
    );
  }
}

/// Book cover (2:3) with a neutral placeholder when there is no cover.
///
/// Up to [maxWidth] wide, shrinking to fit the available height so text-heavy
/// slides (long quotes, long titles) never overflow. Wrap in [Flexible] when
/// used inside a [Column].
class ShareCover extends StatelessWidget {
  const ShareCover({
    super.key,
    required this.image,
    required this.style,
    required this.maxWidth,
    this.title,
  });

  final ImageProvider? image;
  final StyleTokens style;
  final double maxWidth;

  /// Printed on the placeholder when there's no cover image.
  final String? title;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = [
          maxWidth,
          constraints.maxWidth,
          constraints.maxHeight / 1.5,
        ].reduce((a, b) => a < b ? a : b);
        return _cover(width);
      },
    );
  }

  Widget _cover(double width) {
    final radius = BorderRadius.circular(style.cornerRadius / 2);
    return Container(
      width: width,
      height: width * 1.5,
      decoration: BoxDecoration(
        borderRadius: radius,
        color: style.progressTrack,
        border: Border.all(color: const Color(0x1F000000)),
      ),
      clipBehavior: Clip.antiAlias,
      child: image != null
          ? Image(image: image!, fit: BoxFit.cover, gaplessPlayback: true)
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  title ?? '',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: style.displayFontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: width / 8,
                    color: style.mutedText,
                  ),
                ),
              ),
            ),
    );
  }
}

class ShareProgressBar extends StatelessWidget {
  const ShareProgressBar({
    super.key,
    required this.percent,
    required this.style,
    this.height = 8,
  });

  /// 0–100.
  final double percent;
  final StyleTokens style;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: style.progressTrack),
            FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: (percent / 100).clamp(0.0, 1.0),
              child: ColoredBox(color: style.accent),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wordmark + `domain/@username`, on every image.
class BrandFooter extends StatelessWidget {
  const BrandFooter({super.key, required this.style, required this.username});

  final StyleTokens style;
  final String username;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Wordmark(style: style),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            l10n.shareProfileFooter(Env.appDomain, username),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontFamily: style.bodyFontFamily,
              fontSize: 11,
              color: style.mutedText,
            ),
          ),
        ),
      ],
    );
  }
}

class Wordmark extends StatelessWidget {
  const Wordmark({super.key, required this.style, this.fontSize = 15});

  final StyleTokens style;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).appName,
      style: TextStyle(
        fontFamily: style.displayFontFamily,
        fontWeight: FontWeight.w600,
        fontSize: fontSize,
        color: style.text,
      ),
    );
  }
}

/// `42.5` → `"42.5"`, `42.0` → `"42"`.
String formatPercent(double pct) {
  final rounded = (pct * 10).round() / 10;
  return rounded == rounded.roundToDouble()
      ? rounded.toStringAsFixed(0)
      : rounded.toStringAsFixed(1);
}
