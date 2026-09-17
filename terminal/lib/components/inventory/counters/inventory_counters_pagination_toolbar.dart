import 'package:flutter/widgets.dart';
import 'package:terminal/components/common/pagination_toolbar.dart';
import 'package:terminal/signals/inventory_counters_signal.dart';

/// Clean docked pagination toolbar for Inventory Counters.
class InventoryCountersPaginationToolbar extends StatelessWidget {
  /// Creates the inventory counters pagination toolbar.
  const InventoryCountersPaginationToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationToolbar(
      totalItems: () => filteredCountersSignal.value.length,
      pageSignal: counterPageSignal,
      entriesSignal: counterEntriesSignal,
      totalPagesSignal: counterTotalPagesSignal,
    );
  }
}
