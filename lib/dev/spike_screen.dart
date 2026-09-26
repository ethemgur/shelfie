import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../features/share/render/share_exporter.dart';
import '../features/share/share_format.dart';
import '../features/share/share_template.dart';
import '../features/share/styles/style_tokens.dart';
import '../features/share/targets/instagram_stories.dart';
import '../features/share/template_data.dart';
import '../features/share/templates/session_minimal.dart';
import '../l10n/gen/app_localizations.dart';
import 'spike_carousel_template.dart';

/// Phase 0 rendering spike (dev flavour only). Renders `session_minimal` at
/// 1080×1920 and a 3-slide carousel with a network cover, reports size and
/// render time, and shares to Instagram Stories / the system sheet.
class SpikeScreen extends StatefulWidget {
  const SpikeScreen({super.key});

  @override
  State<SpikeScreen> createState() => _SpikeScreenState();
}

class _SpikeScreenState extends State<SpikeScreen> {
  static final _sample = SessionTemplateData(
    title: 'Pride and Prejudice',
    authors: ['Jane Austen'],
    fromPage: 120,
    toPage: 162,
    pageCount: 384,
    username: 'ethem',
    quote: 'I declare after all there is no enjoyment like reading!',
    weeklyStreak: 4,
    cover: CachedNetworkImageProvider(
      'https://covers.openlibrary.org/b/isbn/9780141439518-L.jpg',
    ),
  );

  final _exporter = ShareExporter();
  final _instagram = InstagramStoriesShare();
  ExportResult? _result;
  Object? _error;
  bool _busy = false;

  Future<void> _render(ShareTemplate template, ShareFormat format) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await _exporter.export(
        template: template,
        data: _sample,
        style: StyleTokens.minimal,
        format: format,
      );
      setState(() => _result = result);
    } catch (e) {
      setState(() => _error = e);
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final result = _result;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.spikeTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton(
            onPressed: _busy
                ? null
                : () => _render(
                    const SessionMinimalTemplate(),
                    ShareFormat.story,
                  ),
            child: Text(l10n.spikeRenderStory),
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: _busy
                ? null
                : () => _render(
                    const SpikeCarouselTemplate(),
                    ShareFormat.carousel,
                  ),
            child: Text(l10n.spikeRenderCarousel),
          ),
          const SizedBox(height: 16),
          if (_busy) Text(l10n.spikeRendering),
          if (_error != null) Text(l10n.spikeError('$_error')),
          if (result != null) ...[
            Text(
              l10n.spikeResult(
                result.slides.length,
                result.slides.first.width,
                result.slides.first.height,
                result.elapsed.inMilliseconds,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 320,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: result.slides.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) => Image.memory(result.slides[i].png),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _instagram.share(
                      background: result.files.first,
                      topColor: StyleTokens.minimal.background,
                      bottomColor: StyleTokens.minimal.background,
                    ),
                    child: Text(l10n.spikeShareInstagram),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _shareAll(result.files),
                    child: Text(l10n.spikeShareSystem),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _shareAll(List<File> files) => SharePlus.instance.share(
    ShareParams(
      files: [for (final f in files) XFile(f.path, mimeType: 'image/png')],
    ),
  );
}
