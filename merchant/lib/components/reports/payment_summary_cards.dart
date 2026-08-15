import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class PaymentSummaryCards extends StatelessComponent {
  final double cashCollected;
  final double upiCollected;
  final double freeTotal;
  final double totalCollected;

  const PaymentSummaryCards({
    super.key,
    required this.cashCollected,
    required this.upiCollected,
    required this.freeTotal,
    required this.totalCollected,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'grid grid-cols-2 lg:grid-cols-4 gap-3 p-4 border-b border-border-medium bg-neutral/20',
      [
        _summaryCard(
          title: 'Cash Collected',
          value: '₹${cashCollected.toStringAsFixed(2)}',
          textColor: 'text-blue-600',
        ),
        _summaryCard(
          title: 'UPI Collected',
          value: '₹${upiCollected.toStringAsFixed(2)}',
          textColor: 'text-purple-600',
        ),
        _summaryCard(
          title: 'Free / Complimentary',
          value: '₹${freeTotal.toStringAsFixed(2)}',
          textColor: 'text-gray-900',
        ),
        _summaryCard(
          title: 'Total Collected',
          value: '₹${totalCollected.toStringAsFixed(2)}',
          textColor: 'text-emerald-600',
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
