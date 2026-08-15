import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:models/models.dart';

class OrderTile extends StatelessComponent {
  final Order order;
  final VoidCallback onShowQr;

  const OrderTile({
    super.key,
    required this.order,
    required this.onShowQr,
  });

  @override
  Component build(BuildContext context) {
    final isOrderCompleted = order.status == OrderStatus.completed;
    final showQrButton = !isOrderCompleted;

    final createdAt = order.createdAt;
    final formattedDate =
        '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}';
    final formattedTime =
        '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';

    return div(
      classes:
          'bg-white rounded-3xl p-5 border border-gray-200/90 shadow-2xs hover:border-black transition-all flex flex-col justify-between gap-4',
      [
        // Top Header Row: Order Number & Status Pill
        div(classes: 'flex items-center justify-between gap-2', [
          div(classes: 'flex items-center gap-3', [
            div(
              classes:
                  'w-10 h-10 rounded-2xl ${isOrderCompleted ? 'bg-emerald-50 text-emerald-600' : 'bg-amber-50 text-amber-600'} flex items-center justify-center font-bold text-sm shrink-0',
              [
                if (isOrderCompleted)
                  Check(classes: 'w-5 h-5')
                else
                  Clock(classes: 'w-5 h-5'),
              ],
            ),
            div(classes: 'flex flex-col min-w-0', [
              h3(
                classes: 'text-sm font-extrabold text-black truncate',
                [
                  .text('Order #${order.billNo}'),
                ],
              ),
              span(classes: 'text-xs text-gray-500 font-medium', [
                .text('$formattedDate at $formattedTime'),
              ]),
            ]),
          ]),

          span(
            classes: isOrderCompleted
                ? 'px-2.5 py-1 rounded-full text-xs font-bold bg-emerald-50 text-emerald-700 border border-emerald-200'
                : 'px-2.5 py-1 rounded-full text-xs font-bold bg-amber-50 text-amber-700 border border-amber-200',
            [
              .text(isOrderCompleted ? 'COMPLETED' : 'PENDING'),
            ],
          ),
        ]),

        // Items Summary Box
        div(
          classes:
              'bg-gray-50/60 rounded-2xl p-3.5 flex flex-col gap-2 border border-gray-100',
          [
            for (final item in order.items.take(3))
              div(
                classes: 'flex items-center justify-between text-xs font-medium',
                [
                  div(classes: 'flex items-center gap-2 text-gray-800', [
                    span(
                      classes: 'font-bold text-black min-w-4',
                      [.text('${item.quantity}×')],
                    ),
                    span(
                      classes: 'text-gray-700 truncate max-w-45 sm:max-w-xs',
                      [.text(item.product?.name ?? 'Item')],
                    ),
                  ]),
                  span(classes: 'text-gray-500 font-semibold', [
                    .text(
                      '₹${(item.unitPrice * item.quantity).toStringAsFixed(2)}',
                    ),
                  ]),
                ],
              ),
            if (order.items.length > 3)
              span(classes: 'text-[11px] font-bold text-gray-400 italic', [
                .text('+ ${order.items.length - 3} more items'),
              ]),
          ],
        ),

        // Bottom Tile Row: Total Amount & Equal-Width Action Buttons
        div(
          classes:
              'flex flex-col sm:flex-row sm:items-center justify-between gap-3 pt-1 border-t border-gray-100',
          [
            div(classes: 'flex items-center gap-1.5', [
              span(
                classes: 'text-xs text-gray-500 font-medium',
                [.text('Total Amount:')],
              ),
              span(classes: 'text-base font-extrabold text-black', [
                .text('₹${order.grandTotal.toStringAsFixed(2)}'),
              ]),
            ]),

            div(classes: 'flex items-center gap-2 w-full sm:w-auto', [
              if (showQrButton)
                button(
                  classes:
                      'flex-1 sm:flex-none sm:w-32 justify-center flex items-center gap-1.5 px-4 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs transition-all cursor-pointer border-0 active:scale-95 shadow-2xs',
                  onClick: onShowQr,
                  [
                    QrCode(classes: 'w-3.5 h-3.5 text-white'),
                    .text('View QR'),
                  ],
                ),

              button(
                classes: showQrButton
                    ? 'flex-1 sm:flex-none sm:w-32 justify-center flex items-center gap-1.5 px-4 py-2 rounded-xl bg-gray-100 hover:bg-black hover:text-white text-gray-800 font-bold text-xs transition-all cursor-pointer border-0 active:scale-95'
                    : 'w-full sm:w-36 justify-center flex items-center gap-1.5 px-4 py-2 rounded-xl bg-gray-100 hover:bg-black hover:text-white text-gray-800 font-bold text-xs transition-all cursor-pointer border-0 active:scale-95',
                onClick: () => Router.of(
                  context,
                ).push('/order/status?reference=${order.orderReference}'),
                [
                  .text('View Details'),
                ],
              ),
            ]),
          ],
        ),
      ],
    );
  }
}
