import 'package:flutter_test/flutter_test.dart';
import 'package:shelfie/data/models/models.dart';
import 'package:shelfie/features/books/book_candidate.dart';
import 'package:shelfie/features/books/book_search.dart';
import 'package:shelfie/features/books/catalogue_repository.dart';

BookCandidate book(
  String title, {
  String? isbn,
  String? key,
  String? workId,
  String author = 'Jane Austen',
  BookSource source = BookSource.openLibrary,
}) => BookCandidate(
  title: title,
  authors: [author],
  isbn13: isbn,
  openLibraryWorkKey: key,
  workId: workId,
  source: source,
);

void main() {
  group('BookSearch.mergeResults', () {
    test('keeps priority order: catalogue, Open Library, Google Books', () {
      final merged = BookSearch.mergeResults([
        [book('Emma', key: '/works/OL1W', workId: 'w1')],
        [book('Persuasion', key: '/works/OL2W')],
        [
          book(
            'Sanditon',
            isbn: '9780141439518',
            source: BookSource.googleBooks,
          ),
        ],
      ]);
      expect(merged.map((b) => b.title), ['Emma', 'Persuasion', 'Sanditon']);
    });

    test('drops later duplicates by Open Library work key', () {
      final merged = BookSearch.mergeResults([
        [book('Emma', key: '/works/OL1W', workId: 'w1')],
        [book('Emma (OL copy)', key: '/works/OL1W')],
      ]);
      expect(merged.single.workId, 'w1');
    });

    test('drops later duplicates by ISBN-13', () {
      final merged = BookSearch.mergeResults([
        [book('Emma', isbn: '9780141439518')],
        [
          book(
            'Emma (Google)',
            isbn: '9780141439518',
            source: BookSource.googleBooks,
          ),
        ],
      ]);
      expect(merged.single.title, 'Emma');
    });

    test('drops key-less results matching an earlier title and author', () {
      final merged = BookSearch.mergeResults([
        [book('Pride and Prejudice', key: '/works/OL66554W')],
        [
          book('Pride and Prejudice!', source: BookSource.googleBooks),
          book('pride and prejudice', source: BookSource.googleBooks),
          book(
            'Pride and Prejudice',
            author: 'Someone Else',
            source: BookSource.googleBooks,
          ),
        ],
      ]);
      expect(merged, hasLength(2));
      expect(merged.last.authors, ['Someone Else']);
    });

    test('never drops distinct works with the same title', () {
      final merged = BookSearch.mergeResults([
        [book('Emma', key: '/works/OL1W'), book('Emma', key: '/works/OL2W')],
      ]);
      expect(merged, hasLength(2));
    });
  });

  group('CatalogueRepository.defaultEdition', () {
    Edition edition(String id, {int? pages, BookFormat f = BookFormat.print}) =>
        Edition(
          id: id,
          workId: 'w',
          pageCount: pages,
          format: f,
          source: BookSource.openLibrary,
        );

    test('prefers a page count, then print, then the oldest', () {
      expect(CatalogueRepository.defaultEdition([]), isNull);
      expect(
        CatalogueRepository.defaultEdition([
          edition('a'),
          edition('b', pages: 300, f: BookFormat.ebook),
          edition('c', pages: 320),
          edition('d', pages: 280),
        ])!.id,
        'c',
      );
    });
  });
}
