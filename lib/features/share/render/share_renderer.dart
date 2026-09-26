import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../share_format.dart';
import '../share_template.dart';
import '../styles/style_tokens.dart';
import '../template_data.dart';
import '../template_options.dart';

/// One exported slide.
class RenderedSlide {
  const RenderedSlide({
    required this.png,
    required this.width,
    required this.height,
  });

  final Uint8List png;
  final int width;
  final int height;
}

class ImagePrecacheException implements Exception {
  ImagePrecacheException(this.provider, this.error);

  final ImageProvider provider;
  final Object error;

  @override
  String toString() => 'Could not load $provider for export: $error';
}

/// Renders share slides off-screen and captures them as PNGs.
///
/// Slides are laid out at [ShareFormat.logicalSize] inside a detached render
/// tree (never shown on screen) and captured with
/// `toImage(pixelRatio: ShareFormat.exportPixelRatio)`, giving exactly
/// 1080 × 1920 for stories and 1080 × 1350 for posts. Text scaling is pinned
/// to 1.0 so the user's accessibility settings never change an export.
class ShareRenderer {
  const ShareRenderer({this.locale = const Locale('en')});

  final Locale locale;

  /// Renders every slide of [template] for [data].
  Future<List<RenderedSlide>> render({
    required ShareTemplate template,
    required TemplateData data,
    required StyleTokens style,
    required ShareFormat format,
    TemplateOptions options = const TemplateOptions(),
  }) async {
    // Hold every image live until capture is done; never capture with holes.
    final keepAlive = await precacheAll(data.images);
    try {
      final slideFormat = format == ShareFormat.carousel
          ? options.carouselSlideFormat
          : format;
      final count = format == ShareFormat.carousel
          ? template.slideCountFor(data)
          : 1;
      return [
        for (var i = 0; i < count; i++)
          await renderWidget(
            template.buildSlideFor(data, style, format, i, options),
            logicalSize: slideFormat.logicalSize,
            shrinkWrap: format == ShareFormat.sticker,
          ),
      ];
    } finally {
      keepAlive.dispose();
    }
  }

  /// Captures [slide] at [logicalSize] × [ShareFormat.exportPixelRatio].
  ///
  /// With [shrinkWrap], [logicalSize] is only an upper bound and the image is
  /// sized to the content, with a transparent background.
  Future<RenderedSlide> renderWidget(
    Widget slide, {
    required Size logicalSize,
    bool shrinkWrap = false,
  }) async {
    final view =
        WidgetsBinding.instance.platformDispatcher.implicitView ??
        WidgetsBinding.instance.platformDispatcher.views.first;
    final boundary = RenderRepaintBoundary();
    final renderView = RenderView(
      view: view,
      configuration: ViewConfiguration(
        logicalConstraints: BoxConstraints.tight(logicalSize),
        physicalConstraints: BoxConstraints.tight(logicalSize),
      ),
      child: RenderPositionedBox(alignment: Alignment.topLeft, child: boundary),
    );
    final pipelineOwner = PipelineOwner()..rootNode = renderView;
    renderView.prepareInitialFrame();
    final buildOwner = BuildOwner(focusManager: FocusManager());

    final root = RenderObjectToWidgetAdapter<RenderBox>(
      container: boundary,
      child: _wrap(slide, logicalSize, shrinkWrap),
    ).attachToRenderTree(buildOwner);

    try {
      // Localizations and cached images can settle over a few passes.
      for (var pass = 0; pass < 5; pass++) {
        buildOwner.buildScope(root);
        buildOwner.finalizeTree();
        await Future<void>.delayed(Duration.zero);
        if (!_hasDirty(root)) break;
      }
      buildOwner.buildScope(root);
      buildOwner.finalizeTree();
      pipelineOwner
        ..flushLayout()
        ..flushCompositingBits()
        ..flushPaint();

      final image = await boundary.toImage(
        pixelRatio: ShareFormat.exportPixelRatio,
      );
      try {
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        return RenderedSlide(
          png: bytes!.buffer.asUint8List(),
          width: image.width,
          height: image.height,
        );
      } finally {
        image.dispose();
      }
    } finally {
      // Unmount so State objects release image streams and controllers.
      RenderObjectToWidgetAdapter<RenderBox>(container: boundary)
          .attachToRenderTree(buildOwner, root);
      buildOwner
        ..buildScope(root)
        ..finalizeTree();
      renderView.child = null;
      pipelineOwner.rootNode = null;
      pipelineOwner.dispose();
    }
  }

  static bool _hasDirty(Element root) {
    var dirty = false;
    void visit(Element e) {
      if (dirty) return;
      if (e.dirty) {
        dirty = true;
        return;
      }
      e.visitChildren(visit);
    }

    visit(root);
    return dirty;
  }

  Widget _wrap(Widget slide, Size logicalSize, bool shrinkWrap) {
    return MediaQuery(
      data: MediaQueryData(
        size: logicalSize,
        devicePixelRatio: ShareFormat.exportPixelRatio,
        textScaler: TextScaler.noScaling,
      ),
      child: Localizations(
        locale: locale,
        delegates: const [
          AppLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        child: shrinkWrap
            ? ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: logicalSize.width,
                  maxHeight: logicalSize.height,
                ),
                child: slide,
              )
            : SizedBox.fromSize(size: logicalSize, child: slide),
      ),
    );
  }

  /// Resolves every provider and keeps its stream listened to until the
  /// returned handle is disposed. Throws [ImagePrecacheException] if any image
  /// fails to load.
  static Future<ImageKeepAlive> precacheAll(
    Iterable<ImageProvider> providers,
  ) async {
    final keepAlive = ImageKeepAlive._();
    try {
      await Future.wait([
        for (final provider in providers) keepAlive._resolve(provider),
      ]);
    } catch (_) {
      keepAlive.dispose();
      rethrow;
    }
    return keepAlive;
  }
}

/// Keeps resolved images in the live image cache while slides are captured.
class ImageKeepAlive {
  ImageKeepAlive._();

  final _subscriptions = <(ImageStream, ImageStreamListener)>[];

  Future<void> _resolve(ImageProvider provider) {
    final completer = Completer<void>();
    final stream = provider.resolve(
      const ImageConfiguration(devicePixelRatio: ShareFormat.exportPixelRatio),
    );
    final listener = ImageStreamListener(
      (ImageInfo image, bool sync) {
        image.dispose();
        if (!completer.isCompleted) completer.complete();
      },
      onError: (Object error, StackTrace? stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(
            ImagePrecacheException(provider, error),
            stackTrace,
          );
        }
      },
    );
    stream.addListener(listener);
    _subscriptions.add((stream, listener));
    return completer.future;
  }

  void dispose() {
    for (final (stream, listener) in _subscriptions) {
      stream.removeListener(listener);
    }
    _subscriptions.clear();
  }
}
