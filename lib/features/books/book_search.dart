import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/isbn.dart';
import '../../data/remote/google_books_api.dart';
import '../../data/remote/open_library_api.dart';
import '../../data/remote/remote_providers.dart';
import 'book_candidate.dart';
import 'catalogue_repository.dart';

part 'book_search.g.dart';

/// Search across our catalogue, Open Library and Google Books (Section 6.5).
/// Sources run in parallel; results are merged in that priority order.
class BookSearch {
  BookSearch({
    required this.catalogue,
    required this.openLibrary,
    required this.googleBooks,
  });

  final CatalogueRepository catalogue;
  final OpenLibraryApi openLibrary;
  final GoogleBooksApi googleBooks;

  Future<List<BookCandidate>> search(String rawQuery) async {
    final query = rawQuery.trim();
    if (query.length < 2) return const [];
    final isbn = Isbn.normalize13(query);

    final sources = await Future.wait<List<BookCandidate>?>([
      _safe(() => catalogue.search(query)),
      _safe(
        () async => isbn != null
            ? [?await openLibrary.byIsbn(isbn)]
            : openLibrary.search(query),
      ),
      _safe(
        () async => isbn != null
            ? [?await googleBooks.byIsbn(isbn)]
            : googleBooks.search(query),
      ),
    ]);
    if (sources.every((s) => s == null)) {
      throw const BookSearchException();
    }
    return mergeResults([for (final s in sources) s ?? const []]);
  }

  static Future<List<BookCandidate>?> _safe(
    Future<List<BookCandidate>> Function() load,
  ) async {
    try {
      return await load();
    } catch (e) {
      debugPrint('Book search source failed: $e');
      return null;
    }
  }

  /// Merges sources in priority order, dropping later results that match an
  /// earlier one by ISBN-13 or Open Library work key. Results without either
  /// (common in Google Books) are also matched on title + first author.
  static List<BookCandidate> mergeResults(List<List<BookCandidate>> sources) {
    final seenIsbns = <String>{};
    final seenWorkKeys = <String>{};
    final seenTitles = <String>{};
    final merged = <BookCandidate>[];
    for (final source in sources) {
      for (final book in source) {
        final titleKey = _titleKey(book);
        final duplicate =
            (book.isbn13 != null && seenIsbns.contains(book.isbn13)) ||
            (book.openLibraryWorkKey != null &&
                seenWorkKeys.contains(book.openLibraryWorkKey)) ||
            (book.openLibraryWorkKey == null && seenTitles.contains(titleKey));
        if (duplicate) continue;
        merged.add(book);
        if (book.isbn13 != null) seenIsbns.add(book.isbn13!);
        if (book.openLibraryWorkKey != null) {
          seenWorkKeys.add(book.openLibraryWorkKey!);
        }
        seenTitles.add(titleKey);
      }
    }
    return merged;
  }

  static String _titleKey(BookCandidate book) {
    String norm(String s) =>
        s.toLowerCase().replaceAll(RegExp(r'[^\p{L}\p{N}]', unicode: true), '');
    return '${norm(book.title)}|${norm(book.authors.firstOrNull ?? '')}';
  }
}

class BookSearchException implements Exception {
  const BookSearchException();
}

@Riverpod(keepAlive: true)
BookSearch bookSearch(Ref ref) => BookSearch(
  catalogue: ref.watch(catalogueRepositoryProvider),
  openLibrary: ref.watch(openLibraryApiProvider),
  googleBooks: ref.watch(googleBooksApiProvider),
);

/// Results for one query. Debounced by the search screen.
@riverpod
Future<List<BookCandidate>> bookSearchResults(Ref ref, String query) =>
    ref.watch(bookSearchProvider).search(query);
