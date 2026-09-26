import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/widgets/cover_image.dart';
import '../../data/models/models.dart';
import '../../l10n/gen/app_localizations.dart';
import 'book_candidate.dart';
import 'book_search.dart';
import 'catalogue_repository.dart';

/// Search tab: title / author / ISBN, barcode scan, manual add (Section 6.5).
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';
  String? _opening;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  void _setQuery(String value) {
    _debounce?.cancel();
    _controller.text = value;
    setState(() => _query = value.trim());
  }

  Future<void> _scan() async {
    final isbn = await context.push<String>(Routes.scan);
    if (isbn != null && mounted) _setQuery(isbn);
  }

  Future<void> _open(BookCandidate book) async {
    final key = book.workId ?? book.openLibraryWorkKey ?? book.title;
    setState(() => _opening = key);
    try {
      final ids = await ref.read(catalogueRepositoryProvider).upsert(book);
      if (!mounted) return;
      context.push(Routes.book(ids.workId, editionId: ids.editionId));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).genericError)),
        );
      }
    } finally {
      if (mounted) setState(() => _opening = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onChanged: _onChanged,
          onSubmitted: _setQuery,
          decoration: InputDecoration(
            hintText: l10n.searchHint,
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              tooltip: l10n.searchClear,
              icon: const Icon(Icons.clear),
              onPressed: () => _setQuery(''),
            ),
          IconButton(
            tooltip: l10n.searchScan,
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scan,
          ),
        ],
      ),
      body: _query.length < 2
          ? _Hint(onManualAdd: () => context.push(Routes.manualAdd))
          : _Results(query: _query, opening: _opening, onOpen: _open),
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results({
    required this.query,
    required this.opening,
    required this.onOpen,
  });

  final String query;
  final String? opening;
  final ValueChanged<BookCandidate> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final results = ref.watch(bookSearchResultsProvider(query));
    final manualAdd = ListTile(
      leading: const Icon(Icons.edit_note),
      title: Text(l10n.searchCantFindIt),
      subtitle: Text(l10n.searchAddManually),
      onTap: () => context.push(Routes.manualAdd),
    );
    return results.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l10n.searchError, textAlign: TextAlign.center),
          ),
          Center(
            child: TextButton(
              onPressed: () => ref.invalidate(bookSearchResultsProvider(query)),
              child: Text(l10n.retry),
            ),
          ),
          manualAdd,
        ],
      ),
      data: (books) => ListView.builder(
        itemCount: books.length + 2,
        itemBuilder: (context, i) {
          if (i == 0) {
            return books.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      l10n.searchNoResults,
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox.shrink();
          }
          if (i == books.length + 1) return manualAdd;
          final book = books[i - 1];
          final key = book.workId ?? book.openLibraryWorkKey ?? book.title;
          return ListTile(
            minVerticalPadding: 8,
            leading: CoverImage(
              url: book.coverUrl,
              width: 40,
              title: book.title,
            ),
            title: Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              [
                if (book.authors.isNotEmpty) book.authors.join(', '),
                if (book.firstPublishedYear != null)
                  '${book.firstPublishedYear}',
              ].join(' · '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: opening == key
                ? const SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : book.source == BookSource.googleBooks
                ? Tooltip(
                    message: l10n.searchFromGoogleBooks,
                    child: const Icon(Icons.public, size: 18),
                  )
                : null,
            onTap: opening == null ? () => onOpen(book) : null,
          );
        },
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.onManualAdd});

  final VoidCallback onManualAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book_outlined, size: 48),
            const SizedBox(height: 16),
            Text(l10n.searchEmptyHint, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onManualAdd,
              child: Text(l10n.searchAddManually),
            ),
          ],
        ),
      ),
    );
  }
}
