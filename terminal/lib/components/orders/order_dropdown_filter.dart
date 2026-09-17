import 'package:flutter/widgets.dart';
import 'package:terminal/components/common/dropdown_filter.dart';

/// Clean pill dropdown filter for Payment Mode, Payment Status, and Order Status.
class OrderDropdownFilter<T> extends StatelessWidget {
  /// Creates an order dropdown pill filter.
  const OrderDropdownFilter({
    super.key,
    required this.title,
    required this.currentValue,
    required this.items,
    required this.onSelected,
  });

  /// The filter category title.
  final String title;

  /// The currently active filter value.
  final T? currentValue;

  /// The list of selectable filter items.
  final List<({String label, T? value})> items;

  /// Callback when a filter value is chosen or cleared.
  final ValueChanged<T?> onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownFilter<T>(
      label: title,
      value: currentValue,
      items: items,
      onSelected: onSelected,
      variant: DropdownFilterVariant.pill,
    );
  }
}
