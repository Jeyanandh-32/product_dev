import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/inventory_stock_badge.dart';
import 'package:terminal/components/inventory/inventory_table_cells.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Horizontally scrollable data cells for a product row.
class InventoryProductScrollableRow extends StatelessWidget {
  final Product product;
  final bool isEven;
  final bool isHovered;
  final ValueChanged<bool> onHoverChanged;

  const InventoryProductScrollableRow({
    super.key,
    required this.product,
    required this.isEven,
    required this.isHovered,
    required this.onHoverChanged,
  });

  @override
  Widget build(BuildContext context) {
    final p = product;
    final rowBg = isHovered
        ? TerminalColors.secondaryBackground
        : (isEven ? TerminalColors.surface : TerminalColors.pageBackground);

    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 60,
        decoration: BoxDecoration(
          color: rowBg,
          border: const Border(
            bottom: BorderSide(color: TerminalColors.borderSubtle, width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SizedBox(width: 120, child: Text(p.sku ?? '-', style: _cellStyle)),
            const Gap(16),
            SizedBox(width: 130, child: Text(p.barcode ?? '-', style: _cellStyle)),
            const Gap(16),
            SizedBox(
              width: 110,
              child: Align(
                alignment: Alignment.centerLeft,
                child: InventoryTableCells.statusBadge(p.isActive),
              ),
            ),
            const Gap(16),
            SizedBox(
              width: 100,
              child: Align(
                alignment: Alignment.centerLeft,
                child: InventoryStockBadge(stock: p.stock),
              ),
            ),
            const Gap(16),
            SizedBox(
              width: 120,
              child: Text('${p.stock?.lowStockThreshold ?? 0}', style: _cellStyle),
            ),
            const Gap(16),
            SizedBox(
              width: 140,
              child: Align(
                alignment: Alignment.centerLeft,
                child: InventoryTableCells.monitorBadge(p.stock?.stockMonitor ?? false),
              ),
            ),
            const Gap(16),
            SizedBox(width: 160, child: Text(p.basePrice.toStringAsFixed(2), style: _cellStyle)),
            const Gap(16),
            SizedBox(width: 170, child: Text(p.sellingPrice.toStringAsFixed(2), style: _cellStyle)),
            const Gap(16),
            SizedBox(width: 120, child: Text('${p.taxRate.toStringAsFixed(2)}%', style: _cellStyle)),
            const Gap(16),
            SizedBox(width: 140, child: Text(p.category?.name ?? '-', style: _cellStyle)),
            const Gap(16),
            SizedBox(width: 140, child: Text(p.counter?.name ?? '-', style: _cellStyle)),
          ],
        ),
      ),
    );
  }

  static const _cellStyle = TextStyle(fontSize: 13, color: TerminalColors.textPrimary);
}
