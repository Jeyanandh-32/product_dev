import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/inventory_table_cells.dart';

/// Ultra-readable POS inventory product card designed for mobile touch devices.
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
    final category = product.category?.name ?? 'Uncategorized';
    final counter = product.counter?.name ?? 'No Counter';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 6, offset: Offset(0, 2))],
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
                    Text(product.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const Gap(3),
                    Text('$category • $counter', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF64748B)), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const Gap(8),
              InventoryTableCells.statusBadge(product.isActive),
            ],
          ),
          const Gap(14),
          _buildMetrics(product.stock),
          const Gap(14),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildMetrics(Stock? stock) {
    final qty = stock?.quantity ?? 0;
    final lowStock = stock?.lowStockThreshold ?? 0;
    final isMonitor = stock?.stockMonitor ?? false;
    final isLow = isMonitor && qty <= lowStock;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PRICE', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: Color(0xFF64748B))),
                  const Gap(2),
                  Text('₹${product.sellingPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('STOCK', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: Color(0xFF64748B))),
                  const Gap(2),
                  Text('$qty units', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: isLow ? const Color(0xFFDC2626) : const Color(0xFF0F172A))),
                ],
              ),
            ],
          ),
          const Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text.rich(
                  TextSpan(text: 'Base: ', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF64748B)), children: [TextSpan(text: '₹${product.basePrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF334155))), TextSpan(text: ' (${product.taxRate.toStringAsFixed(0)}% Tax)', style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF64748B)))]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (product.sku?.isNotEmpty ?? false) ...[
                const Gap(8),
                Text.rich(TextSpan(text: 'SKU: ', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF64748B)), children: [TextSpan(text: product.sku!, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700, color: Color(0xFF334155)))])),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(child: _actionBtn(onEdit, FLucideIcons.squarePen, 'Edit', const Color(0xFFF1F5F9), const Color(0xFF334155))),
        const Gap(10),
        Expanded(child: _actionBtn(onUpdateStock, FLucideIcons.boxes, 'Adjust Stock', const Color(0xFF0F172A), const Color(0xFFFFFFFF))),
      ],
    );
  }

  Widget _actionBtn(VoidCallback onTap, IconData icon, String label, Color bg, Color text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PressableBox(
        onPress: onTap,
        style: BoxStyler().height(38).borderRadiusAll(const Radius.circular(10)).color(bg).alignment(Alignment.center),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 15, color: text), const Gap(6), Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: text))]),
      ),
    );
  }
}
