import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/inventory_table_cells.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Pinned left cells for a category row (Action, Image, Category Name).
class InventoryCategoryPinnedRow extends StatelessWidget {
  final Category category;
  final bool isEven;
  final bool isHovered;
  final VoidCallback onEdit;
  final ValueChanged<bool> onHoverChanged;

  const InventoryCategoryPinnedRow({
    super.key,
    required this.category,
    required this.isEven,
    required this.isHovered,
    required this.onEdit,
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
              width: 50,
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: onEdit,
                  icon: const Icon(
                    FLucideIcons.squarePen,
                    size: 16,
                    color: TerminalColors.textSecondary,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  hoverColor: TerminalColors.controlHover,
                  splashRadius: 18,
                ),
              ),
            ),
            const Gap(16),
            SizedBox(
              width: 56,
              child: Align(
                alignment: Alignment.centerLeft,
                child: InventoryTableCells.thumbnail(
                  category.imageUrl,
                  size: 42,
                ),
              ),
            ),
            const Gap(16),
            Expanded(
              child: Text(
                category.name,
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
