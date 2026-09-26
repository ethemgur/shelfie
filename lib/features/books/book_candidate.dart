import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/models.dart';

part 'book_candidate.freezed.dart';

/// A search/scan result, from our catalogue or an external API. Tapping one
/// either opens the known work ([workId] set) or goes through `upsert_book`.
@freezed
abstract class BookCandidate with _$BookCandidate {
  const BookCandidate._();

  const factory BookCandidate({
    required String title,
    String? subtitle,
    @Default(<String>[]) List<String> authors,
    int? firstPublishedYear,
    String? coverUrl,
    String? openLibraryWorkKey,
    String? isbn13,
    String? isbn10,
    int? pageCount,
    String? publisher,
    String? publishedDate,
    String? language,
    @Default(BookFormat.print) BookFormat format,
    required BookSource source,

    /// Set when the book is already in our catalogue.
    String? workId,
    String? editionId,
  }) = _BookCandidate;

  bool get inCatalogue => workId != null;

  /// Request body for the `upsert_book` Edge Function.
  Map<String, dynamic> toUpsertBody() => {
    'work': {
      'title': title,
      'subtitle': subtitle,
      'authors': authors,
      'first_published_year': firstPublishedYear,
      'cover_url': coverUrl,
      'open_library_work_key': openLibraryWorkKey,
    },
    'edition': {
      'isbn13': isbn13,
      'isbn10': isbn10,
      'format': format.name,
      'page_count': pageCount,
      'publisher': publisher,
      'published_date': publishedDate,
      'language': language,
      'cover_url': coverUrl,
      'source': source.dbValue,
    },
  };
}
