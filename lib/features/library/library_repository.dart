import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/dates.dart';
import '../../data/models/models.dart';
import '../../data/remote/remote_providers.dart';

part 'library_repository.g.dart';

/// The signed-in user's `user_books`. Online-only in Phase 1; Phase 2 moves
/// writes behind the offline outbox.
class LibraryRepository {
  LibraryRepository(this._db);

  final SupabaseClient _db;

  static const _select = '*, work:works(*), edition:editions(*)';

  String get _userId => _db.auth.currentUser!.id;

  Future<List<ShelvedBook>> myBooks() async {
    final rows = await _db
        .from('user_books')
        .select(_select)
        .eq('user_id', _userId)
        .order('updated_at', ascending: false);
    return [for (final row in rows) _shelved(row)];
  }

  Future<ShelvedBook?> myBookForWork(String workId) async {
    final row = await _db
        .from('user_books')
        .select(_select)
        .eq('user_id', _userId)
        .eq('work_id', workId)
        .maybeSingle();
    return row == null ? null : _shelved(row);
  }

  Future<void> add({
    required String workId,
    required String? editionId,
    required Shelf shelf,
  }) async {
    final today = localDateString(DateTime.now());
    await _db.from('user_books').insert({
      'id': const Uuid().v4(),
      'user_id': _userId,
      'work_id': workId,
      'edition_id': editionId,
      'shelf': shelf.dbValue,
      if (shelf == Shelf.currentlyReading) 'started_at': today,
      if (shelf == Shelf.read) 'finished_at': today,
    });
  }

  /// Moves a book to [shelf], stamping start/finish dates the first time.
  Future<void> setShelf(UserBook book, Shelf shelf) async {
    final today = localDateString(DateTime.now());
    await _db
        .from('user_books')
        .update({
          'shelf': shelf.dbValue,
          if (shelf == Shelf.currentlyReading && book.startedAt == null)
            'started_at': today,
          if (shelf == Shelf.read && book.finishedAt == null)
            'finished_at': today,
        })
        .eq('id', book.id);
  }

  Future<void> changeEdition(String userBookId, String editionId) => _db
      .from('user_books')
      .update({'edition_id': editionId})
      .eq('id', userBookId);

  Future<void> saveReview(
    String userBookId, {
    required double? rating,
    required String? reviewLine,
  }) => _db
      .from('user_books')
      .update({
        'rating': rating,
        'review_line': (reviewLine?.trim().isEmpty ?? true)
            ? null
            : reviewLine!.trim(),
      })
      .eq('id', userBookId);

  Future<void> remove(String userBookId) =>
      _db.from('user_books').delete().eq('id', userBookId);

  static ShelvedBook _shelved(Map<String, dynamic> row) => ShelvedBook(
    userBook: UserBook.fromJson(row),
    work: Work.fromJson(row['work'] as Map<String, dynamic>),
    edition: row['edition'] == null
        ? null
        : Edition.fromJson(row['edition'] as Map<String, dynamic>),
  );
}

@Riverpod(keepAlive: true)
LibraryRepository libraryRepository(Ref ref) =>
    LibraryRepository(ref.watch(supabaseProvider));

@riverpod
Future<List<ShelvedBook>> myBooks(Ref ref) =>
    ref.watch(libraryRepositoryProvider).myBooks();
