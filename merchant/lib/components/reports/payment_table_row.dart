import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class PaymentTableRow extends StatelessComponent {
  final String orderReference;
  final String date;
  final String orderId;
  final double orderAmount;
  final double discountAmount;
  final double paidAmount;
  final String paymentType;
  final (String label, String badgeClass) paymentStatus;

  const PaymentTableRow({
    super.key,
    required this.orderReference,
    required this.date,
    required this.orderId,
    required this.orderAmount,
    required this.discountAmount,
    required this.paidAmount,
    required this.paymentType,
    required this.paymentStatus,
  });

  @override
  Component build(BuildContext context) {
    final isCash = paymentType == 'CASH';

    return tr([
      th([]),
      th(classes: 'font-mono text-xs font-semibold text-black', [
        .text(orderReference),
      ]),
      td(classes: 'whitespace-nowrap', [.text(date)]),
      td(classes: 'font-medium', [.text('#$orderId')]),
      td([.text(orderAmount.toStringAsFixed(2))]),
      td([
        if (discountAmount > 0)
          span(classes: 'text-rose-600 font-medium', [
            .text('-${discountAmount.toStringAsFixed(2)}'),
          ])
        else
          .text('-'),
      ]),
      td(classes: 'font-bold text-gray-900', [
        .text(paidAmount.toStringAsFixed(2)),
      ]),
      td([
        div(
          classes:
              '${isCash ? 'bg-soft-blue text-soft-blue-content' : 'bg-soft-purple text-soft-purple-content'} rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
          [
            .text(paymentType),
          ],
        ),
      ]),
      td([
        div(
          classes:
              '${paymentStatus.$2} rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
          [
            .text(paymentStatus.$1),
          ],
        ),
      ]),
      th([]),
    ]);
  }
}
