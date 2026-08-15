import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/sortable_header.dart';

/// Sortable keys for payments report data table.
enum PaymentSortKey {
  orderReference,
  date,
  orderId,
  orderAmount,
  discountAmount,
  paidAmount,
  paymentMode,
  paymentStatus,
}

/// Table header for merchant payments report.
class PaymentsTableHeader extends StatelessComponent {
  final SortState<PaymentSortKey> sortState;
  final ValueChanged<PaymentSortKey> onSort;

  const PaymentsTableHeader({
    super.key,
    required this.sortState,
    required this.onSort,
  });

  @override
  Component build(BuildContext context) {
    return thead([
      tr([
        th([]),
        SortableHeader<PaymentSortKey>(
          title: 'Order Reference',
          sortKey: PaymentSortKey.orderReference,
          currentSort: sortState,
          onSort: onSort,
          isTh: true,
        ),
        SortableHeader<PaymentSortKey>(
          title: 'Date',
          sortKey: PaymentSortKey.date,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<PaymentSortKey>(
          title: 'Order ID',
          sortKey: PaymentSortKey.orderId,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<PaymentSortKey>(
          title: 'Order Amount (₹)',
          sortKey: PaymentSortKey.orderAmount,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<PaymentSortKey>(
          title: 'Discount (₹)',
          sortKey: PaymentSortKey.discountAmount,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<PaymentSortKey>(
          title: 'Paid Amount (₹)',
          sortKey: PaymentSortKey.paidAmount,
          currentSort: sortState,
          onSort: onSort,
        ),
        td([.text('Payment Mode')]),
        td([.text('Payment Status')]),
        th([]),
      ]),
    ]);
  }
}
