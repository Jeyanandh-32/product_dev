import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/reports/report_dropdown_filter.dart';

/// Filter bar providing dropdown selectors for Product Status and Stock Monitor status.
class ProductsFilterBar extends StatelessComponent {
  final bool? statusFilter;
  final bool? stockMonitorFilter;
  final ValueChanged<bool?> onStatusFilterChanged;
  final ValueChanged<bool?> onStockMonitorFilterChanged;

  const ProductsFilterBar({
    super.key,
    required this.statusFilter,
    required this.stockMonitorFilter,
    required this.onStatusFilterChanged,
    required this.onStockMonitorFilterChanged,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'grid grid-cols-2 gap-2 w-full sm:flex sm:items-center',
      [
        ReportDropdownFilter<bool>(
          title: 'Status',
          currentValue: statusFilter,
          items: const [
            DropdownFilterItem(label: 'All Statuses', value: null),
            DropdownFilterItem(label: 'Active', value: true),
            DropdownFilterItem(label: 'Inactive', value: false),
          ],
          onSelected: onStatusFilterChanged,
        ),
        ReportDropdownFilter<bool>(
          title: 'Stock Monitor',
          currentValue: stockMonitorFilter,
          alignEnd: true,
          items: const [
            DropdownFilterItem(label: 'All Stock Monitors', value: null),
            DropdownFilterItem(label: 'Enabled', value: true),
            DropdownFilterItem(label: 'Disabled', value: false),
          ],
          onSelected: onStockMonitorFilterChanged,
        ),
      ],
    );
  }
}
