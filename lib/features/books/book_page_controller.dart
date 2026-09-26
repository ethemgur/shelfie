import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/models.dart';
import '../library/library_repository.dart';
import 'catalogue_repository.dart';

part 'book_page_controller.g.dart';

class BookPageData {
  const BookPageData({
    required this.work,
    required this.editions,
    required this.myBook,
    required this.preferredEditionId,
  });

  final Work work;
  final List<Edition> editions;

  /// The user's shelf entry for this work, if any.
  final ShelvedBook? myBook;

  /// Edition picked in search / Change edition before the book is shelved.
  final String? preferredEditionId;

  /// The edition shown: the shelved one, else the one picked, else a default.
  Edition? get edition {
    final id = myBook?.userBook.editionId ?? preferredEditionId;
    return editions.where((e) => e.id == id).firstOrNull ??
        CatalogueRepository.defaultEdition(editions);
  }

  int? get effectivePageCount =>
      myBook?.userBook.pageCountOverride ?? edition?.pageCount;

  String? get coverUrl => edition?.coverUrl ?? work.coverUrl;
}

@riverpod
Future<BookPageData> bookPage(
  Ref ref,
  String workId,
  String? preferredEditionId,
) async {
  final catalogue = ref.watch(catalogueRepositoryProvider);
  final library = ref.watch(libraryRepositoryProvider);
  final results = await Future.wait([
    catalogue.work(workId),
    catalogue.editions(workId),
    library.myBookForWork(workId),
  ]);
  return BookPageData(
    work: results[0] as Work,
    editions: results[1] as List<Edition>,
    myBook: results[2] as ShelvedBook?,
    preferredEditionId: preferredEditionId,
  );
}
