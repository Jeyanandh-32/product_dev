import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/inventory_product_metrics.dart';
import 'package:terminal/components/inventory/inventory_table_cells.dart';

/// Ultra-readable POS inventory product card designed for mobile touch devices without gray shade box.
class InventoryProductCardMobile extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onUpdateStock;

  const InventoryProductCardMobile({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onUpdateStock,
  });

  @override
  Widget build(BuildContext context) {
    final cat = product.category?.name ?? 'Uncategorized';
    final cnt = product.counter?.name ?? 'No Counter';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              InventoryTableCells.thumbnail(product.imageUrl, size: 44),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(3),
                    Text(
                      '$cat • $cnt',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Gap(8),
              InventoryTableCells.statusBadge(product.isActive),
            ],
          ),
          const Gap(12),
          InventoryProductMetrics(product: product),
          const Gap(14),
          Row(
            children: [
              Expanded(
                child: _actionBtn(
                  onEdit,
                  FLucideIcons.squarePen,
                  'Edit',
                  const Color(0xFFF1F5F9),
                  const Color(0xFF334155),
                ),
              ),
              const Gap(10),
              Expanded(
                child: _actionBtn(
                  onUpdateStock,
                  FLucideIcons.boxes,
                  'Adjust Stock',
                  const Color(0xFF0F172A),
                  const Color(0xFFFFFFFF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(
    VoidCallback onTap,
    IconData icon,
    String label,
    Color bg,
    Color text,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PressableBox(
        onPress: onTap,
        style: BoxStyler()
            .height(38)
            .borderRadiusAll(const Radius.circular(10))
            .color(bg)
            .alignment(Alignment.center),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: text),
            const Gap(5),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
