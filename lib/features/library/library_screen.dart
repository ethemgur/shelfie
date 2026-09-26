import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/widgets/cover_image.dart';
import '../../data/models/models.dart';
import '../../l10n/gen/app_localizations.dart';
import 'library_repository.dart';

/// Shelves with counts (Section 6.7). Phase 1 is read-only; sorting, search,
/// swipe actions and quick Update arrive in Phase 2.
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final books = ref.watch(myBooksProvider);
    final all = books.value ?? const <ShelvedBook>[];
    int count(Shelf s) => all.where((b) => b.userBook.shelf == s).length;

    return DefaultTabController(
      length: Shelf.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.tabLibrary),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              for (final shelf in Shelf.values)
                Tab(
                  text: books.hasValue
                      ? l10n.shelfWithCount(
                          l10n.shelfName(shelf.name),
                          count(shelf),
                        )
                      : l10n.shelfName(shelf.name),
                ),
            ],
          ),
        ),
        body: books.when(
          skipLoadingOnReload: true,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.genericError),
                TextButton(
                  onPressed: () => ref.invalidate(myBooksProvider),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
          data: (books) => TabBarView(
            children: [
              for (final shelf in Shelf.values)
                _ShelfList(
                  books: books.where((b) => b.userBook.shelf == shelf).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShelfList extends ConsumerWidget {
  const _ShelfList({required this.books});

  final List<ShelvedBook> books;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (books.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.libraryEmpty, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => context.go(Routes.search),
                child: Text(l10n.findABook),
              ),
            ],
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => ref.refresh(myBooksProvider.future),
      child: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, i) {
          final book = books[i];
          final pages = book.effectivePageCount;
          final reading = book.userBook.shelf == Shelf.currentlyReading;
          return ListTile(
            minVerticalPadding: 8,
            leading: CoverImage(
              url: book.coverUrl,
              width: 40,
              title: book.work.title,
            ),
            title: Text(
              book.work.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: reading && pages != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book.work.authors.join(', ')),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: (book.userBook.currentPage / pages).clamp(0, 1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  )
                : Text(book.work.authors.join(', ')),
            onTap: () => context.push(Routes.book(book.work.id)),
          );
        },
      ),
    );
  }
}
