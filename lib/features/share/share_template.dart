import 'package:flutter/widgets.dart';

import 'share_format.dart';
import 'styles/style_tokens.dart';
import 'template_data.dart';
import 'template_options.dart';

/// One share template. Adding a template = adding one file under
/// `templates/` and registering it in [TemplateRegistry].
abstract class ShareTemplate<T extends TemplateData> {
  const ShareTemplate();

  /// Stable id, e.g. `session_minimal`. Logged in `share_events.template_id`.
  String get id;

  TemplateFamily get family;

  Set<ShareFormat> get supportedFormats;

  /// More than 1 for carousel templates.
  int slideCount(T data) => 1;

  Widget buildSlide(
    T data,
    StyleTokens style,
    ShareFormat format,
    int slideIndex,
    TemplateOptions options,
  );

  /// Type-erased entry point for the renderer and composer.
  Widget buildSlideFor(
    TemplateData data,
    StyleTokens style,
    ShareFormat format,
    int slideIndex,
    TemplateOptions options,
  ) {
    assert(supportedFormats.contains(format), '$id does not support $format');
    return buildSlide(data as T, style, format, slideIndex, options);
  }

  int slideCountFor(TemplateData data) => slideCount(data as T);
}
