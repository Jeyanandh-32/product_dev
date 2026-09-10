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

  static const List<({String label, StockTransactionReason value})> _items = [
    (label: 'Wastage / Damaged Goods', value: StockTransactionReason.wastage),
    (
      label: 'Inventory Adjustment / Shrinkage',
      value: StockTransactionReason.adjustment,
    ),
  ];

  @override
  Component build(BuildContext context) {
    final validReason = _items.any((item) => item.value == reason)
        ? reason
        : _items.first.value;

    return div(classes: 'flex flex-col gap-4 mb-4', [
      div(classes: 'flex flex-col gap-1.5', [
        label(classes: 'text-[14px] font-semibold text-slate-700', [
          .text('Reason for Reduction / Adjustment'),
        ]),
        select(
          classes: 'select h-[42px] border border-border-medium bg-white w-full rounded-[10px] text-sm text-slate-900',
          events: {
            'change': (e) {
              final target = e.target as HTMLSelectElement;
              onReasonChanged(
                StockTransactionReason.values.byName(target.value),
              );
            },
          },
          _items
              .map(
                (item) => option(
                  value: item.value.name,
                  selected: validReason == item.value,
                  [.text(item.label)],
                ),
              )
              .toList(),
        ),
        if (validReason == StockTransactionReason.wastage)
          p(classes: 'text-xs text-rose-500 font-medium mt-1', [
            .text(
              '⚠️ Wasted items will be recorded as inventory loss in Profit & Loss report.',
            ),
          ]),
      ]),
      div(classes: 'flex flex-col gap-1.5', [
        label(classes: 'text-[14px] font-semibold text-slate-700', [
          .text('Reason Description (Optional)'),
        ]),
        input(
          type: .text,
          classes: 'input h-[42px] border border-border-medium bg-white w-full rounded-[10px] text-sm text-slate-900',
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
