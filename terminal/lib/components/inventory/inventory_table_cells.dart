import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:terminal/components/inventory/inventory_action_buttons.dart';
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
    Key? editKey,
  }) => InventoryActionButtons(
        onEdit: onEdit,
        onUpdateStock: onUpdateStock,
        editKey: editKey,
      );

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
            ? (kIsWeb
                ? Image.network(
                    url,
                    fit: BoxFit.cover,
                    webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                    errorBuilder: (_, _, _) => const Icon(
                      FLucideIcons.image,
                      size: 16,
                      color: TerminalColors.textMuted,
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => const Icon(
                      FLucideIcons.image,
                      size: 16,
                      color: TerminalColors.textMuted,
                    ),
                  ))
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
