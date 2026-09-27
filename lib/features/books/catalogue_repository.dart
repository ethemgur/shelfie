import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/isbn.dart';
import '../../data/models/models.dart';
import '../../data/remote/remote_providers.dart';
import 'book_candidate.dart';

part 'catalogue_repository.g.dart';

typedef CatalogueIds = ({String workId, String editionId});

/// Our own `works` / `editions` collections. Read directly (rules allow it);
/// written only through the `upsertBook` Cloud Function.
class CatalogueRepository {
  CatalogueRepository(this._db, this._functions);

  final FirebaseFirestore _db;
  final FirebaseFunctions _functions;

  CollectionReference<Map<String, dynamic>> get _works =>
      _db.collection('works');
  CollectionReference<Map<String, dynamic>> get _editions =>
      _db.collection('editions');

  /// Exact ISBN, or title-prefix matches already in our catalogue.
  Future<List<BookCandidate>> search(String query, {int limit = 10}) async {
    final isbn = Isbn.normalize13(query);
    if (isbn != null) {
      // Editions with an ISBN use it as their document id.
      final edition = await _editions.doc(isbn).get();
      if (!edition.exists) return const [];
      final e = Edition.fromJson(withId(edition));
      final work = await _works.doc(e.workId).get();
      return [_candidate(Work.fromJson(withId(work)), e)];
    }
    // Prefix match: \uf8ff sorts after every other character.
    final prefix = query.trim().toLowerCase();
    final works = await _works
        .where('titleLower', isGreaterThanOrEqualTo: prefix)
        .where('titleLower', isLessThan: '$prefix\uf8ff')
        .limit(limit)
        .get();
    return Future.wait([
      for (final doc in works.docs)
        editions(doc.id).then(
          (list) =>
              _candidate(Work.fromJson(withId(doc)), defaultEdition(list)),
        ),
    ]);
  }

  /// Writes a search result into the catalogue (or finds its existing row).
  /// [coverPath] is a manual book's cover photo in Storage.
  Future<CatalogueIds> upsert(
    BookCandidate candidate, {
    String? coverPath,
  }) async {
    if (candidate.workId != null && candidate.editionId != null) {
      return (workId: candidate.workId!, editionId: candidate.editionId!);
    }
    final result = await _functions.httpsCallable('upsertBook').call<Object?>({
      ...candidate.toUpsertBody(),
      'coverPath': ?coverPath,
    });
    final data = (result.data as Map).cast<String, dynamic>();
    return (
      workId: data['workId'] as String,
      editionId: data['editionId'] as String,
    );
  }

  Future<Work> work(String workId) async =>
      Work.fromJson(withId(await _works.doc(workId).get()));

  Future<List<Edition>> editions(String workId) async {
    final docs = await _editions
        .where('workId', isEqualTo: workId)
        .orderBy('createdAt')
        .get();
    return [for (final doc in docs.docs) Edition.fromJson(withId(doc))];
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
CatalogueRepository catalogueRepository(Ref ref) => CatalogueRepository(
  ref.watch(firestoreProvider),
  ref.watch(functionsProvider),
);
