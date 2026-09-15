import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/reports/payment_table_row.dart';
import 'package:merchant/components/reports/payments_table_header.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:merchant/utils/payment_formatter.dart';
import 'package:models/models.dart';

/// Scrollable payments table view with column sorting and formatted status.
class PaymentsTableView extends StatelessComponent {
  final List<Payment> payments;
  final SortState<PaymentSortKey> sortState;
  final ValueChanged<PaymentSortKey> onSort;

  const PaymentsTableView({
    super.key,
    required this.payments,
    required this.sortState,
    required this.onSort,
  });

  String _formatDate(DateTime dt) => AppDateFormatter.formatDate(dt);

  @override
  Component build(BuildContext context) {
    final sortedPayments = sortItems<Payment, PaymentSortKey>(
      items: payments,
      sortState: sortState,
      getSortValue: (item, k) => switch (k) {
        .orderReference => item.orderReference.toLowerCase(),
        .date => item.date,
        .orderId => item.orderId,
        .orderAmount => item.orderAmount,
        .discountAmount => item.discountAmount,
        .paidAmount => item.paidAmount,
        .paymentMode => item.paymentMode.name.toLowerCase(),
        .paymentStatus => item.paymentStatus.name.toLowerCase(),
      },
    );

    return div(classes: 'flex-1 min-h-0 overflow-auto', [
      table(
        classes: 'table table-zebra table-pin-rows table-pin-cols',
        [
          PaymentsTableHeader(
            sortState: sortState,
            onSort: onSort,
          ),
          tbody([
            for (final payment in sortedPayments)
              PaymentTableRow(
                orderReference: payment.orderReference,
                date: _formatDate(payment.date),
                orderId: payment.orderId,
                orderAmount: payment.orderAmount,
                discountAmount: payment.discountAmount,
                paidAmount: payment.paidAmount,
                paymentType: PaymentFormatter.formatPaymentType(
                  payment.paymentMode,
                ),
                paymentStatus: PaymentFormatter.formatPaymentStatus(
                  payment.paymentStatus,
                ),
              ),
          ]),
        ],
      ),
    ]);
  }
}
