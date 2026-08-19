import 'package:flutter/widgets.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/trina/inventory_trina_columns.dart';
import 'package:terminal/components/inventory/trina/inventory_trina_grid_config.dart';
import 'package:terminal/components/inventory/trina/inventory_trina_rows.dart';
import 'package:trina_grid/trina_grid.dart';

/// Full-featured TrinaGrid POS inventory products table with column resizing and frozen headers.
class InventoryDataTable extends StatefulWidget {
  final List<Product> products;
  final void Function(Product product) onEdit;
  final void Function(Product product) onUpdateStock;

  const InventoryDataTable({
    super.key,
    required this.products,
    required this.onEdit,
    required this.onUpdateStock,
  });

  @override
  State<InventoryDataTable> createState() => _InventoryDataTableState();
}

class _InventoryDataTableState extends State<InventoryDataTable> {
  TrinaGridStateManager? _stateManager;
  late List<TrinaColumn> _columns;
  late List<TrinaRow> _rows;

  @override
  void initState() {
    super.initState();
    _columns = InventoryTrinaColumns.build(
      onEdit: widget.onEdit,
      onUpdateStock: widget.onUpdateStock,
    );
    _rows = InventoryTrinaRows.fromProducts(widget.products);
  }

  @override
  void didUpdateWidget(covariant InventoryDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.products != widget.products) {
      _rows = InventoryTrinaRows.fromProducts(widget.products);
      if (_stateManager != null) {
        _stateManager!.removeAllRows();
        _stateManager!.appendRows(_rows);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TrinaGrid(
      columns: _columns,
      rows: _rows,
      onLoaded: (event) {
        _stateManager = event.stateManager;
      },
      configuration: InventoryTrinaGridConfig.build(),
    );
  }
}
