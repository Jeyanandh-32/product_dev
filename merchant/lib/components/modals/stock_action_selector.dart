import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';

/// Segmented button selector for stock transaction operations: Add, Reduce, and Set.
class StockActionSelector extends StatelessComponent {
  final StockTransactionType selectedType;
  final ValueChanged<StockTransactionType> onTypeChanged;

  const StockActionSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Component build(BuildContext context) {
    return div(classes: 'flex flex-col gap-1.5 mb-4', [
      label(classes: 'text-[14px] font-semibold text-gray-700', [
        .text('Stock Action'),
      ]),
      div(classes: 'grid grid-cols-3 gap-2', [
        _operationButton(
          label: 'Add Stock (+)',
          value: StockTransactionType.add,
          colorClass: selectedType == StockTransactionType.add
              ? 'bg-emerald-600 text-white font-bold'
              : 'bg-white border border-border-medium hover:bg-neutral text-gray-700',
        ),
        _operationButton(
          label: 'Reduce (-)',
          value: StockTransactionType.reduce,
          colorClass: selectedType == StockTransactionType.reduce
              ? 'bg-rose-600 text-white font-bold'
              : 'bg-white border border-border-medium hover:bg-neutral text-gray-700',
        ),
        _operationButton(
          label: 'Set Exact (=)',
          value: StockTransactionType.set,
          colorClass: selectedType == StockTransactionType.set
              ? 'bg-primary text-white font-bold'
              : 'bg-white border border-border-medium hover:bg-neutral text-gray-700',
        ),
      ]),
    ]);
  }

  Component _operationButton({
    required String label,
    required StockTransactionType value,
    required String colorClass,
  }) {
    return button(
      type: .button,
      classes:
          'py-2.5 px-2 text-xs rounded-xl transition-all cursor-pointer text-center $colorClass',
      events: {
        'click': (e) => onTypeChanged(value),
      },
      [.text(label)],
    );
  }
}
