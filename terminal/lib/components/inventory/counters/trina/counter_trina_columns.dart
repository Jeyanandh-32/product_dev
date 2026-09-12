import 'package:flutter/widgets.dart';
import 'package:terminal/components/inventory/inventory_table_cells.dart';
import 'package:terminal/theme/terminal_colors.dart';
import 'package:trina_grid/trina_grid.dart';

/// Read-only column definitions for the POS Inventory Counters TrinaGrid spreading columns equally like DaisyUI.
class CounterTrinaColumns {
  const CounterTrinaColumns._();

  static List<TrinaColumn> build({double? totalWidth}) {
    const fixedWidth = 64.0;
    final available = totalWidth != null && totalWidth > (fixedWidth + 400)
        ? totalWidth - fixedWidth
        : 800.0;

    final colWidth = available / 4.0;

    return [
      TrinaColumn(
        title: 'Image',
        field: 'image',
        type: TrinaColumnType.text(),
        width: fixedWidth,
        enableSorting: false,
        enableEditingMode: false,
        enableContextMenu: false,
        enableDropToResize: false,
        renderer: (ctx) => Align(
          alignment: Alignment.centerLeft,
          child: InventoryTableCells.thumbnail(
            ctx.cell.value as String?,
            size: 38,
          ),
        ),
      ),
      TrinaColumn(
        title: 'Name',
        field: 'name',
        type: TrinaColumnType.text(),
        width: colWidth,
        enableEditingMode: false,
        enableContextMenu: false,
        titleRenderer: (ctx) => InventoryTableCells.sortableTitle(ctx, 'Name'),
        renderer: (ctx) => Align(
          alignment: Alignment.centerLeft,
          child: Text(
            ctx.cell.value?.toString() ?? '',
            softWrap: false,
            overflow: TextOverflow.visible,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: TerminalColors.textPrimary,
            ),
          ),
        ),
      ),
      TrinaColumn(
        title: 'Status',
        field: 'status',
        type: TrinaColumnType.text(),
        width: colWidth,
        enableEditingMode: false,
        enableContextMenu: false,
        titleRenderer: (ctx) =>
            InventoryTableCells.sortableTitle(ctx, 'Status'),
        renderer: (ctx) => Align(
          alignment: Alignment.centerLeft,
          child: InventoryTableCells.statusBadge(
            ctx.cell.value as bool? ?? true,
          ),
        ),
      ),
      TrinaColumn(
        title: 'Associated Products',
        field: 'products_count',
        type: TrinaColumnType.text(),
        width: colWidth,
        enableEditingMode: false,
        enableContextMenu: false,
        titleRenderer: (ctx) =>
            InventoryTableCells.sortableTitle(ctx, 'Associated Products'),
        renderer: (ctx) => Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${ctx.cell.value ?? 0}',
            softWrap: false,
            overflow: TextOverflow.visible,
            style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
          ),
        ),
      ),
      TrinaColumn(
        title: 'Description',
        field: 'description',
        type: TrinaColumnType.text(),
        width: colWidth,
        enableEditingMode: false,
        enableContextMenu: false,
        titleRenderer: (ctx) =>
            InventoryTableCells.sortableTitle(ctx, 'Description'),
        renderer: (ctx) => Align(
          alignment: Alignment.centerLeft,
          child: Text(
            ctx.cell.value?.toString() ?? '-',
            softWrap: false,
            overflow: TextOverflow.visible,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ),
      ),
    ];
  }
}
