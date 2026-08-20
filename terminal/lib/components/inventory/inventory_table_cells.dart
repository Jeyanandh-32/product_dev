import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:trina_grid/trina_grid.dart';

/// Reusable high-legibility cell and header widgets for inventory data table.
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
          color: Color(0xFF475569),
        ),
      ),
    );
  }

  static Widget sortableTitle(TrinaColumnTitleRendererContext ctx, String title) {
    final sort = ctx.column.sort;
    final isAsc = sort.isAscending;
    final isDesc = sort.isDescending;
    final isActive = isAsc || isDesc;

    return Container(
      width: double.infinity,
      height: ctx.height,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: const Color(0x00000000),
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
                color: isActive ? const Color(0xFF191645) : const Color(0xFF475569),
              ),
            ),
            const Gap(4),
            Icon(
              isActive ? (isAsc ? FLucideIcons.arrowUp : FLucideIcons.arrowDown) : FLucideIcons.arrowUpDown,
              size: 13,
              color: isActive ? const Color(0xFF191645) : const Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  static Widget actionButtons({required VoidCallback onEdit, required VoidCallback onUpdateStock}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionBtn(FLucideIcons.squarePen, 'Edit', onEdit),
        const Gap(5),
        _buildActionBtn(FLucideIcons.boxes, 'Stock', onUpdateStock),
      ],
    );
  }

  static Widget _buildActionBtn(IconData icon, String tooltip, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PressableBox(
        onPress: onTap,
        style: BoxStyler()
            .width(30)
            .height(30)
            .borderRadiusAll(const Radius.circular(8))
            .color(const Color(0xFFF1F5F9))
            .alignment(Alignment.center)
            .onHovered(BoxStyler().color(const Color(0xFFE2E8F0))),
        child: Icon(icon, size: 14.5, color: const Color(0xFF334155)),
      ),
    );
  }

  static Widget thumbnail(String? url, {double size = 38}) => SizedBox.square(
        dimension: size,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            clipBehavior: Clip.antiAlias,
            child: (url != null && url.isNotEmpty)
                ? CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => const Icon(FLucideIcons.image, size: 16, color: Color(0xFF94A3B8)),
                  )
                : const Icon(FLucideIcons.image, size: 16, color: Color(0xFF94A3B8)),
          ),
        ),
      );

  static Widget statusBadge(bool isActive) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE8FFFC) : const Color(0xFFFFF2F2),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          isActive ? 'ACTIVE' : 'INACTIVE',
          softWrap: false,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? const Color(0xFF167B6C) : const Color(0xFFFE5454),
          ),
          textAlign: TextAlign.center,
        ),
      );

  static Widget monitorBadge(bool isEnabled) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isEnabled ? const Color(0xFFE8FFFC) : const Color(0xFFFFF2F2),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          isEnabled ? 'ON' : 'OFF',
          softWrap: false,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isEnabled ? const Color(0xFF167B6C) : const Color(0xFFFE5454),
          ),
          textAlign: TextAlign.center,
        ),
      );
}
