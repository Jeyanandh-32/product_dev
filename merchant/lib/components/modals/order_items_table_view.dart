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
      classes: 'border border-border-medium rounded-xl overflow-x-auto bg-white shadow-2xs',
      [
        table(classes: 'w-full text-left border-collapse whitespace-nowrap', [
          thead([
            tr(
              classes: 'bg-slate-50 border-b border-border-medium text-xs font-semibold text-slate-500',
              [
                th(
                  classes:
                      'py-3.5 px-4 text-center font-semibold text-slate-500',
                  [.text('S.No')],
                ),
                th(
                  classes: 'py-3.5 px-4 font-semibold text-slate-500',
                  [.text('Name')],
                ),
                th(
                  classes:
                      'py-3.5 px-4 text-center font-semibold text-slate-500',
                  [.text('Quantity')],
                ),
                th(
                  classes:
                      'py-3.5 px-4 text-right font-semibold text-slate-500',
                  [.text('Price')],
                ),
                th(
                  classes:
                      'py-3.5 px-4 text-right font-semibold text-slate-500',
                  [.text('Total')],
                ),
              ],
            ),
          ]),
          tbody([
            for (var i = 0; i < items.length; i++)
              tr(
                classes: 'border-b border-border-light last:border-0 hover:bg-slate-50/50 text-sm',
                [
                  td(
                    classes: 'py-3.5 px-4 text-center text-xs font-medium text-slate-400',
                    [.text('${i + 1}')],
                  ),
                  td(classes: 'py-3.5 px-4 font-semibold text-slate-900', [
                    .text(items[i].product?.name ?? 'Item'),
                  ]),
                  td(
                    classes:
                        'py-3.5 px-4 text-center font-normal text-slate-700',
                    [
                      .text('${items[i].quantity}'),
                    ],
                  ),
                  td(
                    classes:
                        'py-3.5 px-4 text-right font-normal text-slate-700',
                    [
                      .text(formatAmount(items[i].unitPrice)),
                    ],
                  ),
                  td(
                    classes:
                        'py-3.5 px-4 text-right font-semibold text-slate-900',
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
