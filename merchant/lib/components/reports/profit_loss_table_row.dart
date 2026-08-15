import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';

class ProfitLossTableRow extends StatelessComponent {
  final ProfitLossItem item;

  const ProfitLossTableRow({super.key, required this.item});

  @override
  Component build(BuildContext context) {
    final isPositive = item.profit >= 0;

    return tr([
      th([]),
      th(classes: 'whitespace-nowrap font-semibold text-black no-underline', [
        .text(item.productName),
      ]),
      td(classes: 'whitespace-nowrap font-medium text-gray-700', [
        .text(item.categoryName),
      ]),
      td(classes: 'whitespace-nowrap font-medium text-gray-700', [
        .text(item.counterName),
      ]),
      td([.text('${item.soldQuantity}')]),
      td([.text(item.costPrice.toStringAsFixed(2))]),
      td([.text(item.collectedPrice.toStringAsFixed(2))]),
      td([
        span(
          classes: isPositive
              ? 'text-emerald-600 font-semibold'
              : 'text-rose-600 font-semibold',
          [
            .text(
              isPositive
                  ? '+${item.profit.toStringAsFixed(2)}'
                  : item.profit.toStringAsFixed(2),
            ),
          ],
        ),
      ]),
      td([
        div(
          classes:
              '${isPositive ? 'bg-soft-green text-soft-green-content' : 'bg-soft-red text-soft-red-content'} rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
          [
            .text('${item.profitLossPercentage.toStringAsFixed(2)}%'),
          ],
        ),
      ]),
      th([]),
    ]);
  }
}
