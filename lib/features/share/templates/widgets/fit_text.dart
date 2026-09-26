import 'package:flutter/widgets.dart';

/// Text that auto-shrinks from [style]'s font size down to [minFontSize] to
/// fit in [maxLines], then ellipsises at [minFontSize].
class FitText extends StatelessWidget {
  const FitText(
    this.text, {
    super.key,
    required this.style,
    required this.minFontSize,
    this.maxLines = 2,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final TextStyle style;
  final double minFontSize;
  final int maxLines;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = fittingFontSize(
          text: text,
          style: style,
          minFontSize: minFontSize,
          maxLines: maxLines,
          maxWidth: constraints.maxWidth,
          textDirection: direction,
          textScaler: scaler,
        );
        return Text(
          text,
          style: style.copyWith(fontSize: size),
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
        );
      },
    );
  }

  /// Largest font size in 1pt steps (from `style.fontSize` down to
  /// [minFontSize]) at which [text] fits in [maxLines]; [minFontSize] if none.
  static double fittingFontSize({
    required String text,
    required TextStyle style,
    required double minFontSize,
    required int maxLines,
    required double maxWidth,
    required TextDirection textDirection,
    TextScaler textScaler = TextScaler.noScaling,
  }) {
    final painter = TextPainter(
      textDirection: textDirection,
      maxLines: maxLines,
      textScaler: textScaler,
    );
    try {
      for (var size = style.fontSize ?? 14; size > minFontSize; size -= 1) {
        painter
          ..text = TextSpan(
            text: text,
            style: style.copyWith(fontSize: size),
          )
          ..layout(maxWidth: maxWidth);
        if (!painter.didExceedMaxLines) return size;
      }
      return minFontSize;
    } finally {
      painter.dispose();
    }
  }
}
