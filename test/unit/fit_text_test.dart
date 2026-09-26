import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelfie/features/share/templates/widgets/fit_text.dart';

void main() {
  const style = TextStyle(fontFamily: 'Fraunces', fontSize: 28);

  double fit(String text) => FitText.fittingFontSize(
    text: text,
    style: style,
    minFontSize: 16,
    maxLines: 2,
    maxWidth: 300,
    textDirection: TextDirection.ltr,
  );

  test('short titles keep the max size', () {
    expect(fit('Emma'), 28);
  });

  test('long titles shrink but not below the minimum', () {
    final size = fit(
      'The Remarkable and Entirely Improbable Adventures of a Very Long '
      'Title That Goes On',
    );
    expect(size, lessThan(28));
    expect(size, greaterThanOrEqualTo(16));
  });

  test('titles that never fit fall back to the minimum', () {
    expect(fit('Word ' * 80), 16);
  });
}
