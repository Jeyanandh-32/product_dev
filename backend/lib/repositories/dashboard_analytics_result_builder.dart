import 'package:backend/repositories/dashboard_order_aggregator.dart';
import 'package:backend/repositories/dashboard_sales_aggregator.dart';

/// Helper for constructing the dashboard analytics response map.
abstract final class DashboardAnalyticsResultBuilder {
  /// Builds the serialized dashboard analytics map payload.
  static Map<String, dynamic> build({
    required DashboardOrderMetrics orderMetrics,
    required DashboardGrowthMetrics growth,
    required DashboardSalesMetrics salesMetrics,
    required List<Map<String, dynamic>> lowStockProducts,
    required int lowStockCount,
  }) {
    final categoryLabels = salesMetrics.categorySales.isEmpty
        ? <String>[]
        : salesMetrics.categorySales.keys.take(5).toList();
    final categoryData = categoryLabels
        .map((cat) => salesMetrics.categorySales[cat] ?? 0.0)
        .toList();

    return {
      'totalRevenue': orderMetrics.totalRevenue,
      'totalOrders': orderMetrics.totalOrders,
      'aov': orderMetrics.aov,
      'onlineTotal': orderMetrics.onlineTotal,
      'inStoreTotal': orderMetrics.inStoreTotal,
      'netRevenue': orderMetrics.netRevenue,
      'lowStockCount': lowStockCount,
      'revenueGrowth': growth.revenueGrowth,
      'ordersGrowth': growth.ordersGrowth,
      'aovGrowth': growth.aovGrowth,
      'paymentMethods': {
        'upiTotal': orderMetrics.upiTotal,
        'cashTotal': orderMetrics.cashTotal,
      },
      'paymentStatus': {
        'paidTotal': orderMetrics.paidTotal,
        'freeTotal': orderMetrics.freeTotal,
        'paidCount': orderMetrics.paidCount,
        'freeCount': orderMetrics.freeCount,
      },
      'categorySales': {'labels': categoryLabels, 'data': categoryData},
      'hourlyTraffic': {
        'labels': const [
          '8 AM', '10 AM', '12 PM', '2 PM', '4 PM', '6 PM', '8 PM', '10 PM',
        ],
        'data': orderMetrics.hourlyCounts,
      },
      'topProducts': salesMetrics.topProducts,
      'lowStockProducts': lowStockProducts,
    };
  }
}
