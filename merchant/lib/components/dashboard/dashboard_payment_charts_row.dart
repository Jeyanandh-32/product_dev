import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/dashboard/payment_method_chart_card.dart';
import 'package:merchant/components/dashboard/payment_status_chart_card.dart';

/// Side-by-side distribution charts for payment methods (UPI/Cash) and status (Paid/Free).
class DashboardPaymentChartsRow extends StatelessComponent {
  final double totalRevenue;
  final int upiPercent;
  final double upiTotal;
  final int cashPercent;
  final double cashTotal;
  final int totalOrdersCount;
  final int paidPercent;
  final int paidCount;
  final int freePercent;
  final int freeCount;

  const DashboardPaymentChartsRow({
    super.key,
    required this.totalRevenue,
    required this.upiPercent,
    required this.upiTotal,
    required this.cashPercent,
    required this.cashTotal,
    required this.totalOrdersCount,
    required this.paidPercent,
    required this.paidCount,
    required this.freePercent,
    required this.freeCount,
  });

  @override
  Component build(BuildContext context) {
    final formattedTotal = '₹ ${totalRevenue.toStringAsFixed(2)}';

    return div(classes: 'grid grid-cols-1 md:grid-cols-2 gap-4 min-w-0', [
      PaymentMethodChartCard(
        formattedTotal: formattedTotal,
        upiPercent: '$upiPercent%',
        upiTotalFormatted: '₹ ${upiTotal.toStringAsFixed(2)}',
        cashPercent: '$cashPercent%',
        cashTotalFormatted: '₹ ${cashTotal.toStringAsFixed(2)}',
      ),
      PaymentStatusChartCard(
        totalOrdersCount: totalOrdersCount,
        paidPercent: paidPercent,
        paidCount: paidCount,
        freePercent: freePercent,
        freeCount: freeCount,
      ),
    ]);
  }
}
