import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

class OrderDetailsModal extends StatelessComponent {
  final AsyncState<Order?> state;

  const OrderDetailsModal({super.key, required this.state});

  String _formatAmount(double amount) {
    if (amount % 1 == 0) {
      return '${amount.toInt()}';
    }
    return amount.toStringAsFixed(2);
  }

  @override
  Component build(BuildContext context) {
    return Modal(
      title: 'Orders Details',
      maxWidthClass: 'max-w-xl',
      child: () {
        if (state.isLoading) {
          return const Loading(
            text: 'Loading order details...',
            fullScreen: false,
          );
        }
        if (state.hasError) {
          return const CenteredMessage(
            message: 'Failed to load order details.',
          );
        }
        final order = state.value;
        if (order == null) {
          return const CenteredMessage(message: 'Order details not found.');
        }

        final totalQuantity = order.items.fold<int>(
          0,
          (sum, item) => sum + item.quantity,
        );

        return div(classes: 'flex flex-col gap-6 pt-2 pb-1', [
          // Main Table Card
          div(
            classes:
                'border border-gray-200/90 rounded-2xl overflow-hidden bg-white shadow-2xs',
            [
              table(classes: 'w-full text-left border-collapse', [
                thead([
                  tr(
                    classes:
                        'bg-gray-50/80 border-b border-gray-200/90 text-xs font-semibold text-gray-500',
                    [
                      th(
                        classes:
                            'py-3.5 px-4 text-center font-semibold text-gray-500',
                        [.text('S.No')],
                      ),
                      th(
                        classes: 'py-3.5 px-4 font-semibold text-gray-500',
                        [.text('Name')],
                      ),
                      th(
                        classes:
                            'py-3.5 px-4 text-center font-semibold text-gray-500',
                        [.text('Quantity')],
                      ),
                      th(
                        classes:
                            'py-3.5 px-4 text-right font-semibold text-gray-500',
                        [.text('Price(₹)')],
                      ),
                      th(
                        classes:
                            'py-3.5 px-4 text-right font-semibold text-gray-500',
                        [.text('Total Price(₹)')],
                      ),
                    ],
                  ),
                ]),
                tbody([
                  for (var i = 0; i < order.items.length; i++)
                    tr(
                      classes:
                          'text-sm text-gray-800 border-b border-gray-100 last:border-b-0 hover:bg-gray-50/50',
                      [
                        td(
                          classes:
                              'py-3.5 px-4 text-center font-normal text-gray-700',
                          [
                            .text('${i + 1}'),
                          ],
                        ),
                        td(classes: 'py-3.5 px-4 font-semibold text-gray-900', [
                          .text(order.items[i].product?.name ?? 'Item'),
                        ]),
                        td(
                          classes:
                              'py-3.5 px-4 text-center font-normal text-gray-700',
                          [
                            .text('${order.items[i].quantity}'),
                          ],
                        ),
                        td(
                          classes:
                              'py-3.5 px-4 text-right font-normal text-gray-700',
                          [
                            .text(_formatAmount(order.items[i].unitPrice)),
                          ],
                        ),
                        td(
                          classes:
                              'py-3.5 px-4 text-right font-semibold text-gray-900',
                          [
                            .text(
                              _formatAmount(
                                order.items[i].quantity *
                                    order.items[i].unitPrice,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ]),
              ]),
            ],
          ),

          // Divider
          div(classes: 'border-t border-gray-200/60 w-full', []),

          // Summary Breakdown
          div(classes: 'flex flex-col gap-3 px-1 text-sm text-gray-800', [
            div(classes: 'flex justify-between items-center', [
              span(classes: 'font-normal text-gray-800', [
                .text('Total No Of Items'),
              ]),
              span(classes: 'font-medium text-gray-900', [
                .text('${order.items.length}'),
              ]),
            ]),
            div(classes: 'flex justify-between items-center', [
              span(classes: 'font-normal text-gray-800', [
                .text('Total Order Quantity'),
              ]),
              span(classes: 'font-medium text-gray-900', [
                .text('$totalQuantity'),
              ]),
            ]),
            div(classes: 'flex justify-between items-center', [
              span(classes: 'font-normal text-gray-800', [.text('Sub Total')]),
              span(classes: 'font-medium text-gray-900', [
                .text('Rs. ${_formatAmount(order.subtotal)}'),
              ]),
            ]),
            div(classes: 'flex justify-between items-center', [
              span(classes: 'font-normal text-gray-800', [
                .text('Total Discount'),
              ]),
              span(classes: 'font-medium text-gray-900', [
                .text('Rs. ${_formatAmount(order.discountTotal)}'),
              ]),
            ]),
            div(classes: 'flex justify-between items-center', [
              span(classes: 'font-normal text-gray-800', [.text('Total Tax')]),
              span(classes: 'font-medium text-gray-900', [
                .text('Rs. ${_formatAmount(order.taxTotal)}'),
              ]),
            ]),
            div(
              classes:
                  'flex justify-between items-center text-base font-bold text-gray-900 pt-1',
              [
                span([.text('Grand Total')]),
                span([.text('Rs. ${_formatAmount(order.grandTotal)}')]),
              ],
            ),
          ]),
        ]);
      }(),
    );
  }
}
