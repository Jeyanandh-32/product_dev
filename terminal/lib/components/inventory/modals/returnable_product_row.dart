import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/components/inventory/modals/compact_switch.dart';

/// Single product card in the Returnable Products modal styled to match CartItemRow.
class ReturnableProductRow extends StatelessWidget {
  const ReturnableProductRow({
    required this.product,
    required this.onToggle,
    super.key,
  });

  final Map<String, dynamic> product;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final name = product['name'] as String? ?? 'Unnamed Product';
    final categoryName = product['categoryName'] as String? ?? 'General';
    final price = (product['sellingPrice'] as num?)?.toDouble() ?? 0.0;
    final isReturnable = product['isReturnable'] as bool? ?? false;
    final imageUrl = product['imageUrl'] as String?;

    return Box(
      style: BoxStyler()
          .paddingAll(12)
          .borderRadiusAll(const Radius.circular(16))
          .color(const Color(0xFFFFFFFF))
          .borderAll(color: const Color(0xFFE5E7EB))
          .shadowOnly(
            color: const Color(0x08000000),
            offset: const Offset(0, 2),
            blurRadius: 3,
          )
          .onHovered(
            BoxStyler()
                .borderAll(color: const Color(0xFF000000))
                .shadowOnly(
                  color: const Color(0x10000000),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
          ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildThumbnail(imageUrl),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF000000),
                  ),
                ),
                const Gap(3),
                Text(
                  '₹${price.toStringAsFixed(2)} • $categoryName',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const Gap(10),
          CompactSwitch(
            value: isReturnable,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(String? url) {
    final validUrl = url != null && url.trim().isNotEmpty;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 46,
        height: 46,
        color: const Color(0xFFF3F4F6),
        child: validUrl
            ? CachedNetworkImage(
                imageUrl: url.trim(),
                fit: BoxFit.cover,
                memCacheWidth: 100,
                memCacheHeight: 100,
                errorWidget: (_, _, _) => const Icon(
                  FLucideIcons.wine,
                  size: 20,
                  color: Color(0xFF9CA3AF),
                ),
                placeholder: (_, _) => const Center(
                  child: Icon(
                    FLucideIcons.wine,
                    size: 20,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              )
            : const Icon(
                FLucideIcons.wine,
                size: 20,
                color: Color(0xFF16A34A),
              ),
      ),
    );
  }
}
