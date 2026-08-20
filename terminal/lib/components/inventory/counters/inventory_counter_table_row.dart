import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/inventory_table_cells.dart';

/// DaisyUI-styled table row for counters with zebra striping and hover effect.
class InventoryCounterTableRow extends StatefulWidget {
  final Counter counter;
  final int productsCount;
  final bool isEven;

  const InventoryCounterTableRow({
    super.key,
    required this.counter,
    required this.productsCount,
    required this.isEven,
  });

  @override
  State<InventoryCounterTableRow> createState() => _InventoryCounterTableRowState();
}

class _InventoryCounterTableRowState extends State<InventoryCounterTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final counter = widget.counter;
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
              width: 56,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildThumbnail(counter.imageUrl),
              ),
            ),
            const Gap(16),
            Expanded(
              flex: 3,
              child: Text(
                counter.name,
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
                child: InventoryTableCells.statusBadge(counter.isActive),
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
                counter.description ?? '-',
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
