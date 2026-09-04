import 'package:flutter/material.dart';
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
  State<InventoryCounterTableRow> createState() =>
      _InventoryCounterTableRowState();
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
          border: const Border(
            bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
          ),
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
              flex: 3,
              child: Text(
                counter.name,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
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
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            const Gap(16),
            Expanded(
              flex: 3,
              child: Text(
                counter.description ?? '-',
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
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
