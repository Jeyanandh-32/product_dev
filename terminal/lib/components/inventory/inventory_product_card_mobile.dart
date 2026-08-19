import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/inventory_table_cells.dart';

/// Premium POS inventory product card designed specifically for mobile touch devices.
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
    final image = product.imageUrl;
    final stock = product.stock;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              InventoryTableCells.thumbnail(image),
              const Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)), overflow: TextOverflow.ellipsis),
                    const Gap(2),
                    Text('${product.category?.name ?? 'No Category'} • ${product.counter?.name ?? 'No Counter'}', style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const Gap(6),
              InventoryTableCells.statusBadge(product.isActive),
            ],
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₹${product.sellingPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                    Text('Stock: ${stock?.quantity ?? 0}', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF334155))),
                  ],
                ),
                const Gap(4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('SKU: ${product.sku ?? '-'}', style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: Color(0xFF64748B))),
                    Text('Base ₹${product.basePrice.toStringAsFixed(2)} (${product.taxRate.toStringAsFixed(0)}% Tax)', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
              ],
            ),
          ),
          const Gap(10),
          Row(
            children: [
              Expanded(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: PressableBox(
                    onPress: onEdit,
                    style: BoxStyler().height(34).borderRadiusAll(const Radius.circular(8)).color(const Color(0xFFF1F5F9)).alignment(Alignment.center).onHovered(BoxStyler().color(const Color(0xFFE2E8F0))),
                    child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(FLucideIcons.squarePen, size: 14, color: Color(0xFF334155)), Gap(5), Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF334155)))]),
                  ),
                ),
              ),
              const Gap(8),
              Expanded(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: PressableBox(
                    onPress: onUpdateStock,
                    style: BoxStyler().height(34).borderRadiusAll(const Radius.circular(8)).color(const Color(0xFF000000)).alignment(Alignment.center).onHovered(BoxStyler().color(const Color(0xFF1E293B))),
                    child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(FLucideIcons.boxes, size: 14, color: Color(0xFFFFFFFF)), Gap(5), Text('Adjust Stock', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFFFFFFF)))]),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
