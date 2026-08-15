import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';

class StockSummaryTableRow extends StatelessComponent {
  final StockSummaryItem item;

  const StockSummaryTableRow({super.key, required this.item});

  @override
  Component build(BuildContext context) {
    return tr([
      th([]),
      th(classes: 'whitespace-nowrap font-semibold text-black no-underline', [
        .text(item.productName),
      ]),
      td([.text('${item.openingStock}')]),
      td([
        if (item.inQuantity > 0)
          span(classes: 'text-emerald-600 font-semibold', [
            .text('+${item.inQuantity}'),
          ])
        else
          .text('-'),
      ]),
      td([
        if (item.outQuantity > 0)
          span(classes: 'text-rose-600 font-semibold', [
            .text('-${item.outQuantity}'),
          ])
        else
          .text('-'),
      ]),
      td([
        if (item.wastageQuantity > 0)
          span(classes: 'text-amber-600 font-semibold', [
            .text('-${item.wastageQuantity}'),
          ])
        else
          .text('-'),
      ]),
      td([
        if (item.adjustmentQuantity != 0)
          span(
            classes: item.adjustmentQuantity > 0
                ? 'text-emerald-600 font-semibold'
                : 'text-rose-600 font-semibold',
            [
              .text(
                item.adjustmentQuantity > 0
                    ? '+${item.adjustmentQuantity}'
                    : '${item.adjustmentQuantity}',
              ),
            ],
          )
        else
          .text('-'),
      ]),
      td(classes: 'font-bold text-gray-900', [.text('${item.closingStock}')]),
      th([]),
    ]);
  }
}
