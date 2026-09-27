import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../app/routes.dart';
import '../../data/models/models.dart';
import '../../data/remote/remote_providers.dart';
import '../../l10n/gen/app_localizations.dart';
import 'book_candidate.dart';
import 'catalogue_repository.dart';

/// "Can't find it?" — title, author, page count, format, optional cover
/// photo. Creates a `source = 'user'` edition through `upsert_book`.
class ManualAddScreen extends ConsumerStatefulWidget {
  const ManualAddScreen({super.key});

  @override
  ConsumerState<ManualAddScreen> createState() => _ManualAddScreenState();
}

class _ManualAddScreenState extends ConsumerState<ManualAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _author = TextEditingController();
  final _pages = TextEditingController();
  BookFormat _format = BookFormat.print;
  Uint8List? _cover;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _pages.dispose();
    super.dispose();
  }

  Future<void> _pickCover() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 80,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (mounted) setState(() => _cover = bytes);
  }

  /// Uploads the cover photo to `covers/<uid>/` and returns its Storage
  /// path; `upsertBook` checks it and turns it into a URL.
  Future<String?> _uploadCover() async {
    if (_cover == null) return null;
    final uid = ref.read(firebaseAuthProvider).currentUser!.uid;
    final path = 'covers/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await ref
        .read(storageProvider)
        .ref(path)
        .putData(_cover!, SettableMetadata(contentType: 'image/jpeg'));
    return path;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final coverPath = await _uploadCover();
      final ids = await ref
          .read(catalogueRepositoryProvider)
          .upsert(
            BookCandidate(
              title: _title.text.trim(),
              authors: [_author.text.trim()],
              pageCount: int.parse(_pages.text.trim()),
              format: _format,
              source: BookSource.user,
            ),
            coverPath: coverPath,
          );
      if (mounted) {
        // Replace the form in browser history too, so Back skips it on web.
        Router.neglect(
          context,
          () => context.pushReplacement(
            Routes.book(ids.workId, editionId: ids.editionId),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).genericError)),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String? required(String? v) =>
        (v ?? '').trim().isEmpty ? l10n.fieldRequired : null;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.manualAddTitle)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.manualAddBookTitle,
                border: const OutlineInputBorder(),
              ),
              validator: required,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _author,
              maxLength: 200,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.manualAddAuthor,
                border: const OutlineInputBorder(),
              ),
              validator: required,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _pages,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.manualAddPageCount,
                border: const OutlineInputBorder(),
              ),
              validator: (v) {
                final n = int.tryParse((v ?? '').trim());
                return n == null || n < 1 || n > 20000
                    ? l10n.manualAddPageCountInvalid
                    : null;
              },
            ),
            const SizedBox(height: 16),
            Text(
              l10n.bookFormat,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SegmentedButton<BookFormat>(
              segments: [
                for (final f in BookFormat.values)
                  ButtonSegment(value: f, label: Text(l10n.formatName(f.name))),
              ],
              selected: {_format},
              onSelectionChanged: (s) => setState(() => _format = s.first),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: _cover == null
                  ? const Icon(Icons.add_photo_alternate_outlined)
                  : Image.memory(_cover!, width: 40, fit: BoxFit.cover),
              title: Text(
                _cover == null
                    ? l10n.manualAddCoverPhoto
                    : l10n.manualAddChangeCover,
              ),
              subtitle: Text(l10n.optional),
              onTap: _pickCover,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
