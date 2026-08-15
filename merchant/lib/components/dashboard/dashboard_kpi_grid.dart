import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';
import 'package:merchant/components/dashboard/kpi_metric_card.dart';

/// Top KPI statistics summary grid displaying revenue, order count, AOV, and low stock count.
class DashboardKpiGrid extends StatelessComponent {
  final double totalRevenue;
  final int totalOrders;
  final double aov;
  final int lowStockCount;
  final double revenueGrowth;
  final double ordersGrowth;
  final double aovGrowth;

  const DashboardKpiGrid({
    super.key,
    required this.totalRevenue,
    required this.totalOrders,
    required this.aov,
    required this.lowStockCount,
    required this.revenueGrowth,
    required this.ordersGrowth,
    required this.aovGrowth,
  });

  String _formatGrowth(double growth) {
    if (growth > 0) {
      return '+${growth.toStringAsFixed(1)}%';
    } else if (growth < 0) {
      return '${growth.toStringAsFixed(1)}%';
    }
    return '0.0%';
  }

  @override
  Component build(BuildContext context) {
    final formattedTotal = '₹ ${totalRevenue.toStringAsFixed(2)}';

    return div(classes: 'grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4', [
      KpiMetricCard(
        title: 'Total Revenue',
        value: formattedTotal,
        trend: _formatGrowth(revenueGrowth),
        trendUp: revenueGrowth >= 0,
        iconBg: 'bg-emerald-50 text-emerald-600 border-emerald-100',
        iconWidget: IndianRupee(classes: 'w-5 h-5'),
        subtitle: 'vs previous period',
      ),
      KpiMetricCard(
        title: 'Total Orders',
        value: '$totalOrders Orders',
        trend: _formatGrowth(ordersGrowth),
        trendUp: ordersGrowth >= 0,
        iconBg: 'bg-blue-50 text-blue-600 border-blue-100',
        iconWidget: ShoppingBag(classes: 'w-5 h-5'),
        subtitle: 'vs previous period',
      ),
      KpiMetricCard(
        title: 'Avg Order Value (AOV)',
        value: '₹ ${aov.toStringAsFixed(2)}',
        trend: _formatGrowth(aovGrowth),
        trendUp: aovGrowth >= 0,
        iconBg: 'bg-purple-50 text-purple-600 border-purple-100',
        iconWidget: ChartBar(classes: 'w-5 h-5'),
        subtitle: 'vs previous period',
      ),
      KpiMetricCard(
        title: 'Low Stock Items',
        value: '$lowStockCount Products',
        trend: lowStockCount > 0 ? 'Requires Action' : 'Optimal',
        trendUp: lowStockCount == 0,
        iconBg: 'bg-amber-50 text-amber-600 border-amber-100',
        iconWidget: TriangleAlert(classes: 'w-5 h-5'),
        subtitle: 'Below low stock threshold',
      ),
    ]);
  }
}
