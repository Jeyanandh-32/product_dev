import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

/// Ultra-smooth product thumbnail image display with hardware-accelerated decode caching.
class ProductCardImage extends StatelessWidget {
  final String? imageUrl;

  const ProductCardImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final trimmedUrl = imageUrl?.trim();
    final hasValidUrl = trimmedUrl != null && trimmedUrl.isNotEmpty;

    return AspectRatio(
      aspectRatio: 3 / 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ColoredBox(
          color: const Color(0xFFF3F4F6),
          child: hasValidUrl
              ? (kIsWeb
                    ? Image.network(
                        trimmedUrl,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                        errorBuilder: (context, error, stackTrace) =>
                            const _ImagePlaceholder(),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const _ImagePlaceholder();
                        },
                      )
                    : CachedNetworkImage(
                        imageUrl: trimmedUrl,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        placeholder: (context, url) =>
                            const _ImagePlaceholder(),
                        errorWidget: (context, url, error) =>
                            const _ImagePlaceholder(),
                      ))
              : const _ImagePlaceholder(),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(FLucideIcons.image, size: 28, color: Color(0xFF9CA3AF)),
    );
  }
}
