import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelfie/features/share/render/share_renderer.dart';
import 'package:shelfie/features/share/styles/style_tokens.dart';
import 'package:shelfie/features/share/template_data.dart';
import 'package:shelfie/features/share/templates/session_minimal.dart';

import '../fixtures/share_fixtures.dart';

/// Goldens are the exported PNGs themselves (1080 px wide), rendered through
/// the same off-screen pipeline the app uses.
///
/// Phase 0 covers `session_minimal` in the `minimal` style. The full
/// template × format × style × fixture matrix (Section 9.7) lands in Phase 3.
void main() {
  const template = SessionMinimalTemplate();

  final fixtures = <String, SessionTemplateData Function(ImageProvider cover)>{
    'default': (cover) => sessionFixture(cover: cover),
    'long_title_no_cover': (_) => sessionFixture(
      title:
          'The Remarkable and Entirely Improbable Adventures of a Very Long '
          'Title That Goes On and On',
      authors: const [
        'Firstname Middlename Lastname-Doublebarrel',
        'Co Author',
      ],
    ),
    'correction_zero_pages': (cover) =>
        sessionFixture(cover: cover, fromPage: 162, toPage: 150),
    'finished_long_quote': (cover) => sessionFixture(
      cover: cover,
      fromPage: 350,
      toPage: 384,
      quote:
          'It is a truth universally acknowledged, that a single man in '
          'possession of a good fortune, must be in want of a wife. However '
          'little known the feelings or views of such a man may be on his '
          'first entering a neighbourhood, this truth is so well fixed.',
    ),
    'turkish_title': (cover) => sessionFixture(
      cover: cover,
      title: 'Kürk Mantolu Madonna',
      authors: const ['Sabahattin Ali'],
      quote: 'Hayatta en büyük şey, sevmek ve sevilmekti.',
    ),
  };

  for (final format in template.supportedFormats) {
    for (final MapEntry(key: name, value: build) in fixtures.entries) {
      testWidgets('session_minimal ${format.name} $name', (tester) async {
        final image = (await tester.runAsync(() async {
          final cover = MemoryImage(await fakeCoverPng());
          final slide = (await const ShareRenderer().render(
            template: template,
            data: build(cover),
            style: StyleTokens.minimal,
            format: format,
          )).single;
          final codec = await ui.instantiateImageCodec(slide.png);
          return (await codec.getNextFrame()).image;
        }))!;
        await expectLater(
          image,
          matchesGoldenFile(
            'goldens/session_minimal/minimal_${format.name}_$name.png',
          ),
        );
        image.dispose();
      });
    }
  }
}
