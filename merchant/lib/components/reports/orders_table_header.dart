import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/sortable_header.dart';

/// Sort keys for orders report data table.
enum OrderSortKey {
  orderReference,
  date,
  orderId,
  grossAmount,
  discountAmount,
  walletPaid,
  netAmount,
  paymentMode,
  paymentStatus,
  orderStatus,
}

/// Table header for merchant orders report.
class OrdersTableHeader extends StatelessComponent {
  final SortState<OrderSortKey> sortState;
  final ValueChanged<OrderSortKey> onSort;

  const OrdersTableHeader({
    super.key,
    required this.sortState,
    required this.onSort,
  });

  @override
  Component build(BuildContext context) {
    return thead([
      tr([
        th([]),
        SortableHeader<OrderSortKey>(
          title: 'Order Reference',
          sortKey: OrderSortKey.orderReference,
          currentSort: sortState,
          onSort: onSort,
          isTh: true,
        ),
        SortableHeader<OrderSortKey>(
          title: 'Date',
          sortKey: OrderSortKey.date,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<OrderSortKey>(
          title: 'Order ID',
          sortKey: OrderSortKey.orderId,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<OrderSortKey>(
          title: 'Gross Amount (₹)',
          sortKey: OrderSortKey.grossAmount,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<OrderSortKey>(
          title: 'Discount (₹)',
          sortKey: OrderSortKey.discountAmount,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<OrderSortKey>(
          title: 'Wallet Paid (₹)',
          sortKey: OrderSortKey.walletPaid,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<OrderSortKey>(
          title: 'Net Amount (₹)',
          sortKey: OrderSortKey.netAmount,
          currentSort: sortState,
          onSort: onSort,
        ),
        td([.text('Payment Mode')]),
        td([.text('Payment Status')]),
        td([.text('Order Status')]),
        th([]),
      ]),
    ]);
  }
}
