import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/isbn.dart';
import '../../features/books/book_candidate.dart';
import '../models/models.dart';

/// Open Library Search / Works / Editions APIs (primary book source).
class OpenLibraryApi {
  OpenLibraryApi(this._http);

  final http.Client _http;

  static const _host = 'openlibrary.org';
  static const _searchFields =
      'key,title,subtitle,author_name,first_publish_year,cover_i,'
      'number_of_pages_median';

  /// Work-level results for a title/author query.
  Future<List<BookCandidate>> search(String query, {int limit = 20}) async {
    final uri = Uri.https(_host, '/search.json', {
      'q': query,
      'fields': _searchFields,
      'limit': '$limit',
    });
    return parseSearch(await _getJson(uri));
  }

  /// The exact edition for an ISBN, with its work's title and authors.
  Future<BookCandidate?> byIsbn(String isbn13) async {
    final results = await Future.wait([
      _getJson(
        Uri.https(_host, '/search.json', {
          'q': 'isbn:$isbn13',
          'fields': _searchFields,
          'limit': '1',
        }),
      ),
      _getJsonOrNull(Uri.https(_host, '/isbn/$isbn13.json')),
    ]);
    final works = parseSearch(results[0]!);
    final edition = results[1];
    if (works.isEmpty && edition == null) return null;
    return mergeEdition(works.firstOrNull, edition, isbn13);
  }

  /// Editions of a work, for "Change edition".
  Future<List<BookCandidate>> editions(BookCandidate work) async {
    final key = work.openLibraryWorkKey;
    if (key == null) return const [];
    final json = await _getJson(
      Uri.https(_host, '$key/editions.json', {'limit': '50'}),
    );
    final entries = (json['entries'] as List? ?? const []).cast<Map>();
    return [
      for (final entry in entries)
        mergeEdition(work, entry.cast<String, dynamic>(), null),
    ];
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final response = await _http.get(uri);
    if (response.statusCode != 200) {
      throw http.ClientException('HTTP ${response.statusCode}', uri);
    }
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>?> _getJsonOrNull(Uri uri) async {
    final response = await _http.get(uri);
    if (response.statusCode != 200) return null;
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }

  static String coverUrl(int coverId, {String size = 'L'}) =>
      'https://covers.openlibrary.org/b/id/$coverId-$size.jpg';

  static List<BookCandidate> parseSearch(Map<String, dynamic> json) {
    final docs = (json['docs'] as List? ?? const []).cast<Map>();
    return [
      for (final doc in docs)
        if (doc['title'] is String && doc['key'] is String)
          BookCandidate(
            title: doc['title'] as String,
            subtitle: doc['subtitle'] as String?,
            authors: [
              for (final a in (doc['author_name'] as List? ?? const []))
                a.toString(),
            ],
            firstPublishedYear: doc['first_publish_year'] as int?,
            coverUrl: doc['cover_i'] is int
                ? coverUrl(doc['cover_i'] as int)
                : null,
            openLibraryWorkKey: doc['key'] as String,
            pageCount: _positive(doc['number_of_pages_median']),
            source: BookSource.openLibrary,
          ),
    ];
  }

  /// Combines work-level data with an Open Library edition record.
  static BookCandidate mergeEdition(
    BookCandidate? work,
    Map<String, dynamic>? edition,
    String? isbn13,
  ) {
    final e = edition ?? const {};
    final covers = (e['covers'] as List? ?? const []).whereType<int>().where(
      (id) => id > 0,
    );
    final isbn13s = (e['isbn_13'] as List? ?? const []).map(
      (i) => Isbn.normalize13(i.toString()),
    );
    final isbn10s = (e['isbn_10'] as List? ?? const [])
        .map((i) => Isbn.clean(i.toString()))
        .where(Isbn.isValid10);
    final publishers = (e['publishers'] as List? ?? const []);
    final languages = (e['languages'] as List? ?? const []).cast<Map>();
    return BookCandidate(
      title: work?.title ?? (e['title'] as String? ?? ''),
      subtitle: work?.subtitle ?? e['subtitle'] as String?,
      authors: work?.authors ?? const [],
      firstPublishedYear: work?.firstPublishedYear,
      coverUrl: covers.isNotEmpty ? coverUrl(covers.first) : work?.coverUrl,
      openLibraryWorkKey:
          work?.openLibraryWorkKey ??
          ((e['works'] as List?)?.cast<Map>().firstOrNull?['key'] as String?),
      isbn13: isbn13 ?? isbn13s.nonNulls.firstOrNull ?? _from10(isbn10s),
      isbn10: isbn10s.firstOrNull,
      pageCount: _positive(e['number_of_pages']) ?? work?.pageCount,
      publisher: publishers.isEmpty ? null : publishers.first.toString(),
      publishedDate: e['publish_date'] as String?,
      language: (languages.firstOrNull?['key'] as String?)?.split('/').last,
      format: formatFrom(e['physical_format'] as String?),
      source: BookSource.openLibrary,
    );
  }

  static String? _from10(Iterable<String> isbn10s) =>
      isbn10s.isEmpty ? null : Isbn.from10(isbn10s.first);

  /// Maps Open Library's free-text `physical_format`.
  static BookFormat formatFrom(String? physicalFormat) {
    final f = physicalFormat?.toLowerCase() ?? '';
    if (f.contains('audio') || f.contains('cd') || f.contains('mp3')) {
      return BookFormat.audiobook;
    }
    if (f.contains('ebook') || f.contains('e-book') || f.contains('kindle')) {
      return BookFormat.ebook;
    }
    return BookFormat.print;
  }

  static int? _positive(Object? value) =>
      value is int && value > 0 && value <= 20000 ? value : null;
}
