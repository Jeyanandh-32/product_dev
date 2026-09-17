import 'package:flutter/widgets.dart';
import 'package:terminal/components/common/pagination_toolbar.dart';
import 'package:terminal/signals/inventory_products_signal.dart';

/// Docked pagination toolbar for the main Inventory Products catalog.
class InventoryPaginationToolbar extends StatelessWidget {
  /// Creates the inventory products pagination toolbar.
  const InventoryPaginationToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationToolbar(
      totalItems: () => filteredInventoryProductsSignal.value.length,
      pageSignal: inventoryPageSignal,
      entriesSignal: inventoryEntriesSignal,
      totalPagesSignal: inventoryTotalPagesSignal,
    );
  }
}
