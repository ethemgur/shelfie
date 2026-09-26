import 'package:flutter_test/flutter_test.dart';

import '../fixtures/share_fixtures.dart';

void main() {
  group('SessionTemplateData', () {
    test('pagesRead is the forward delta', () {
      expect(sessionFixture(fromPage: 120, toPage: 162).pagesRead, 42);
    });

    test('a correction (lower page) reads 0 pages', () {
      expect(sessionFixture(fromPage: 162, toPage: 120).pagesRead, 0);
    });

    test('progressPct rounds to two decimals', () {
      expect(sessionFixture(toPage: 162, pageCount: 384).progressPct, 42.19);
    });

    test('progressPct is capped at 100', () {
      expect(sessionFixture(toPage: 400, pageCount: 384).progressPct, 100);
    });
  });
}
