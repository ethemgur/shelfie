import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/isbn.dart';
import '../../features/books/book_candidate.dart';
import '../models/models.dart';

/// Google Books volumes API (fallback book source). Keyless, so quota is
/// shared; failures are non-fatal to search.
class GoogleBooksApi {
  GoogleBooksApi(this._http, {this.apiKey = ''});

  final http.Client _http;
  final String apiKey;

  Future<List<BookCandidate>> search(String query, {int limit = 20}) async {
    final uri = Uri.https('www.googleapis.com', '/books/v1/volumes', {
      'q': query,
      'maxResults': '$limit',
      'printType': 'books',
      if (apiKey.isNotEmpty) 'key': apiKey,
    });
    final response = await _http.get(uri);
    if (response.statusCode != 200) {
      throw http.ClientException('HTTP ${response.statusCode}', uri);
    }
    return parseVolumes(
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
    );
  }

  Future<BookCandidate?> byIsbn(String isbn13) async =>
      (await search('isbn:$isbn13', limit: 1)).firstOrNull;

  static List<BookCandidate> parseVolumes(Map<String, dynamic> json) {
    final items = (json['items'] as List? ?? const []).cast<Map>();
    return [
      for (final item in items)
        ?_parse((item['volumeInfo'] as Map?)?.cast<String, dynamic>()),
    ];
  }

  static BookCandidate? _parse(Map<String, dynamic>? info) {
    final title = info?['title'];
    if (info == null || title is! String || title.isEmpty) return null;
    String? isbn13;
    String? isbn10;
    for (final id in (info['industryIdentifiers'] as List? ?? const [])) {
      final type = (id as Map)['type'];
      final value = Isbn.clean('${id['identifier']}');
      if (type == 'ISBN_13' && Isbn.isValid13(value)) isbn13 = value;
      if (type == 'ISBN_10' && Isbn.isValid10(value)) isbn10 = value;
    }
    isbn13 ??= isbn10 == null ? null : Isbn.from10(isbn10);
    final published = info['publishedDate'] as String?;
    final pages = info['pageCount'];
    final links = (info['imageLinks'] as Map?)?.cast<String, dynamic>();
    final thumb = (links?['thumbnail'] ?? links?['smallThumbnail']) as String?;
    return BookCandidate(
      title: title,
      subtitle: info['subtitle'] as String?,
      authors: [
        for (final a in (info['authors'] as List? ?? const [])) a.toString(),
      ],
      firstPublishedYear: int.tryParse(published?.split('-').first ?? ''),
      coverUrl: thumb?.replaceFirst('http://', 'https://'),
      isbn13: isbn13,
      isbn10: isbn10,
      pageCount: pages is int && pages > 0 && pages <= 20000 ? pages : null,
      publisher: info['publisher'] as String?,
      publishedDate: published,
      language: info['language'] as String?,
      source: BookSource.googleBooks,
    );
  }
}
