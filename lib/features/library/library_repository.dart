import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/dates.dart';
import '../../data/models/models.dart';
import '../../data/remote/remote_providers.dart';

part 'library_repository.g.dart';

/// The signed-in user's `userBooks` (id `<uid>_<workId>`: one entry per
/// work). Firestore queues writes while offline; Phase 2 decides whether that
/// is enough for the offline-first update flow.
class LibraryRepository {
  LibraryRepository(this._db, this._auth);

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  String get _userId => _auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _userBooks =>
      _db.collection('userBooks');

  DocumentReference<Map<String, dynamic>> _doc(String workId) =>
      _userBooks.doc('${_userId}_$workId');

  Future<List<ShelvedBook>> myBooks() async {
    final docs = await _userBooks
        .where('userId', isEqualTo: _userId)
        .orderBy('updatedAt', descending: true)
        .get();
    return Future.wait([for (final doc in docs.docs) _shelved(doc)]);
  }

  Future<ShelvedBook?> myBookForWork(String workId) async {
    final doc = await _doc(workId).get();
    return doc.exists ? _shelved(doc) : null;
  }

  Future<void> add({
    required String workId,
    required String? editionId,
    required Shelf shelf,
  }) {
    final today = localDateString(DateTime.now());
    return _doc(workId).set({
      'userId': _userId,
      'workId': workId,
      'editionId': editionId,
      'shelf': shelf.dbValue,
      'currentPage': 0,
      'startedAt': shelf == Shelf.currentlyReading ? today : null,
      'finishedAt': shelf == Shelf.read ? today : null,
      'source': 'app',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Moves a book to [shelf], stamping start/finish dates the first time.
  Future<void> setShelf(UserBook book, Shelf shelf) {
    final today = localDateString(DateTime.now());
    return _userBooks.doc(book.id).update({
      'shelf': shelf.dbValue,
      if (shelf == Shelf.currentlyReading && book.startedAt == null)
        'startedAt': today,
      if (shelf == Shelf.read && book.finishedAt == null) 'finishedAt': today,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> changeEdition(String userBookId, String editionId) =>
      _userBooks.doc(userBookId).update({
        'editionId': editionId,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  Future<void> saveReview(
    String userBookId, {
    required double? rating,
    required String? reviewLine,
  }) => _userBooks.doc(userBookId).update({
    'rating': rating,
    'reviewLine': (reviewLine?.trim().isEmpty ?? true)
        ? null
        : reviewLine!.trim(),
    'updatedAt': FieldValue.serverTimestamp(),
  });

  Future<void> remove(String userBookId) => _userBooks.doc(userBookId).delete();

  Future<ShelvedBook> _shelved(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    final book = UserBook.fromJson(withId(doc));
    final results = await Future.wait([
      _db.collection('works').doc(book.workId).get(),
      if (book.editionId != null)
        _db.collection('editions').doc(book.editionId).get(),
    ]);
    return ShelvedBook(
      userBook: book,
      work: Work.fromJson(withId(results[0])),
      edition: results.length > 1 && results[1].exists
          ? Edition.fromJson(withId(results[1]))
          : null,
    );
  }
}

@Riverpod(keepAlive: true)
LibraryRepository libraryRepository(Ref ref) => LibraryRepository(
  ref.watch(firestoreProvider),
  ref.watch(firebaseAuthProvider),
);

@riverpod
Future<List<ShelvedBook>> myBooks(Ref ref) =>
    ref.watch(libraryRepositoryProvider).myBooks();
