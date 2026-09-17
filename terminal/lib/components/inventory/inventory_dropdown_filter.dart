import 'package:flutter/widgets.dart';
import 'package:terminal/components/common/dropdown_filter.dart';

/// Reusable dropdown popover filter button for table filters.
class InventoryDropdownFilter<T> extends StatelessWidget {
  /// Creates an inventory dropdown filter.
  const InventoryDropdownFilter({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onSelected,
  });

  /// The filter category label.
  final String label;

  /// The currently active filter value.
  final T? value;

  /// The list of selectable filter items.
  final List<({String label, T? value})> items;

  /// Callback when a filter value is chosen.
  final ValueChanged<T?> onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownFilter<T>(
      label: label,
      value: value,
      items: items,
      onSelected: onSelected,
      variant: DropdownFilterVariant.standard,
    );
  }
}
