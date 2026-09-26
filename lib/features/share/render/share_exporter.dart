import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../share_format.dart';
import '../share_template.dart';
import '../styles/style_tokens.dart';
import '../template_data.dart';
import '../template_options.dart';
import 'share_renderer.dart';

class ExportResult {
  const ExportResult({
    required this.files,
    required this.slides,
    required this.elapsed,
  });

  /// One PNG per slide, in slide order.
  final List<File> files;
  final List<RenderedSlide> slides;
  final Duration elapsed;
}

/// Renders a template and writes PNGs to the temp directory, ready for the
/// share targets.
class ShareExporter {
  ShareExporter({
    this.renderer = const ShareRenderer(),
    Future<Directory> Function()? tempDir,
  }) : _tempDir = tempDir ?? getTemporaryDirectory;

  final ShareRenderer renderer;
  final Future<Directory> Function() _tempDir;

  Future<ExportResult> export({
    required ShareTemplate template,
    required TemplateData data,
    required StyleTokens style,
    required ShareFormat format,
    TemplateOptions options = const TemplateOptions(),
  }) async {
    final stopwatch = Stopwatch()..start();
    final slides = await renderer.render(
      template: template,
      data: data,
      style: style,
      format: format,
      options: options,
    );
    // Android's FileProvider exposes `<cache>/share/` to Instagram.
    final dir = Directory('${(await _tempDir()).path}/share');
    await dir.create(recursive: true);
    final stamp = DateTime.now().microsecondsSinceEpoch;
    final files = <File>[];
    for (var i = 0; i < slides.length; i++) {
      final file = File(
        '${dir.path}/${template.id}_${format.name}_${stamp}_$i.png',
      );
      await file.writeAsBytes(slides[i].png, flush: true);
      files.add(file);
    }
    stopwatch.stop();
    return ExportResult(
      files: files,
      slides: slides,
      elapsed: stopwatch.elapsed,
    );
  }
}
