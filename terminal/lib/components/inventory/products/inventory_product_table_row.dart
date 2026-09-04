import 'package:flutter/material.dart';
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
  State<InventoryProductTableRow> createState() =>
      _InventoryProductTableRowState();
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
          border: const Border(
            bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _cell(
              80,
              InventoryTableCells.actionButtons(
                onEdit: widget.onEdit,
                onUpdateStock: widget.onUpdateStock,
              ),
            ),
            const Gap(16),
            _cell(56, InventoryTableCells.thumbnail(p.imageUrl, size: 42)),
            const Gap(16),
            SizedBox(
              width: 240,
              child: Text(
                p.name,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
                softWrap: false,
                overflow: TextOverflow.visible,
              ),
            ),
            const Gap(16),
            _text(120, p.sku ?? '-'),
            const Gap(16),
            _text(130, p.barcode ?? '-'),
            const Gap(16),
            _cell(110, InventoryTableCells.statusBadge(p.isActive)),
            const Gap(16),
            _cell(100, InventoryStockBadge(stock: p.stock)),
            const Gap(16),
            _text(120, '${p.stock?.lowStockThreshold ?? 0}'),
            const Gap(16),
            _cell(
              140,
              InventoryTableCells.monitorBadge(p.stock?.stockMonitor ?? false),
            ),
            const Gap(16),
            _text(160, p.basePrice.toStringAsFixed(2)),
            const Gap(16),
            _text(170, p.sellingPrice.toStringAsFixed(2)),
            const Gap(16),
            _text(120, '${p.taxRate.toStringAsFixed(2)}%'),
            const Gap(16),
            _text(140, p.category?.name ?? '-'),
            const Gap(16),
            _text(140, p.counter?.name ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _cell(double width, Widget child) => SizedBox(
        width: width,
        child: Align(alignment: Alignment.centerLeft, child: child),
      );

  Widget _text(double width, String text) =>
      SizedBox(width: width, child: Text(text, style: _cellStyle));

  static const _cellStyle = TextStyle(fontSize: 13, color: Color(0xFF0F172A));
}
