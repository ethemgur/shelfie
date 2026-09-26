import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A book cover at 2:3, with a titled placeholder when there's no image.
///
/// On web, cover hosts don't all send CORS headers, so images fall back to a
/// plain HTML `<img>` element when the byte fetch is blocked.
class CoverImage extends StatelessWidget {
  const CoverImage({
    super.key,
    required this.url,
    required this.width,
    this.title,
  });

  final String? url;
  final double width;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Too small for a legible title: show a book icon instead.
    final placeholder = ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: width < 72
          ? Icon(
              Icons.menu_book_outlined,
              size: width * 0.5,
              color: scheme.onSurfaceVariant,
            )
          : Padding(
              padding: const EdgeInsets.all(6),
              child: Center(
                child: Text(
                  title ?? '',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (width / 7).clamp(10, 16),
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
    );
    final image = url == null
        ? placeholder
        : kIsWeb
        ? Image.network(
            url!,
            fit: BoxFit.cover,
            webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
            errorBuilder: (_, _, _) => placeholder,
          )
        : CachedNetworkImage(
            imageUrl: url!,
            fit: BoxFit.cover,
            placeholder: (_, _) => placeholder,
            errorWidget: (_, _, _) => placeholder,
          );
    return Semantics(
      container: true,
      image: true,
      label: title,
      excludeSemantics: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(width: width, height: width * 1.5, child: image),
      ),
    );
  }
}
