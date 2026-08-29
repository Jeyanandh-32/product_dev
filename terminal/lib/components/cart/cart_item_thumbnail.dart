import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:mix/mix.dart';

/// Product thumbnail image or placeholder for cart list item rows with caching.
class CartItemThumbnail extends StatelessWidget {
  final String? imageUrl;

  const CartItemThumbnail({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final trimmedUrl = imageUrl?.trim();
    final hasValidUrl = trimmedUrl != null && trimmedUrl.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Box(
        style: BoxStyler().width(56).height(56).color(const Color(0xFFF3F4F6)),
        child: hasValidUrl
            ? CachedNetworkImage(
                imageUrl: trimmedUrl,
                fit: BoxFit.cover,
                memCacheWidth: 120,
                memCacheHeight: 120,
                fadeInDuration: const Duration(milliseconds: 150),
                placeholder: (context, url) => const _PlaceholderIcon(),
                errorWidget: (context, url, error) => const _PlaceholderIcon(),
              )
            : const _PlaceholderIcon(),
      ),
    );
  }
}

class _PlaceholderIcon extends StatelessWidget {
  const _PlaceholderIcon();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(FLucideIcons.store, size: 20, color: Color(0xFF9CA3AF)),
    );
  }
}
