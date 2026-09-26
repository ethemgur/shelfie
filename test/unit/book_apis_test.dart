import 'package:flutter_test/flutter_test.dart';
import 'package:shelfie/data/models/models.dart';
import 'package:shelfie/data/remote/google_books_api.dart';
import 'package:shelfie/data/remote/open_library_api.dart';
import 'package:shelfie/features/books/book_candidate.dart';

void main() {
  group('OpenLibraryApi', () {
    test('parses search docs into work-level candidates', () {
      final results = OpenLibraryApi.parseSearch({
        'docs': [
          {
            'key': '/works/OL66554W',
            'title': 'Pride and Prejudice',
            'author_name': ['Jane Austen'],
            'first_publish_year': 1813,
            'cover_i': 14348537,
            'number_of_pages_median': 432,
          },
          {'key': '/works/OL1W'}, // no title: skipped
          {'title': 'No key'}, // no key: skipped
        ],
      });
      expect(results, hasLength(1));
      final book = results.single;
      expect(book.openLibraryWorkKey, '/works/OL66554W');
      expect(book.authors, ['Jane Austen']);
      expect(book.pageCount, 432);
      expect(
        book.coverUrl,
        'https://covers.openlibrary.org/b/id/14348537-L.jpg',
      );
      expect(book.isbn13, isNull);
      expect(book.source, BookSource.openLibrary);
    });

    test('merges an edition record over its work', () {
      const work = BookCandidate(
        title: 'Pride and Prejudice',
        authors: ['Jane Austen'],
        openLibraryWorkKey: '/works/OL66554W',
        pageCount: 432,
        source: BookSource.openLibrary,
      );
      final edition = OpenLibraryApi.mergeEdition(work, {
        'isbn_10': ['0141439513'],
        'number_of_pages': 480,
        'publishers': ['Penguin'],
        'publish_date': '2003',
        'physical_format': 'Paperback',
        'covers': [-1, 42],
        'languages': [
          {'key': '/languages/eng'},
        ],
      }, null);
      expect(edition.isbn13, '9780141439518'); // derived from ISBN-10
      expect(edition.isbn10, '0141439513');
      expect(edition.pageCount, 480);
      expect(edition.publisher, 'Penguin');
      expect(edition.language, 'eng');
      expect(edition.format, BookFormat.print);
      expect(edition.coverUrl, 'https://covers.openlibrary.org/b/id/42-L.jpg');
      expect(edition.authors, ['Jane Austen']);
    });

    test('maps free-text physical formats', () {
      expect(OpenLibraryApi.formatFrom('Audio CD'), BookFormat.audiobook);
      expect(OpenLibraryApi.formatFrom('Kindle Edition'), BookFormat.ebook);
      expect(OpenLibraryApi.formatFrom('Hardcover'), BookFormat.print);
      expect(OpenLibraryApi.formatFrom(null), BookFormat.print);
    });
  });

  group('GoogleBooksApi', () {
    test('parses volumes, preferring https covers and valid ISBNs', () {
      final results = GoogleBooksApi.parseVolumes({
        'items': [
          {
            'volumeInfo': {
              'title': 'Kürk Mantolu Madonna',
              'authors': ['Sabahattin Ali'],
              'publishedDate': '2019-05-01',
              'pageCount': 160,
              'industryIdentifiers': [
                {'type': 'ISBN_10', 'identifier': '0141439513'},
                {'type': 'OTHER', 'identifier': 'XYZ'},
              ],
              'imageLinks': {'thumbnail': 'http://books.google.com/x.jpg'},
            },
          },
          {'volumeInfo': <String, dynamic>{}}, // no title: skipped
          {'kind': 'books#volume'}, // no volumeInfo: skipped
        ],
      });
      expect(results, hasLength(1));
      final book = results.single;
      expect(book.title, 'Kürk Mantolu Madonna');
      expect(book.isbn13, '9780141439518');
      expect(book.firstPublishedYear, 2019);
      expect(book.pageCount, 160);
      expect(book.coverUrl, 'https://books.google.com/x.jpg');
      expect(book.source, BookSource.googleBooks);
    });

    test('empty responses parse to nothing', () {
      expect(GoogleBooksApi.parseVolumes({'totalItems': 0}), isEmpty);
    });
  });

  test('BookCandidate.toUpsertBody matches the upsert_book contract', () {
    const book = BookCandidate(
      title: 'My Zine',
      authors: ['Me'],
      pageCount: 40,
      format: BookFormat.ebook,
      source: BookSource.user,
    );
    final body = book.toUpsertBody();
    expect(body['work'], containsPair('title', 'My Zine'));
    expect(body['work'], containsPair('authors', ['Me']));
    expect(body['edition'], containsPair('source', 'user'));
    expect(body['edition'], containsPair('format', 'ebook'));
    expect(body['edition'], containsPair('page_count', 40));
  });
}
