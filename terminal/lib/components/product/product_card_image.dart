import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:mix/mix.dart';

/// Product thumbnail image display for the POS catalog card with non-distorting scaling.
class ProductCardImage extends StatelessWidget {
  final String? imageUrl;

  const ProductCardImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final validUrl = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return AspectRatio(
      aspectRatio: 3 / 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Box(
          style: BoxStyler().color(const Color(0xFFF3F4F6)),
          child: validUrl
              ? SizedBox.expand(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!.trim(),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    memCacheWidth: 480,
                    fadeInDuration: const Duration(milliseconds: 150),
                    placeholder: (context, url) => const _ImagePlaceholder(),
                    errorWidget: (context, url, error) =>
                        const _ImagePlaceholder(),
                  ),
                )
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
      child: Icon(
        FLucideIcons.image,
        size: 28,
        color: Color(0xFF9CA3AF),
      ),
    );
  }
}
