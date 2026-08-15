import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';

/// Itemized products table rendered within order details modal.
class OrderItemsTableView extends StatelessComponent {
  final List<OrderItem> items;
  final String Function(double) formatAmount;

  const OrderItemsTableView({
    super.key,
    required this.items,
    required this.formatAmount,
  });

  @override
  Component build(BuildContext context) {
    return div(
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
                  classes: 'py-3.5 px-4 text-center font-semibold text-gray-500',
                  [.text('S.No')],
                ),
                th(
                  classes: 'py-3.5 px-4 font-semibold text-gray-500',
                  [.text('Name')],
                ),
                th(
                  classes: 'py-3.5 px-4 text-center font-semibold text-gray-500',
                  [.text('Quantity')],
                ),
                th(
                  classes: 'py-3.5 px-4 text-right font-semibold text-gray-500',
                  [.text('Price')],
                ),
                th(
                  classes: 'py-3.5 px-4 text-right font-semibold text-gray-500',
                  [.text('Total')],
                ),
              ],
            ),
          ]),
          tbody([
            for (var i = 0; i < items.length; i++)
              tr(
                classes:
                    'border-b border-gray-100 last:border-0 hover:bg-gray-50/50 text-sm',
                [
                  td(
                    classes: 'py-3.5 px-4 text-center text-xs font-medium text-gray-400',
                    [.text('${i + 1}')],
                  ),
                  td(classes: 'py-3.5 px-4 font-semibold text-gray-900', [
                    .text(items[i].product?.name ?? 'Item'),
                  ]),
                  td(
                    classes: 'py-3.5 px-4 text-center font-normal text-gray-700',
                    [
                      .text('${items[i].quantity}'),
                    ],
                  ),
                  td(
                    classes: 'py-3.5 px-4 text-right font-normal text-gray-700',
                    [
                      .text(formatAmount(items[i].unitPrice)),
                    ],
                  ),
                  td(
                    classes: 'py-3.5 px-4 text-right font-semibold text-gray-900',
                    [
                      .text(
                        formatAmount(items[i].quantity * items[i].unitPrice),
                      ),
                    ],
                  ),
                ],
              ),
          ]),
        ]),
      ],
    );
  }
}
