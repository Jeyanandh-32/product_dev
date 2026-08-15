import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';
import 'package:web/web.dart';

class StockReasonSection extends StatelessComponent {
  final StockTransactionReason reason;
  final String customReason;
  final ValueChanged<StockTransactionReason> onReasonChanged;
  final ValueChanged<String> onCustomReasonChanged;

  const StockReasonSection({
    super.key,
    required this.reason,
    required this.customReason,
    required this.onReasonChanged,
    required this.onCustomReasonChanged,
  });

  @override
  Component build(BuildContext context) {
    return div(classes: 'flex flex-col gap-4 mb-4', [
      div(classes: 'flex flex-col gap-1.5', [
        label(classes: 'text-[14px] font-semibold text-gray-700', [
          .text('Reason for Adjustment'),
        ]),
        select(
          classes:
              'select select-bordered w-full rounded-xl text-sm border-border-medium focus:outline-hidden',
          events: {
            'change': (e) {
              final target = e.target as HTMLSelectElement;
              onReasonChanged(
                StockTransactionReason.values.byName(target.value),
              );
            },
          },
          [
            option(
              value: StockTransactionReason.adjustment.name,
              selected: reason == StockTransactionReason.adjustment,
              [.text('Inventory Adjustment / Audit')],
            ),
            option(
              value: StockTransactionReason.wastage.name,
              selected: reason == StockTransactionReason.wastage,
              [.text('Wastage / Damaged Goods')],
            ),
          ],
        ),
        if (reason == StockTransactionReason.wastage)
          p(classes: 'text-xs text-rose-500 font-medium mt-1', [
            .text(
              '⚠️ Wasted items will be recorded as inventory loss in Profit & Loss report.',
            ),
          ]),
      ]),

      div(classes: 'flex flex-col gap-1.5', [
        label(classes: 'text-[14px] font-semibold text-gray-700', [
          .text('Reason Description (Optional)'),
        ]),
        input(
          type: .text,
          classes:
              'input input-bordered w-full rounded-xl text-sm border-border-medium focus:outline-hidden',
          attributes: {
            'placeholder':
                'e.g. Expired on 04/08, Damaged in shipping (Optional)',
            'value': customReason,
          },
          onInput: (val) => onCustomReasonChanged(val as String? ?? ''),
        ),
      ]),
    ]);
  }
}
