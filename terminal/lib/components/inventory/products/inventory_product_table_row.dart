import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/inventory_stock_badge.dart';
import 'package:terminal/components/inventory/inventory_table_cells.dart';

/// DaisyUI-styled table row for products with zebra striping and hover effect.
class InventoryProductTableRow extends StatefulWidget {
  final Product product;
  final bool isEven;
  final VoidCallback onEdit;
  final VoidCallback onUpdateStock;

  const InventoryProductTableRow({
    super.key,
    required this.product,
    required this.isEven,
    required this.onEdit,
    required this.onUpdateStock,
  });

  @override
  State<InventoryProductTableRow> createState() => _InventoryProductTableRowState();
}

class _InventoryProductTableRowState extends State<InventoryProductTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
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
              width: 80,
              child: Align(
                alignment: Alignment.centerLeft,
                child: InventoryTableCells.actionButtons(
                  onEdit: widget.onEdit,
                  onUpdateStock: widget.onUpdateStock,
                ),
              ),
            ),
            const Gap(16),
            SizedBox(
              width: 56,
              child: Align(alignment: Alignment.centerLeft, child: _buildThumbnail(p.imageUrl)),
            ),
            const Gap(16),
            SizedBox(
              width: 240,
              child: Text(
                p.name,
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                softWrap: false,
                overflow: TextOverflow.visible,
              ),
            ),
            const Gap(16),
            SizedBox(width: 120, child: Text(p.sku ?? '-', style: _cellStyle)),
            const Gap(16),
            SizedBox(width: 130, child: Text(p.barcode ?? '-', style: _cellStyle)),
            const Gap(16),
            SizedBox(width: 110, child: Align(alignment: Alignment.centerLeft, child: InventoryTableCells.statusBadge(p.isActive))),
            const Gap(16),
            SizedBox(width: 100, child: Align(alignment: Alignment.centerLeft, child: InventoryStockBadge(stock: p.stock))),
            const Gap(16),
            SizedBox(width: 120, child: Text('${p.stock?.lowStockThreshold ?? 0}', style: _cellStyle)),
            const Gap(16),
            SizedBox(width: 140, child: Align(alignment: Alignment.centerLeft, child: InventoryTableCells.monitorBadge(p.stock?.stockMonitor ?? false))),
            const Gap(16),
            SizedBox(width: 160, child: Text(p.basePrice.toStringAsFixed(2), style: _cellStyle)),
            const Gap(16),
            SizedBox(width: 170, child: Text(p.sellingPrice.toStringAsFixed(2), style: _cellStyle)),
            const Gap(16),
            SizedBox(width: 120, child: Text('${p.taxRate.toStringAsFixed(2)}%', style: _cellStyle)),
            const Gap(16),
            SizedBox(width: 140, child: Text(p.category?.name ?? '-', style: _cellStyle)),
            const Gap(16),
            SizedBox(width: 140, child: Text(p.counter?.name ?? '-', style: _cellStyle)),
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

  static const _cellStyle = TextStyle(fontSize: 13, color: Color(0xFF0F172A));
}
