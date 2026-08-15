import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/reports/report_dropdown_filter.dart';
import 'package:merchant/signals/reports_date_signal.dart';

/// Filter bar providing dropdown selectors for Payment Mode, Payment Status, and Order Status.
class OrdersFilterBar extends StatelessComponent {
  final VoidCallback onFiltersChanged;

  const OrdersFilterBar({super.key, required this.onFiltersChanged});

  @override
  Component build(BuildContext context) {
    return div(classes: 'flex flex-wrap items-center gap-2', [
      ReportDropdownFilter<String>(
        title: 'Payment',
        currentValue: reportsPaymentMethodSignal.value,
        items: const [
          DropdownFilterItem(label: 'All Payment Modes', value: null),
          DropdownFilterItem(label: 'Cash', value: 'cash'),
          DropdownFilterItem(label: 'UPI', value: 'upi'),
          DropdownFilterItem(label: 'Free', value: 'complimentary'),
        ],
        onSelected: (val) {
          reportsPaymentMethodSignal.value = val;
          onFiltersChanged();
        },
      ),
      ReportDropdownFilter<String>(
        title: 'Payment Status',
        currentValue: reportsPaymentStatusSignal.value,
        items: const [
          DropdownFilterItem(label: 'All Payment Statuses', value: null),
          DropdownFilterItem(label: 'Completed', value: 'completed'),
          DropdownFilterItem(label: 'Pending', value: 'pending'),
          DropdownFilterItem(label: 'Failed', value: 'failed'),
        ],
        onSelected: (val) {
          reportsPaymentStatusSignal.value = val;
          onFiltersChanged();
        },
      ),
      ReportDropdownFilter<String>(
        title: 'Order Status',
        currentValue: reportsOrderStatusSignal.value,
        items: const [
          DropdownFilterItem(label: 'All Order Statuses', value: null),
          DropdownFilterItem(label: 'Completed', value: 'completed'),
          DropdownFilterItem(label: 'Preparing', value: 'preparing'),
          DropdownFilterItem(label: 'Pending', value: 'pending'),
          DropdownFilterItem(label: 'Cancelled', value: 'cancelled'),
        ],
        onSelected: (val) {
          reportsOrderStatusSignal.value = val;
          onFiltersChanged();
        },
      ),
    ]);
  }
}
