import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/inventory_table_cells.dart';

/// Touch-friendly mobile card for POS inventory category.
class InventoryCategoryCardMobile extends StatelessWidget {
  final Category category;
  final int productCount;
  final VoidCallback onEdit;

  const InventoryCategoryCardMobile({
    super.key,
    required this.category,
    required this.productCount,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
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
              InventoryTableCells.thumbnail(category.imageUrl, size: 44),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const Gap(2),
                    Text(category.description ?? 'No description', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const Gap(8),
              InventoryTableCells.statusBadge(category.isActive),
            ],
          ),
          const Gap(12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFF1F5F9))),
            child: Row(
              children: [
                const Icon(FLucideIcons.package, size: 14, color: Color(0xFF64748B)),
                const Gap(6),
                Text(
                  '$productCount Associated Products',
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                ),
              ],
            ),
          ),
          const Gap(12),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: PressableBox(
              onPress: onEdit,
              style: BoxStyler().height(38).color(const Color(0xFFF1F5F9)).borderRadiusAll(const Radius.circular(10)).alignment(Alignment.center).onHovered(BoxStyler().color(const Color(0xFFE2E8F0))),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FLucideIcons.squarePen, size: 14, color: Color(0xFF0F172A)),
                  Gap(6),
                  Text('Edit Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
