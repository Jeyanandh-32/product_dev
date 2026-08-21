import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/components/inventory/inventory_status_badge.dart';
import 'package:terminal/theme/terminal_colors.dart';
import 'package:trina_grid/trina_grid.dart';

/// Reusable high-legibility cell and header widgets for inventory data table using TerminalColors tokens.
class InventoryTableCells {
  const InventoryTableCells._();

  static Widget plainTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title,
        softWrap: false,
        overflow: TextOverflow.visible,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: TerminalColors.textLight,
        ),
      ),
    );
  }

  static Widget sortableTitle(
    TrinaColumnTitleRendererContext ctx,
    String title,
  ) {
    final sort = ctx.column.sort;
    final isAsc = sort.isAscending;
    final isDesc = sort.isDescending;
    final isActive = isAsc || isDesc;

    return Container(
      width: double.infinity,
      height: ctx.height,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: TerminalColors.transparent,
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w700,
                color: isActive ? TerminalColors.primary : TerminalColors.textLight,
              ),
            ),
            const Gap(4),
            Icon(
              isActive
                  ? (isAsc ? FLucideIcons.arrowUp : FLucideIcons.arrowDown)
                  : FLucideIcons.arrowUpDown,
              size: 13,
              color: isActive ? TerminalColors.primary : TerminalColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  static Widget actionButtons({
    required VoidCallback onEdit,
    required VoidCallback onUpdateStock,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionBtn(FLucideIcons.squarePen, 'Edit', onEdit),
        const Gap(5),
        _buildActionBtn(FLucideIcons.boxes, 'Stock', onUpdateStock),
      ],
    );
  }

  static Widget _buildActionBtn(
    IconData icon,
    String tooltip,
    VoidCallback onTap,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PressableBox(
        onPress: onTap,
        style: BoxStyler()
            .width(30)
            .height(30)
            .borderRadiusAll(const Radius.circular(8))
            .color(TerminalColors.secondaryBackground)
            .alignment(Alignment.center)
            .onHovered(BoxStyler().color(TerminalColors.controlHover)),
        child: Icon(icon, size: 14.5, color: TerminalColors.textLight),
      ),
    );
  }

  static Widget thumbnail(String? url, {double size = 38}) => SizedBox.square(
    dimension: size,
    child: AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: TerminalColors.pageBackground,
          borderRadius: BorderRadius.circular(8),
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
            : const Icon(
                FLucideIcons.image,
                size: 16,
                color: TerminalColors.textMuted,
              ),
      ),
    ),
  );

  static Widget statusBadge(bool isActive) => InventoryStatusBadge(isActive: isActive);

  static Widget monitorBadge(bool isEnabled) => InventoryMonitorBadge(isEnabled: isEnabled);
}
