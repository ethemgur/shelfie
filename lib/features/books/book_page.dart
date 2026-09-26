import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/widgets/cover_image.dart';
import '../../app/widgets/half_star_rating.dart';
import '../../data/models/models.dart';
import '../../l10n/gen/app_localizations.dart';
import '../library/library_repository.dart';
import 'book_page_controller.dart';
import 'change_edition_sheet.dart';

/// Book page (Section 6.6), without the social parts (Phase 4) and the
/// Update page button (Phase 2).
class BookPage extends ConsumerStatefulWidget {
  const BookPage({super.key, required this.workId, this.editionId});

  final String workId;
  final String? editionId;

  @override
  ConsumerState<BookPage> createState() => _BookPageState();
}

class _BookPageState extends ConsumerState<BookPage> {
  late String? _preferredEditionId = widget.editionId;
  bool _busy = false;

  BookPageProvider get _provider =>
      bookPageProvider(widget.workId, _preferredEditionId);

  /// Runs a write, then reloads this page and the library.
  Future<void> _write(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
      ref.invalidate(_provider);
      ref.invalidate(myBooksProvider);
      await ref.read(_provider.future);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).genericError)),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _changeEdition(BookPageData data) async {
    final editionId = await showChangeEditionSheet(
      context,
      work: data.work,
      editions: data.editions,
      currentEditionId: data.edition?.id,
    );
    if (editionId == null || !mounted) return;
    final myBook = data.myBook;
    if (myBook == null) {
      setState(() => _preferredEditionId = editionId);
    } else {
      await _write(
        () => ref
            .read(libraryRepositoryProvider)
            .changeEdition(myBook.userBook.id, editionId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final page = ref.watch(_provider);
    return Scaffold(
      appBar: AppBar(),
      body: page.when(
        skipLoadingOnReload: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.genericError),
              TextButton(
                onPressed: () => ref.invalidate(_provider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (data) => AbsorbPointer(
          absorbing: _busy,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            children: [
              _Header(data: data),
              const SizedBox(height: 16),
              _EditionCard(data: data, onChange: () => _changeEdition(data)),
              const SizedBox(height: 16),
              _ShelfSection(data: data, busy: _busy, write: _write),
              if (data.myBook?.userBook.shelf == Shelf.read) ...[
                const SizedBox(height: 16),
                _ReviewSection(book: data.myBook!, write: _write),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.data});

  final BookPageData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final work = data.work;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CoverImage(url: data.coverUrl, width: 110, title: work.title),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                work.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontFamily: 'Fraunces',
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (work.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(work.subtitle!, style: theme.textTheme.titleSmall),
              ],
              const SizedBox(height: 8),
              if (work.authors.isNotEmpty)
                Text(work.authors.join(', '), style: theme.textTheme.bodyLarge),
              if (work.firstPublishedYear != null)
                Text(
                  '${work.firstPublishedYear}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EditionCard extends StatelessWidget {
  const _EditionCard({required this.data, required this.onChange});

  final BookPageData data;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final edition = data.edition;
    final pages = data.effectivePageCount;
    final details = [
      if (edition != null) l10n.formatName(edition.format.name),
      pages != null ? l10n.bookPageCount(pages) : l10n.bookPageCountUnknown,
      if (edition?.publisher != null) edition!.publisher!,
      if (edition?.isbn13 != null) l10n.bookIsbn(edition!.isbn13!),
    ];
    return Card.outlined(
      child: ListTile(
        title: Text(l10n.bookEdition),
        subtitle: Text(details.join(' · ')),
        trailing: TextButton(
          onPressed: onChange,
          child: Text(l10n.bookChangeEdition),
        ),
      ),
    );
  }
}

class _ShelfSection extends ConsumerWidget {
  const _ShelfSection({
    required this.data,
    required this.busy,
    required this.write,
  });

  final BookPageData data;
  final bool busy;
  final Future<void> Function(Future<void> Function()) write;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final library = ref.read(libraryRepositoryProvider);
    final myBook = data.myBook;
    final current = myBook?.userBook.shelf;
    final pages = data.effectivePageCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          myBook == null ? l10n.bookAddToShelf : l10n.bookOnShelf,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final shelf in Shelf.values)
              ChoiceChip(
                label: Text(l10n.shelfName(shelf.name)),
                selected: current == shelf,
                onSelected: busy
                    ? null
                    : (_) => current == shelf
                          ? null
                          : write(
                              () => myBook == null
                                  ? library.add(
                                      workId: data.work.id,
                                      editionId: data.edition?.id,
                                      shelf: shelf,
                                    )
                                  : library.setShelf(myBook.userBook, shelf),
                            ),
              ),
          ],
        ),
        if (myBook != null &&
            current == Shelf.currentlyReading &&
            pages != null) ...[
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: (myBook.userBook.currentPage / pages).clamp(0, 1),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
            semanticsLabel: l10n.bookProgressLabel,
          ),
          const SizedBox(height: 4),
          Text(l10n.bookProgress(myBook.userBook.currentPage, pages)),
        ],
        if (myBook != null) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: busy
                ? null
                : () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.bookRemoveConfirmTitle),
                        content: Text(l10n.bookRemoveConfirmBody),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(l10n.cancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(l10n.bookRemove),
                          ),
                        ],
                      ),
                    );
                    if (confirmed ?? false) {
                      await write(() => library.remove(myBook.userBook.id));
                    }
                  },
            icon: const Icon(Icons.delete_outline),
            label: Text(l10n.bookRemove),
          ),
        ],
      ],
    );
  }
}

class _ReviewSection extends ConsumerStatefulWidget {
  const _ReviewSection({required this.book, required this.write});

  final ShelvedBook book;
  final Future<void> Function(Future<void> Function()) write;

  @override
  ConsumerState<_ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends ConsumerState<_ReviewSection> {
  late double? _rating = widget.book.userBook.rating;
  late final _take = TextEditingController(
    text: widget.book.userBook.reviewLine,
  );

  @override
  void dispose() {
    _take.dispose();
    super.dispose();
  }

  bool get _dirty =>
      _rating != widget.book.userBook.rating ||
      _take.text.trim() != (widget.book.userBook.reviewLine ?? '');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.bookYourRating,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        HalfStarRating(
          value: _rating,
          semanticLabel: l10n.bookYourRating,
          onChanged: (v) => setState(() => _rating = v),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _take,
          maxLength: 280,
          maxLines: 3,
          minLines: 1,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: l10n.bookOneLineTake,
            border: const OutlineInputBorder(),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.tonal(
            onPressed: _dirty
                ? () => widget.write(
                    () => ref
                        .read(libraryRepositoryProvider)
                        .saveReview(
                          widget.book.userBook.id,
                          rating: _rating,
                          reviewLine: _take.text,
                        ),
                  )
                : null,
            child: Text(l10n.save),
          ),
        ),
      ],
    );
  }
}
