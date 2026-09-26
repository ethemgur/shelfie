/// ISBN helpers. Mirrors `supabase/functions/upsert_book/validate.ts`.
abstract final class Isbn {
  /// Strips spaces/hyphens and upper-cases a trailing x.
  static String clean(String raw) =>
      raw.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();

  static bool isValid13(String isbn) {
    if (!RegExp(r'^97[89]\d{10}$').hasMatch(isbn)) return false;
    var sum = 0;
    for (var i = 0; i < 12; i++) {
      sum += int.parse(isbn[i]) * (i.isEven ? 1 : 3);
    }
    return (10 - sum % 10) % 10 == int.parse(isbn[12]);
  }

  static bool isValid10(String isbn) {
    if (!RegExp(r'^\d{9}[\dX]$').hasMatch(isbn)) return false;
    var sum = 0;
    for (var i = 0; i < 10; i++) {
      final digit = isbn[i] == 'X' ? 10 : int.parse(isbn[i]);
      sum += digit * (10 - i);
    }
    return sum % 11 == 0;
  }

  static String from10(String isbn10) {
    final core = '978${isbn10.substring(0, 9)}';
    var sum = 0;
    for (var i = 0; i < 12; i++) {
      sum += int.parse(core[i]) * (i.isEven ? 1 : 3);
    }
    return '$core${(10 - sum % 10) % 10}';
  }

  /// A valid ISBN-13 for [raw] (an ISBN-10 or -13 in any formatting), or
  /// null if it isn't one.
  static String? normalize13(String raw) {
    final isbn = clean(raw);
    if (isValid13(isbn)) return isbn;
    if (isValid10(isbn)) return from10(isbn);
    return null;
  }
}
