import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class ProfitLossSummaryCards extends StatelessComponent {
  final double totalCostPrice;
  final double totalCollectedPrice;
  final double totalProfit;
  final double totalMarginPercentage;

  const ProfitLossSummaryCards({
    super.key,
    required this.totalCostPrice,
    required this.totalCollectedPrice,
    required this.totalProfit,
    required this.totalMarginPercentage,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'grid grid-cols-2 lg:grid-cols-4 gap-3 p-4 border-b border-border-medium bg-neutral/20',
      [
        _summaryCard(
          title: 'Total Cost Price (COGS)',
          value: '₹${totalCostPrice.toStringAsFixed(2)}',
          textColor: 'text-gray-900',
        ),
        _summaryCard(
          title: 'Total Net Revenue',
          value: '₹${totalCollectedPrice.toStringAsFixed(2)}',
          textColor: 'text-gray-900',
        ),
        _summaryCard(
          title: 'Net Profit / Loss',
          value: '₹${totalProfit.toStringAsFixed(2)}',
          textColor: totalProfit >= 0 ? 'text-emerald-600' : 'text-rose-600',
        ),
        _summaryCard(
          title: 'Overall Margin',
          value: '${totalMarginPercentage.toStringAsFixed(2)}%',
          textColor: totalMarginPercentage >= 0
              ? 'text-emerald-600'
              : 'text-rose-600',
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
