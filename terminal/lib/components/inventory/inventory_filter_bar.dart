import 'package:flutter/widgets.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/inventory_dropdown_filter.dart';
import 'package:terminal/signals/inventory_products_signal.dart';

/// Top filter row containing Status, Stock Monitor, Category, and Counter dropdowns.
class InventoryFilterBar extends SignalWidget {
  final List<Category> categories;
  final List<Counter> counters;

  const InventoryFilterBar({super.key, required this.categories, required this.counters});

  @override
  Widget build(BuildContext context) {
    final statusFilter = inventoryStatusFilterSignal.value;
    final monitorFilter = inventoryStockMonitorFilterSignal.value;
    final categoryFilter = inventoryCategoryFilterSignal.value;
    final counterFilter = inventoryCounterFilterSignal.value;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        InventoryDropdownFilter<bool>(
          label: 'Status',
          value: statusFilter,
          items: const [
            (label: 'All', value: null),
            (label: 'Active', value: true),
            (label: 'Inactive', value: false),
          ],
          onSelected: (val) {
            inventoryStatusFilterSignal.value = val;
            inventoryPageSignal.value = 1;
          },
        ),
        InventoryDropdownFilter<bool>(
          label: 'Stock Monitor',
          value: monitorFilter,
          items: const [
            (label: 'All', value: null),
            (label: 'On', value: true),
            (label: 'Off', value: false),
          ],
          onSelected: (val) {
            inventoryStockMonitorFilterSignal.value = val;
            inventoryPageSignal.value = 1;
          },
        ),
        if (categories.isNotEmpty)
          InventoryDropdownFilter<String>(
            label: 'Category',
            value: categoryFilter,
            items: [
              (label: 'All', value: null),
              ...categories.map((c) => (label: c.name, value: c.id)),
            ],
            onSelected: (val) {
              inventoryCategoryFilterSignal.value = val;
              inventoryPageSignal.value = 1;
            },
          ),
        if (counters.isNotEmpty)
          InventoryDropdownFilter<String>(
            label: 'Counter',
            value: counterFilter,
            items: [
              (label: 'All', value: null),
              ...counters.map((c) => (label: c.name, value: c.id)),
            ],
            onSelected: (val) {
              inventoryCounterFilterSignal.value = val;
              inventoryPageSignal.value = 1;
            },
          ),
      ],
    );
  }
}
