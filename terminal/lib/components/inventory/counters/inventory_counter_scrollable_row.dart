import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/inventory_table_cells.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Horizontally scrollable data cells for a counter row with equal width column distribution.
class InventoryCounterScrollableRow extends StatelessWidget {
  final Counter counter;
  final int productsCount;
  final bool isEven;
  final bool isHovered;
  final ValueChanged<bool> onHoverChanged;

  const InventoryCounterScrollableRow({
    super.key,
    required this.counter,
    required this.productsCount,
    required this.isEven,
    required this.isHovered,
    required this.onHoverChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = counter;
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
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: InventoryTableCells.statusBadge(c.isActive),
              ),
            ),
            const Gap(16),
            Expanded(
              child: Text(
                '$productsCount',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: TerminalColors.textPrimary,
                ),
              ),
            ),
            const Gap(16),
            Expanded(
              child: Text(
                c.description ?? '-',
                style: const TextStyle(fontSize: 13, color: TerminalColors.textSecondary),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
