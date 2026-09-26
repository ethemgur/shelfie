import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelfie/dev/spike_carousel_template.dart';
import 'package:shelfie/features/share/render/share_exporter.dart';
import 'package:shelfie/features/share/render/share_renderer.dart';
import 'package:shelfie/features/share/share_format.dart';
import 'package:shelfie/features/share/styles/style_tokens.dart';
import 'package:shelfie/features/share/template_options.dart';
import 'package:shelfie/features/share/templates/session_minimal.dart';

import '../fixtures/share_fixtures.dart';

/// Reads width/height from a PNG's IHDR chunk.
(int, int) pngSize(Uint8List png) {
  final data = ByteData.sublistView(png);
  return (data.getUint32(16), data.getUint32(20));
}

void main() {
  const renderer = ShareRenderer();
  const template = SessionMinimalTemplate();

  testWidgets('story exports at exactly 1080×1920', (tester) async {
    final slides = (await tester.runAsync(() async {
      final cover = MemoryImage(await fakeCoverPng());
      return renderer.render(
        template: template,
        data: sessionFixture(cover: cover),
        style: StyleTokens.minimal,
        format: ShareFormat.story,
      );
    }))!;
    expect(slides, hasLength(1));
    expect((slides.single.width, slides.single.height), (1080, 1920));
    expect(pngSize(slides.single.png), (1080, 1920));
  });

  testWidgets('post exports at exactly 1080×1350', (tester) async {
    final slides = (await tester.runAsync(
      () => renderer.render(
        template: template,
        data: sessionFixture(),
        style: StyleTokens.minimal,
        format: ShareFormat.post,
      ),
    ))!;
    expect(pngSize(slides.single.png), (1080, 1350));
  });

  testWidgets('carousel exports one story-sized PNG per slide', (tester) async {
    final slides = (await tester.runAsync(
      () => renderer.render(
        template: const SpikeCarouselTemplate(),
        data: sessionFixture(),
        style: StyleTokens.minimal,
        format: ShareFormat.carousel,
      ),
    ))!;
    expect(slides.map((s) => pngSize(s.png)), [
      (1080, 1920),
      (1080, 1920),
      (1080, 1920),
    ]);
  });

  testWidgets('carousel can use post-sized slides', (tester) async {
    final slides = (await tester.runAsync(
      () => renderer.render(
        template: const SpikeCarouselTemplate(),
        data: sessionFixture(),
        style: StyleTokens.minimal,
        format: ShareFormat.carousel,
        options: const TemplateOptions(carouselSlideFormat: ShareFormat.post),
      ),
    ))!;
    expect(slides.map((s) => pngSize(s.png)).toSet(), {(1080, 1350)});
  });

  testWidgets('never captures with a missing image', (tester) async {
    final error = await tester.runAsync(() async {
      try {
        await renderer.render(
          template: template,
          data: sessionFixture(
            cover: MemoryImage(Uint8List.fromList([1, 2, 3])),
          ),
          style: StyleTokens.minimal,
          format: ShareFormat.story,
        );
        return null;
      } catch (e) {
        return e;
      }
    });
    expect(error, isA<ImagePrecacheException>());
  });

  testWidgets('exporter writes one PNG file per slide', (tester) async {
    final tmp = Directory.systemTemp.createTempSync('share_export');
    addTearDown(() => tmp.deleteSync(recursive: true));
    final result = (await tester.runAsync(
      () => ShareExporter(tempDir: () async => tmp).export(
        template: const SpikeCarouselTemplate(),
        data: sessionFixture(),
        style: StyleTokens.minimal,
        format: ShareFormat.carousel,
      ),
    ))!;
    expect(result.files, hasLength(3));
    for (final file in result.files) {
      expect(file.path, startsWith('${tmp.path}/share/'));
      expect(pngSize(file.readAsBytesSync()), (1080, 1920));
    }
  });
}
