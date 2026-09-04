import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/inventory_table_cells.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Pinned left cells for a counter row (Image, Counter Name).
class InventoryCounterPinnedRow extends StatelessWidget {
  final Counter counter;
  final bool isEven;
  final bool isHovered;
  final ValueChanged<bool> onHoverChanged;

  const InventoryCounterPinnedRow({
    super.key,
    required this.counter,
    required this.isEven,
    required this.isHovered,
    required this.onHoverChanged,
  });

  @override
  Widget build(BuildContext context) {
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
            right: BorderSide(color: TerminalColors.border, width: 1.5),
          ),
          boxShadow: const [
            BoxShadow(
              color: TerminalColors.shadow,
              offset: Offset(2, 0),
              blurRadius: 3,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              child: Align(
                alignment: Alignment.centerLeft,
                child: InventoryTableCells.thumbnail(
                  counter.imageUrl,
                  size: 42,
                ),
              ),
            ),
            const Gap(16),
            Expanded(
              child: Text(
                counter.name,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: TerminalColors.textPrimary,
                ),
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
