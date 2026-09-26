import 'package:flutter_test/flutter_test.dart';
import 'package:shelfie/core/isbn.dart';

void main() {
  test('validates ISBN-13 checksums', () {
    expect(Isbn.isValid13('9780141439518'), isTrue);
    expect(Isbn.isValid13('9780141439519'), isFalse);
    expect(Isbn.isValid13('1234567890123'), isFalse);
  });

  test('validates ISBN-10 checksums, including X', () {
    expect(Isbn.isValid10('0141439513'), isTrue);
    expect(Isbn.isValid10('080442957X'), isTrue);
    expect(Isbn.isValid10('0141439514'), isFalse);
  });

  test('normalize13 accepts formatted ISBN-10s and -13s', () {
    expect(Isbn.normalize13('978-0-14-143951-8'), '9780141439518');
    expect(Isbn.normalize13(' 0-14-143951-3 '), '9780141439518');
    expect(Isbn.normalize13('080442957x'), '9780804429573');
    expect(Isbn.normalize13('Pride and Prejudice'), isNull);
    expect(Isbn.normalize13('9780141439519'), isNull);
  });
}
