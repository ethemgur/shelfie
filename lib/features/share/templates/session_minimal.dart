import 'package:flutter/widgets.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../share_format.dart';
import '../share_template.dart';
import '../styles/style_tokens.dart';
import '../template_data.dart';
import '../template_options.dart';
import 'widgets/fit_text.dart';
import 'widgets/slide_parts.dart';

/// F1 `session_minimal`: cover, title, "+42 pages", "p.120 → 162", progress.
class SessionMinimalTemplate extends ShareTemplate<SessionTemplateData> {
  const SessionMinimalTemplate();

  @override
  String get id => 'session_minimal';

  @override
  TemplateFamily get family => TemplateFamily.session;

  @override
  Set<ShareFormat> get supportedFormats => const {
    ShareFormat.story,
    ShareFormat.post,
  };

  @override
  Widget buildSlide(
    SessionTemplateData data,
    StyleTokens style,
    ShareFormat format,
    int slideIndex,
    TemplateOptions options,
  ) {
    return _SessionMinimal(
      data: data,
      style: style,
      format: format,
      options: options,
    );
  }
}

class _SessionMinimal extends StatelessWidget {
  const _SessionMinimal({
    required this.data,
    required this.style,
    required this.format,
    required this.options,
  });

  final SessionTemplateData data;
  final StyleTokens style;
  final ShareFormat format;
  final TemplateOptions options;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isStory = format == ShareFormat.story;
    final quote = options.showQuote ? data.quote : null;
    final body = TextStyle(
      fontFamily: style.bodyFontFamily,
      color: style.text,
      fontSize: 14,
      height: 1.3,
    );

    return SlideFrame(
      style: style,
      format: format,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: ShareCover(
                    image: data.cover,
                    style: style,
                    maxWidth: isStory ? 128 : 88,
                    title: data.title,
                  ),
                ),
                SizedBox(height: isStory ? 24 : 16),
                FitText(
                  data.title,
                  textAlign: TextAlign.center,
                  minFontSize: 16,
                  style: TextStyle(
                    fontFamily: style.displayFontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: isStory ? 28 : 22,
                    height: 1.15,
                    color: style.text,
                  ),
                ),
                if (data.authors.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    data.authors.join(', '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: body.copyWith(color: style.mutedText),
                  ),
                ],
                SizedBox(height: isStory ? 28 : 16),
                Text(
                  l10n.sharePagesDelta(data.pagesRead),
                  style: TextStyle(
                    fontFamily: style.bodyFontFamily,
                    fontWeight: FontWeight.w800,
                    fontSize: isStory ? 44 : 34,
                    height: 1,
                    color: style.accent,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.sharePageRange(data.fromPage, data.toPage),
                  style: body.copyWith(
                    color: style.mutedText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: isStory ? 20 : 14),
                Row(
                  children: [
                    Expanded(
                      child: ShareProgressBar(
                        percent: data.progressPct,
                        style: style,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l10n.shareProgressPercent(
                        formatPercent(data.progressPct),
                      ),
                      style: body.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                if (quote != null && quote.isNotEmpty) ...[
                  SizedBox(height: isStory ? 24 : 14),
                  Text(
                    '“$quote”',
                    maxLines: isStory ? 4 : 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: style.displayFontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      height: 1.35,
                      color: style.text,
                    ),
                  ),
                ],
                if (options.showStreak && data.weeklyStreak > 0) ...[
                  SizedBox(height: isStory ? 18 : 10),
                  Text(
                    l10n.shareWeeklyStreak(data.weeklyStreak),
                    style: body.copyWith(color: style.mutedText, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          BrandFooter(style: style, username: data.username),
        ],
      ),
    );
  }
}
