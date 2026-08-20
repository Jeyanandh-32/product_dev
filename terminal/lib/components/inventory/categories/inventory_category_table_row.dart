import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/inventory_table_cells.dart';

/// DaisyUI-styled table row for categories with zebra striping and hover effect.
class InventoryCategoryTableRow extends StatefulWidget {
  final Category category;
  final int productsCount;
  final bool isEven;
  final VoidCallback onEdit;

  const InventoryCategoryTableRow({
    super.key,
    required this.category,
    required this.productsCount,
    required this.isEven,
    required this.onEdit,
  });

  @override
  State<InventoryCategoryTableRow> createState() => _InventoryCategoryTableRowState();
}

class _InventoryCategoryTableRowState extends State<InventoryCategoryTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    final rowBg = _isHovered
        ? const Color(0xFFF1F5F9)
        : (widget.isEven ? const Color(0xFFFFFFFF) : const Color(0xFFF8FAFC));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 60,
        decoration: BoxDecoration(
          color: rowBg,
          border: const Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: widget.onEdit,
                  icon: const Icon(FLucideIcons.squarePen, size: 16, color: Color(0xFF64748B)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  hoverColor: const Color(0xFFE2E8F0),
                  splashRadius: 18,
                ),
              ),
            ),
            const Gap(16),
            SizedBox(
              width: 56,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildThumbnail(cat.imageUrl),
              ),
            ),
            const Gap(16),
            Expanded(
              flex: 3,
              child: Text(
                cat.name,
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                softWrap: false,
                overflow: TextOverflow.visible,
              ),
            ),
            const Gap(16),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: InventoryTableCells.statusBadge(cat.isActive),
              ),
            ),
            const Gap(16),
            Expanded(
              flex: 3,
              child: Text(
                '${widget.productsCount}',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF0F172A)),
              ),
            ),
            const Gap(16),
            Expanded(
              flex: 3,
              child: Text(
                cat.description ?? '-',
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                softWrap: false,
                overflow: TextOverflow.visible,
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
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
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
    );
  }
}
