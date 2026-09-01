import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';

/// Row rendering for an order entry in merchant orders table.
class OrderTableRow extends StatelessComponent {
  final String orderReference;
  final String date;
  final String orderId;
  final double grossAmount;
  final double discountAmount;
  final double platformFee;
  final double walletAmount;
  final double netAmount;
  final String paymentType;
  final PaymentStatus paymentStatus;
  final String status;
  final VoidCallback? onClick;

  const OrderTableRow({
    super.key,
    required this.orderReference,
    required this.date,
    required this.orderId,
    required this.grossAmount,
    required this.discountAmount,
    this.platformFee = 0.0,
    required this.walletAmount,
    required this.netAmount,
    required this.paymentType,
    required this.paymentStatus,
    required this.status,
    this.onClick,
  });

  @override
  Component build(BuildContext context) {
    final isCash = paymentType == 'CASH';

    return tr(
      classes: 'hover:cursor-pointer',
      events: {
        if (onClick != null) 'click': (e) => onClick!(),
      },
      [
        th([]),
        th(
          classes: 'font-mono text-xs font-semibold text-black no-underline whitespace-nowrap',
          [
            .text(orderReference),
          ],
        ),
        td(classes: 'whitespace-nowrap', [.text(date)]),
        td(classes: 'whitespace-nowrap font-medium', [.text('#$orderId')]),
        td([.text(grossAmount.toStringAsFixed(2))]),
        td([
          if (discountAmount > 0)
            span(classes: 'text-rose-600 font-medium', [
              .text('-${discountAmount.toStringAsFixed(2)}'),
            ])
          else
            .text('-'),
        ]),
        td([
          if (platformFee > 0)
            span(classes: 'text-gray-700 font-medium', [
              .text(platformFee.toStringAsFixed(2)),
            ])
          else
            .text('-'),
        ]),
        td([
          if (walletAmount > 0)
            span(classes: 'text-amber-700 font-medium', [
              .text('₹${walletAmount.toStringAsFixed(2)}'),
            ])
          else
            .text('-'),
        ]),
        td(classes: 'font-bold text-gray-900', [
          .text(netAmount.toStringAsFixed(2)),
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
            classes: switch (paymentStatus) {
              PaymentStatus.completed => 'bg-soft-green text-soft-green-content rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
              PaymentStatus.pending => 'bg-soft-yellow text-soft-yellow-content rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
              PaymentStatus.failed => 'bg-soft-red text-soft-red-content rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
            },
            [
              .text(paymentStatus.name.toUpperCase()),
            ],
          ),
        ]),
        td([
          div(
            classes: switch (status) {
              'COMPLETED' => 'bg-soft-green text-soft-green-content rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
              'CANCELLED' => 'bg-soft-red text-soft-red-content rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
              _ => 'bg-soft-yellow text-soft-yellow-content rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
            },
            [
              .text(status),
            ],
          ),
        ]),
        th([]),
      ],
    );
  }
}
