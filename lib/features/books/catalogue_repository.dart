import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/isbn.dart';
import '../../data/models/models.dart';
import '../../data/remote/remote_providers.dart';
import 'book_candidate.dart';

part 'catalogue_repository.g.dart';

typedef CatalogueIds = ({String workId, String editionId});

/// Our own `works` / `editions` tables. Read directly (RLS allows it); written
/// only through the `upsert_book` Edge Function.
class CatalogueRepository {
  CatalogueRepository(this._db);

  final SupabaseClient _db;

  static const _editionColumns =
      'id, work_id, isbn13, isbn10, format, page_count, publisher, '
      'published_date, language, cover_url, source';

  /// Title (or exact ISBN) matches already in our catalogue.
  Future<List<BookCandidate>> search(String query, {int limit = 10}) async {
    final isbn = Isbn.normalize13(query);
    if (isbn != null) {
      final rows = await _db
          .from('editions')
          .select('$_editionColumns, work:works(*)')
          .eq('isbn13', isbn)
          .limit(1);
      return [
        for (final row in rows)
          _candidate(
            Work.fromJson(row['work'] as Map<String, dynamic>),
            Edition.fromJson(row),
          ),
      ];
    }
    final escaped = query.replaceAll(RegExp(r'[%_\\]'), '');
    final rows = await _db
        .from('works')
        .select('*, editions($_editionColumns)')
        .ilike('title', '%$escaped%')
        .limit(limit);
    return [
      for (final row in rows)
        _candidate(
          Work.fromJson(row),
          defaultEdition([
            for (final e in row['editions'] as List)
              Edition.fromJson(e as Map<String, dynamic>),
          ]),
        ),
    ];
  }

  /// Writes a search result into the catalogue (or finds its existing row).
  Future<CatalogueIds> upsert(BookCandidate candidate) async {
    if (candidate.workId != null && candidate.editionId != null) {
      return (workId: candidate.workId!, editionId: candidate.editionId!);
    }
    final response = await _db.functions.invoke(
      'upsert_book',
      body: candidate.toUpsertBody(),
    );
    final data = response.data as Map<String, dynamic>;
    return (
      workId: data['work_id'] as String,
      editionId: data['edition_id'] as String,
    );
  }

  Future<Work> work(String workId) async =>
      Work.fromJson(await _db.from('works').select().eq('id', workId).single());

  Future<List<Edition>> editions(String workId) async {
    final rows = await _db
        .from('editions')
        .select(_editionColumns)
        .eq('work_id', workId)
        .order('created_at');
    return [for (final row in rows) Edition.fromJson(row)];
  }

  /// The edition to shelve a work with when the user hasn't picked one:
  /// prefer one with a page count, then print, then the oldest.
  static Edition? defaultEdition(List<Edition> editions) {
    if (editions.isEmpty) return null;
    int score(Edition e) =>
        (e.pageCount != null ? 2 : 0) + (e.format == BookFormat.print ? 1 : 0);
    return editions.reduce((best, e) => score(e) > score(best) ? e : best);
  }

  static BookCandidate _candidate(Work work, Edition? edition) => BookCandidate(
    title: work.title,
    subtitle: work.subtitle,
    authors: work.authors,
    firstPublishedYear: work.firstPublishedYear,
    coverUrl: edition?.coverUrl ?? work.coverUrl,
    openLibraryWorkKey: work.openLibraryWorkKey,
    isbn13: edition?.isbn13,
    isbn10: edition?.isbn10,
    pageCount: edition?.pageCount,
    format: edition?.format ?? BookFormat.print,
    source: edition?.source ?? BookSource.openLibrary,
    workId: work.id,
    editionId: edition?.id,
  );
}

@Riverpod(keepAlive: true)
CatalogueRepository catalogueRepository(Ref ref) =>
    CatalogueRepository(ref.watch(supabaseProvider));
