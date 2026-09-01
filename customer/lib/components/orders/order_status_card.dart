import 'package:customer/components/orders/order_status_payment_summary.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;
import 'package:models/models.dart';

class OrderStatusCard extends StatelessComponent {
  final Order order;
  final String? storeSlug;
  final VoidCallback onShowQr;
  final VoidCallback onBackToMenu;

  const OrderStatusCard({
    super.key,
    required this.order,
    this.storeSlug,
    required this.onShowQr,
    required this.onBackToMenu,
  });

  String get _paymentMethodLabel => switch (order.paymentMethod) {
    PaymentMethod.cash => 'Cash',
    PaymentMethod.complimentary => 'Complimentary',
    _ => 'Online Payment',
  };

  @override
  Component build(BuildContext context) {
    final isCompleted = order.paymentStatus == PaymentStatus.completed;
    final isFailed =
        order.paymentStatus == PaymentStatus.failed ||
        order.status == OrderStatus.cancelled;

    final iconBgClass = isCompleted
        ? 'w-20 h-20 rounded-full bg-emerald-50 text-emerald-600 flex items-center justify-center'
        : (isFailed
              ? 'w-20 h-20 rounded-full bg-red-50 text-red-600 flex items-center justify-center'
              : 'w-20 h-20 rounded-full bg-amber-50 text-amber-600 flex items-center justify-center');

    final titleText = isCompleted
        ? 'Order Confirmed!'
        : (isFailed ? 'Payment Failed / Cancelled' : 'Payment Pending');

    final statusTextClass = isCompleted
        ? 'font-bold text-emerald-600'
        : (isFailed ? 'font-bold text-red-600' : 'font-bold text-amber-600');

    return div(
      classes: 'bg-white rounded-3xl p-6 sm:p-8 border border-gray-200/80 shadow-sm flex flex-col items-center text-center gap-5 w-full',
      [
        div(classes: iconBgClass, [
          if (isCompleted)
            Check(classes: 'w-10 h-10 text-emerald-600')
          else if (isFailed)
            X(classes: 'w-10 h-10 text-red-600')
          else
            Clock(classes: 'w-10 h-10 text-amber-600'),
        ]),
        h1(classes: 'text-3xl font-black text-black tracking-tight', [
          .text(titleText),
        ]),
        p(
          classes: 'text-sm text-gray-500 font-medium flex flex-col items-center gap-0.5',
          [
            span(classes: 'font-extrabold text-black text-base', [
              .text('Order No: #${order.billNo}'),
            ]),
            span(classes: 'text-xs text-gray-400 font-mono', [
              .text('Reference: ${order.orderReference}'),
            ]),
          ],
        ),
        div(classes: 'w-full border-t border-gray-100 my-2', []),
        div(classes: 'w-full flex flex-col gap-3 text-left', [
          h3(
            classes:
                'text-sm font-extrabold text-black uppercase tracking-wider',
            [.text('Order Items')],
          ),
          ...order.items.map(
            (item) => div(
              classes: 'flex justify-between items-center text-sm',
              [
                div(
                  classes: 'flex items-center gap-2 text-gray-800 font-medium',
                  [
                    span(classes: 'font-bold text-black', [
                      .text('${item.quantity}x'),
                    ]),
                    span([.text(item.product?.name ?? 'Product')]),
                  ],
                ),
                span(classes: 'font-semibold text-black', [
                  .text(
                    '₹${(item.unitPrice * item.quantity).toStringAsFixed(2)}',
                  ),
                ]),
              ],
            ),
          ),
        ]),
        div(classes: 'w-full border-t border-dashed border-gray-200 my-2', []),
        OrderStatusPaymentSummary(
          order: order,
          paymentMethodLabel: _paymentMethodLabel,
          statusTextClass: statusTextClass,
        ),
        if (isCompleted && order.status != OrderStatus.completed) ...[
          button(
            classes: 'w-full mt-2 py-3.5 rounded-2xl bg-emerald-50 hover:bg-emerald-600 text-emerald-700 hover:text-white border border-emerald-200/60 font-bold text-sm flex items-center justify-center gap-2 cursor-pointer transition-all shadow-xs active:scale-98',
            onClick: onShowQr,
            [QrCode(classes: 'w-4 h-4'), .text('Display Order QR')],
          ),
        ],
        button(
          classes: 'w-full mt-2 py-3.5 rounded-2xl bg-gray-100 hover:bg-gray-200 text-gray-900 font-bold text-sm flex items-center justify-center gap-2 cursor-pointer transition-all border-0 active:scale-98',
          onClick: onBackToMenu,
          [.text('Back to Store Menu'), ArrowRight(classes: 'w-4 h-4')],
        ),
      ],
    );
  }
}
