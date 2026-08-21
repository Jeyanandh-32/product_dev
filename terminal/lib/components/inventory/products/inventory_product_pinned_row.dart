import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/inventory_table_cells.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Pinned left cells for a product row (Action, Image, Product Name).
class InventoryProductPinnedRow extends StatelessWidget {
  final Product product;
  final bool isEven;
  final bool isHovered;
  final VoidCallback onEdit;
  final VoidCallback onUpdateStock;
  final ValueChanged<bool> onHoverChanged;

  const InventoryProductPinnedRow({
    super.key,
    required this.product,
    required this.isEven,
    required this.isHovered,
    required this.onEdit,
    required this.onUpdateStock,
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
              width: 80,
              child: Align(
                alignment: Alignment.centerLeft,
                child: InventoryTableCells.actionButtons(
                  onEdit: onEdit,
                  onUpdateStock: onUpdateStock,
                ),
              ),
            ),
            const Gap(16),
            SizedBox(
              width: 56,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildThumbnail(product.imageUrl),
              ),
            ),
            const Gap(16),
            Expanded(
              child: Text(
                product.name,
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

  Widget _buildThumbnail(String? url) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: TerminalColors.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TerminalColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: (url != null && url.isNotEmpty)
          ? CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => const Icon(
                FLucideIcons.image,
                size: 16,
                color: TerminalColors.textMuted,
              ),
            )
          : const Icon(FLucideIcons.image, size: 16, color: TerminalColors.textMuted),
    );
  }
}
