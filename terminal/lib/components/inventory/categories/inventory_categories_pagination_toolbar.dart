import 'package:flutter/widgets.dart';
import 'package:terminal/components/common/pagination_toolbar.dart';
import 'package:terminal/signals/inventory_categories_signal.dart';

/// Clean docked pagination toolbar for Inventory Categories.
class InventoryCategoriesPaginationToolbar extends StatelessWidget {
  /// Creates the inventory categories pagination toolbar.
  const InventoryCategoriesPaginationToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationToolbar(
      totalItems: () => filteredCategoriesSignal.value.length,
      pageSignal: categoryPageSignal,
      entriesSignal: categoryEntriesSignal,
      totalPagesSignal: categoryTotalPagesSignal,
    );
  }
}
