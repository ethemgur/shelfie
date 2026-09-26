import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/widgets/cover_image.dart';
import '../../data/models/models.dart';
import '../../data/remote/remote_providers.dart';
import '../../l10n/gen/app_localizations.dart';
import 'book_candidate.dart';
import 'catalogue_repository.dart';

/// Lists editions of a work (ours first, then Open Library's) and returns the
/// chosen edition's id, adding it to the catalogue if needed.
Future<String?> showChangeEditionSheet(
  BuildContext context, {
  required Work work,
  required List<Edition> editions,
  required String? currentEditionId,
}) => showModalBottomSheet<String>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (context) => DraggableScrollableSheet(
    expand: false,
    initialChildSize: 0.7,
    maxChildSize: 0.95,
    builder: (context, scroll) => _ChangeEditionSheet(
      work: work,
      editions: editions,
      currentEditionId: currentEditionId,
      scroll: scroll,
    ),
  ),
);

class _ChangeEditionSheet extends ConsumerStatefulWidget {
  const _ChangeEditionSheet({
    required this.work,
    required this.editions,
    required this.currentEditionId,
    required this.scroll,
  });

  final Work work;
  final List<Edition> editions;
  final String? currentEditionId;
  final ScrollController scroll;

  @override
  ConsumerState<_ChangeEditionSheet> createState() =>
      _ChangeEditionSheetState();
}

class _ChangeEditionSheetState extends ConsumerState<_ChangeEditionSheet> {
  late final Future<List<BookCandidate>> _external = _loadExternal();
  bool _saving = false;

  Future<List<BookCandidate>> _loadExternal() async {
    final work = widget.work;
    if (work.openLibraryWorkKey == null) return const [];
    final known = {for (final e in widget.editions) ?e.isbn13};
    final all = await ref
        .read(openLibraryApiProvider)
        .editions(
          BookCandidate(
            title: work.title,
            authors: work.authors,
            coverUrl: work.coverUrl,
            openLibraryWorkKey: work.openLibraryWorkKey,
            source: BookSource.openLibrary,
          ),
        );
    return all
        .where((c) => c.isbn13 != null && !known.contains(c.isbn13))
        .toList();
  }

  Future<void> _pickExternal(BookCandidate candidate) async {
    setState(() => _saving = true);
    try {
      final ids = await ref.read(catalogueRepositoryProvider).upsert(candidate);
      if (mounted) Navigator.pop(context, ids.editionId);
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).genericError)),
        );
      }
    }
  }

  String _describe(
    AppLocalizations l10n, {
    required BookFormat format,
    int? pages,
    String? publisher,
    String? date,
    String? isbn,
  }) => [
    l10n.formatName(format.name),
    pages != null ? l10n.bookPageCount(pages) : l10n.bookPageCountUnknown,
    ?publisher,
    ?date,
    if (isbn != null) l10n.bookIsbn(isbn),
  ].join(' · ');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AbsorbPointer(
      absorbing: _saving,
      child: FutureBuilder(
        future: _external,
        builder: (context, snapshot) => ListView(
          controller: widget.scroll,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                l10n.bookChangeEdition,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (_saving) const LinearProgressIndicator(),
            for (final e in widget.editions)
              ListTile(
                leading: CoverImage(
                  url: e.coverUrl ?? widget.work.coverUrl,
                  width: 36,
                ),
                title: Text(
                  _describe(
                    l10n,
                    format: e.format,
                    pages: e.pageCount,
                    publisher: e.publisher,
                    date: e.publishedDate,
                    isbn: e.isbn13,
                  ),
                ),
                trailing: e.id == widget.currentEditionId
                    ? const Icon(Icons.check)
                    : null,
                onTap: () => Navigator.pop(context, e.id),
              ),
            if (snapshot.connectionState == ConnectionState.waiting)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (snapshot.hasError)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.editionsLoadError),
              ),
            for (final c in snapshot.data ?? const <BookCandidate>[])
              ListTile(
                leading: CoverImage(url: c.coverUrl, width: 36),
                title: Text(
                  _describe(
                    l10n,
                    format: c.format,
                    pages: c.pageCount,
                    publisher: c.publisher,
                    date: c.publishedDate,
                    isbn: c.isbn13,
                  ),
                ),
                onTap: () => _pickExternal(c),
              ),
          ],
        ),
      ),
    );
  }
}
