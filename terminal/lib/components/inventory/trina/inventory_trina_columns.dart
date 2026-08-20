import 'package:flutter/widgets.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/inventory_stock_badge.dart';
import 'package:terminal/components/inventory/inventory_table_cells.dart';
import 'package:trina_grid/trina_grid.dart';

/// Column definitions for the POS Inventory Products TrinaGrid behaving like DaisyUI table.
class InventoryTrinaColumns {
  const InventoryTrinaColumns._();

  static List<TrinaColumn> build({
    required void Function(Product product) onEdit,
    required void Function(Product product) onUpdateStock,
  }) {
    return [
      TrinaColumn(
        title: 'Action',
        field: 'action',
        type: TrinaColumnType.text(),
        width: 100,
        suppressedAutoSize: true,
        enableSorting: false,
        enableEditingMode: false,
        enableContextMenu: false,
        enableDropToResize: false,
        titleRenderer: (ctx) => InventoryTableCells.plainTitle('Action'),
        renderer: (ctx) {
          final product = ctx.row.cells['product_ref']?.value as Product?;
          if (product == null) return const SizedBox.shrink();
          return InventoryTableCells.actionButtons(onEdit: () => onEdit(product), onUpdateStock: () => onUpdateStock(product));
        },
      ),
      TrinaColumn(
        title: 'Image',
        field: 'image',
        type: TrinaColumnType.text(),
        width: 70,
        suppressedAutoSize: true,
        enableSorting: false,
        enableEditingMode: false,
        enableContextMenu: false,
        enableDropToResize: false,
        titleRenderer: (ctx) => InventoryTableCells.plainTitle('Image'),
        renderer: (ctx) => Align(alignment: Alignment.centerLeft, child: InventoryTableCells.thumbnail(ctx.cell.value as String?, size: 38)),
      ),
      TrinaColumn(
        title: 'Product Name',
        field: 'name',
        type: TrinaColumnType.text(),
        width: 260,
        enableEditingMode: false,
        enableContextMenu: false,
        enableDropToResize: false,
        titleRenderer: (ctx) => InventoryTableCells.sortableTitle(ctx, 'Product Name'),
        renderer: (ctx) => Align(
          alignment: Alignment.centerLeft,
          child: Text(
            ctx.cell.value?.toString() ?? '',
            softWrap: false,
            overflow: TextOverflow.visible,
            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF000000)),
          ),
        ),
      ),
      _sortableCol('SKU', 'sku', 130, suppressed: true),
      _sortableCol('Barcode', 'barcode', 140, suppressed: true),
      TrinaColumn(
        title: 'Status',
        field: 'status',
        type: TrinaColumnType.text(),
        width: 110,
        suppressedAutoSize: true,
        enableSorting: false,
        enableEditingMode: false,
        enableContextMenu: false,
        enableDropToResize: false,
        titleRenderer: (ctx) => InventoryTableCells.plainTitle('Status'),
        renderer: (ctx) => Align(alignment: Alignment.centerLeft, child: InventoryTableCells.statusBadge(ctx.cell.value == true)),
      ),
      TrinaColumn(
        title: 'Stock',
        field: 'stock',
        type: TrinaColumnType.number(),
        width: 110,
        suppressedAutoSize: true,
        enableEditingMode: false,
        enableContextMenu: false,
        enableDropToResize: false,
        titleRenderer: (ctx) => InventoryTableCells.sortableTitle(ctx, 'Stock'),
        renderer: (ctx) {
          final product = ctx.row.cells['product_ref']?.value as Product?;
          return Align(alignment: Alignment.centerLeft, child: InventoryStockBadge(stock: product?.stock));
        },
      ),
      _sortableCol('Low Stock', 'low_stock', 120, suppressed: true),
      TrinaColumn(
        title: 'Stock Monitor',
        field: 'monitor',
        type: TrinaColumnType.text(),
        width: 130,
        suppressedAutoSize: true,
        enableSorting: false,
        enableEditingMode: false,
        enableContextMenu: false,
        enableDropToResize: false,
        titleRenderer: (ctx) => InventoryTableCells.plainTitle('Stock Monitor'),
        renderer: (ctx) => Align(alignment: Alignment.centerLeft, child: InventoryTableCells.monitorBadge(ctx.cell.value == true)),
      ),
      _sortableCol('Base Price', 'base_price', 120, suppressed: true),
      _sortableCol('Selling Price', 'selling_price', 125, suppressed: true),
      _sortableCol('Tax Rate', 'tax_rate', 110, suppressed: true),
      _plainCol('Category', 'category', 140),
      _plainCol('Counter', 'counter', 130),
    ];
  }

  static TrinaColumn _sortableCol(String title, String field, double width, {bool suppressed = false}) {
    return TrinaColumn(
      title: title,
      field: field,
      type: TrinaColumnType.text(),
      width: width,
      suppressedAutoSize: suppressed,
      enableEditingMode: false,
      enableContextMenu: false,
      enableDropToResize: false,
      titleRenderer: (ctx) => InventoryTableCells.sortableTitle(ctx, title),
      renderer: (ctx) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          ctx.cell.value?.toString() ?? '-',
          softWrap: false,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
        ),
      ),
    );
  }

  static TrinaColumn _plainCol(String title, String field, double width) {
    return TrinaColumn(
      title: title,
      field: field,
      type: TrinaColumnType.text(),
      width: width,
      suppressedAutoSize: true,
      enableSorting: false,
      enableEditingMode: false,
      enableContextMenu: false,
      enableDropToResize: false,
      titleRenderer: (ctx) => InventoryTableCells.plainTitle(title),
      renderer: (ctx) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          ctx.cell.value?.toString() ?? '-',
          softWrap: false,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
        ),
      ),
    );
  }
}
