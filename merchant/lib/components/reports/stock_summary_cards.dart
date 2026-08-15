import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class StockSummaryCards extends StatelessComponent {
  final int totalIn;
  final int totalOut;
  final int totalWastage;
  final int totalAdjustment;

  const StockSummaryCards({
    super.key,
    required this.totalIn,
    required this.totalOut,
    required this.totalWastage,
    required this.totalAdjustment,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'grid grid-cols-2 lg:grid-cols-4 gap-3 p-4 border-b border-border-medium bg-neutral/20',
      [
        _summaryCard(
          title: 'Restocked (In)',
          value: '+$totalIn',
          textColor: 'text-emerald-600',
        ),
        _summaryCard(
          title: 'Sold (Out)',
          value: '-$totalOut',
          textColor: 'text-rose-600',
        ),
        _summaryCard(
          title: 'Wastage',
          value: '-$totalWastage',
          textColor: 'text-amber-600',
        ),
        _summaryCard(
          title: 'Adjustment',
          value: totalAdjustment > 0 ? '+$totalAdjustment' : '$totalAdjustment',
          textColor: totalAdjustment != 0
              ? (totalAdjustment > 0 ? 'text-emerald-600' : 'text-rose-600')
              : 'text-gray-700',
        ),
      ],
    );
  }

  Component _summaryCard({
    required String title,
    required String value,
    required String textColor,
  }) {
    return div(
      classes:
          'flex flex-col gap-1 p-3.5 bg-white rounded-xl border border-border-medium shadow-2xs',
      [
        span(classes: 'text-xs text-gray-500 font-medium', [.text(title)]),
        span(classes: 'text-lg font-bold $textColor', [.text(value)]),
      ],
    );
  }
}
