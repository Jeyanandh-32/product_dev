import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:models/models.dart';

/// Card component displaying a high-level summary of a customer order.
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

    final formattedDate = AppDateFormatter.formatDate(order.createdAt);
    final formattedTime = AppDateFormatter.formatTime(order.createdAt);

    final totalItemsCount = order.items.length;
    final totalQuantity = order.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    return div(
      classes: 'bg-white rounded-3xl p-5 border border-gray-200/90 shadow-2xs hover:border-black transition-all flex flex-col justify-between gap-5',
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

        // Order Summary Info Row
        div(
          classes: 'bg-gray-50/60 rounded-2xl px-4 py-3 flex items-center justify-between border border-gray-100 text-xs',
          [
            div(classes: 'flex items-center gap-1.5 text-gray-600 font-medium', [
              ShoppingBag(classes: 'w-4 h-4 text-gray-400'),
              span([
                .text(
                  '$totalItemsCount ${totalItemsCount == 1 ? 'item' : 'items'} ($totalQuantity ${totalQuantity == 1 ? 'unit' : 'units'})',
                ),
              ]),
            ]),
            div(classes: 'flex items-center gap-1.5', [
              span(
                classes: 'text-xs text-gray-500 font-medium',
                [.text('Total:')],
              ),
              span(
                classes: 'text-base font-extrabold text-black font-mono tracking-tight',
                [
                  .text('₹${order.grandTotal.toStringAsFixed(2)}'),
                ],
              ),
            ]),
          ],
        ),

        // Bottom Action Buttons
        div(
          classes:
              'flex items-center gap-2 w-full pt-1 border-t border-gray-100',
          [
            button(
              classes: 'flex-1 justify-center flex items-center gap-1.5 px-4 py-2.5 rounded-xl bg-emerald-50 hover:bg-emerald-600 text-emerald-700 hover:text-white border border-emerald-200/60 hover:border-emerald-600 font-bold text-xs transition-all cursor-pointer active:scale-95 shadow-2xs',
              onClick: onShowQr,
              [
                QrCode(classes: 'w-3.5 h-3.5'),
                .text('View QR'),
              ],
            ),

            button(
              classes: showQrButton
                  ? 'flex-1 justify-center flex items-center gap-1.5 px-4 py-2.5 rounded-xl bg-gray-100 hover:bg-black hover:text-white text-gray-800 font-bold text-xs transition-all cursor-pointer border-0 active:scale-95'
                  : 'w-full justify-center flex items-center gap-1.5 px-4 py-2.5 rounded-xl bg-gray-100 hover:bg-black hover:text-white text-gray-800 font-bold text-xs transition-all cursor-pointer border-0 active:scale-95',
              onClick: () => Router.of(
                context,
              ).push('/order/status?reference=${order.orderReference}'),
              [
                .text('View Details'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
