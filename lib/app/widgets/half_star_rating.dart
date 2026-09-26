import 'package:flutter/material.dart';

/// 0.5–5 star rating in half steps. Tap the left half of a star for a half.
/// Tapping the current value clears it.
class HalfStarRating extends StatelessWidget {
  const HalfStarRating({
    super.key,
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
    this.size = 36,
  });

  final double? value;
  final ValueChanged<double?> onChanged;
  final String semanticLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final rating = value ?? 0;
    return Semantics(
      label: semanticLabel,
      value: value?.toString(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= 5; i++)
            SizedBox(
              width: size + 12,
              height: 48,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    rating >= i
                        ? Icons.star_rounded
                        : rating >= i - 0.5
                        ? Icons.star_half_rounded
                        : Icons.star_outline_rounded,
                    size: size,
                    color: color,
                  ),
                  Row(
                    children: [
                      for (final half in [i - 0.5, i.toDouble()])
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => onChanged(half == value ? null : half),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
