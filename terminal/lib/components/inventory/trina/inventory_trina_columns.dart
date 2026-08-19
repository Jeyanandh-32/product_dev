import 'package:flutter/widgets.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/inventory_stock_badge.dart';
import 'package:terminal/components/inventory/inventory_table_cells.dart';
import 'package:trina_grid/trina_grid.dart';

/// Column definitions for the POS Inventory Products TrinaGrid.
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
        width: 96,
        enableSorting: false,
        enableEditingMode: false,
        enableContextMenu: false,
        enableDropToResize: false,
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
        width: 64,
        enableSorting: false,
        enableEditingMode: false,
        enableContextMenu: false,
        enableDropToResize: false,
        renderer: (ctx) => Align(alignment: Alignment.centerLeft, child: InventoryTableCells.thumbnail(ctx.cell.value as String?, size: 38)),
      ),
      TrinaColumn(
        title: 'Product Name',
        field: 'name',
        type: TrinaColumnType.text(),
        width: 250,
        enableEditingMode: false,
        enableContextMenu: false,
        enableDropToResize: false,
        titleRenderer: (ctx) => InventoryTableCells.sortableTitle(ctx, 'Product Name'),
        renderer: (ctx) => Align(
          alignment: Alignment.centerLeft,
          child: Text(ctx.cell.value?.toString() ?? '', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF000000))),
        ),
      ),
      _sortableCol('SKU', 'sku', 130),
      _sortableCol('Barcode', 'barcode', 140),
      TrinaColumn(
        title: 'Status',
        field: 'status',
        type: TrinaColumnType.text(),
        width: 110,
        enableSorting: false,
        enableEditingMode: false,
        enableContextMenu: false,
        enableDropToResize: false,
        renderer: (ctx) => Align(alignment: Alignment.centerLeft, child: InventoryTableCells.statusBadge(ctx.cell.value == true)),
      ),
      TrinaColumn(
        title: 'Stock',
        field: 'stock',
        type: TrinaColumnType.number(),
        width: 100,
        enableEditingMode: false,
        enableContextMenu: false,
        enableDropToResize: false,
        titleRenderer: (ctx) => InventoryTableCells.sortableTitle(ctx, 'Stock'),
        renderer: (ctx) {
          final product = ctx.row.cells['product_ref']?.value as Product?;
          return Align(alignment: Alignment.centerLeft, child: InventoryStockBadge(stock: product?.stock));
        },
      ),
      _sortableCol('Low Stock', 'low_stock', 100),
      TrinaColumn(
        title: 'Stock Monitor',
        field: 'monitor',
        type: TrinaColumnType.text(),
        width: 120,
        enableSorting: false,
        enableEditingMode: false,
        enableContextMenu: false,
        enableDropToResize: false,
        renderer: (ctx) => Align(alignment: Alignment.centerLeft, child: InventoryTableCells.monitorBadge(ctx.cell.value == true)),
      ),
      _sortableCol('Base Price', 'base_price', 115),
      _sortableCol('Selling Price', 'selling_price', 125),
      _sortableCol('Tax Rate', 'tax_rate', 96),
      _plainCol('Category', 'category', 140),
      _plainCol('Counter', 'counter', 130),
    ];
  }

  static TrinaColumn _sortableCol(String title, String field, double width) => TrinaColumn(
        title: title,
        field: field,
        type: TrinaColumnType.text(),
        width: width,
        enableEditingMode: false,
        enableContextMenu: false,
        enableDropToResize: false,
        titleRenderer: (ctx) => InventoryTableCells.sortableTitle(ctx, title),
        renderer: (ctx) => Align(
          alignment: Alignment.centerLeft,
          child: Text(ctx.cell.value?.toString() ?? '-', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF000000))),
        ),
      );

  static TrinaColumn _plainCol(String title, String field, double width) => TrinaColumn(
        title: title,
        field: field,
        type: TrinaColumnType.text(),
        width: width,
        enableSorting: false,
        enableEditingMode: false,
        enableContextMenu: false,
        enableDropToResize: false,
        renderer: (ctx) => Align(
          alignment: Alignment.centerLeft,
          child: Text(ctx.cell.value?.toString() ?? '-', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF000000))),
        ),
      );
}
