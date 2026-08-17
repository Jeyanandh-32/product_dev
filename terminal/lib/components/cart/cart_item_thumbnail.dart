import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:mix/mix.dart';

/// Product thumbnail image or placeholder for cart list item rows.
class CartItemThumbnail extends StatelessWidget {
  final String? imageUrl;

  const CartItemThumbnail({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final validUrl = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Box(
        style: BoxStyler()
            .width(56)
            .height(56)
            .color(const Color(0xFFF3F4F6)),
        child: validUrl
            ? Image.network(
                imageUrl!.trim(),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const _PlaceholderIcon(),
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
      child: Icon(
        FLucideIcons.store,
        size: 20,
        color: Color(0xFF9CA3AF),
      ),
    );
  }
}
