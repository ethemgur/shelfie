import 'package:flutter/widgets.dart';

import '../features/share/share_format.dart';
import '../features/share/share_template.dart';
import '../features/share/styles/style_tokens.dart';
import '../features/share/template_data.dart';
import '../features/share/template_options.dart';
import '../features/share/templates/widgets/slide_parts.dart';
import '../l10n/gen/app_localizations.dart';

/// Phase 0 spike only: a 3-slide carousel that exercises multi-slide export,
/// bundled fonts and a network cover. Not registered in `TemplateRegistry`;
/// the real carousel (`year_carousel`) arrives in Phase 3.
class SpikeCarouselTemplate extends ShareTemplate<SessionTemplateData> {
  const SpikeCarouselTemplate();

  @override
  String get id => 'spike_carousel';

  @override
  TemplateFamily get family => TemplateFamily.session;

  @override
  Set<ShareFormat> get supportedFormats => const {ShareFormat.carousel};

  @override
  int slideCount(SessionTemplateData data) => 3;

  @override
  Widget buildSlide(
    SessionTemplateData data,
    StyleTokens style,
    ShareFormat format,
    int slideIndex,
    TemplateOptions options,
  ) {
    final slideFormat = options.carouselSlideFormat;
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return SlideFrame(
          style: style,
          format: slideFormat,
          child: Column(
            children: [
              Text(
                l10n.shareSlideCounter(slideIndex + 1, 3),
                style: TextStyle(
                  fontFamily: style.bodyFontFamily,
                  fontSize: 12,
                  color: style.mutedText,
                ),
              ),
              Expanded(
                child: Center(
                  child: switch (slideIndex) {
                    0 => ShareCover(
                      image: data.cover,
                      style: style,
                      maxWidth: 180,
                      title: data.title,
                    ),
                    1 => Text(
                      l10n.sharePagesDelta(data.pagesRead),
                      style: TextStyle(
                        fontFamily: style.bodyFontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: 48,
                        color: style.accent,
                      ),
                    ),
                    _ => Text(
                      l10n.spikeCarouselHeadline(slideIndex + 1),
                      style: TextStyle(
                        fontFamily: style.displayFontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: 36,
                        color: style.text,
                      ),
                    ),
                  },
                ),
              ),
              const SizedBox(height: 16),
              BrandFooter(style: style, username: data.username),
            ],
          ),
        );
      },
    );
  }
}
