import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../features/share/render/share_exporter.dart';
import '../features/share/render/share_renderer.dart';
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
  bool _coverBlocked = false;

  Future<void> _render(ShareTemplate template, ShareFormat format) async {
    setState(() {
      _busy = true;
      _error = null;
      _coverBlocked = false;
    });
    Future<ExportResult> export(SessionTemplateData data) => _exporter.export(
      template: template,
      data: data,
      style: StyleTokens.minimal,
      format: format,
    );
    try {
      ExportResult result;
      try {
        result = await export(_sample);
      } on ImagePrecacheException {
        // On web, a cover host without CORS headers can be shown in an <img>
        // but not painted into an exported PNG.
        if (!kIsWeb) rethrow;
        result = await export(_sample.withoutCover());
        _coverBlocked = true;
      }
      setState(() => _result = result);
    } catch (e) {
      setState(() => _error = e);
    } finally {
      setState(() => _busy = false);
    }
  }

  /// Share sheet with every slide. On web this uses the Web Share API where
  /// the browser supports it.
  Future<void> _shareAll(ExportResult result) async {
    final files = [
      for (final (i, slide) in result.slides.indexed)
        kIsWeb
            ? XFile.fromData(
                slide.png,
                name: 'shelfie_$i.png',
                mimeType: 'image/png',
              )
            : XFile(result.files[i].path, mimeType: 'image/png'),
    ];
    try {
      await SharePlus.instance.share(ShareParams(files: files));
    } catch (_) {
      if (kIsWeb) await _download(result);
    }
  }

  /// Web only: saves each slide as a PNG download.
  Future<void> _download(ExportResult result) async {
    for (final (i, slide) in result.slides.indexed) {
      await XFile.fromData(
        slide.png,
        name: 'shelfie_$i.png',
        mimeType: 'image/png',
      ).saveTo('shelfie_$i.png');
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
            if (_coverBlocked) Text(l10n.spikeCoverBlocked),
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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Instagram Stories needs the native channel (Android/iOS).
                if (!kIsWeb)
                  OutlinedButton(
                    onPressed: () => _instagram.share(
                      background: result.files.first,
                      topColor: StyleTokens.minimal.background,
                      bottomColor: StyleTokens.minimal.background,
                    ),
                    child: Text(l10n.spikeShareInstagram),
                  ),
                OutlinedButton(
                  onPressed: () => _shareAll(result),
                  child: Text(l10n.spikeShareSystem),
                ),
                if (kIsWeb)
                  OutlinedButton(
                    onPressed: () => _download(result),
                    child: Text(l10n.spikeDownload),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
