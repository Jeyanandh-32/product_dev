import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/signals/dashboard_data_parser.dart';
import 'package:merchant/signals/dashboard_orders_fallback.dart';
import 'package:merchant/signals/dashboard_signal.dart';
import 'package:signals/signals.dart';

/// Applies analytics and fallback data payloads to dashboard reactive signals.
class DashboardSignalsUpdater {
  const DashboardSignalsUpdater._();

  /// Applies the parsed backend analytics JSON to dashboard signals.
  static void applyAnalytics({
    required Map<String, dynamic> analytics,
    required String storeId,
  }) {
    final totalRevenue = (analytics['totalRevenue'] as num?)?.toDouble() ?? 0.0;
    final totalOrders = analytics['totalOrders'] as int? ?? 0;
    final aov = (analytics['aov'] as num?)?.toDouble() ?? 0.0;
    final lowStockCount = analytics['lowStockCount'] as int? ?? 0;

    final pMethods = (analytics['paymentMethods'] as Map<String, dynamic>?) ?? {};
    final upiTotal = (pMethods['upiTotal'] as num?)?.toDouble() ?? 0.0;
    final cashTotal = (pMethods['cashTotal'] as num?)?.toDouble() ?? 0.0;
    final pSum = upiTotal + cashTotal;
    final upiPct = pSum > 0 ? ((upiTotal / pSum) * 100).round() : 0;
    final cashPct = pSum > 0 ? 100 - upiPct : 0;

    final pStatus = (analytics['paymentStatus'] as Map<String, dynamic>?) ?? {};
    final paidTotal = (pStatus['paidTotal'] as num?)?.toDouble() ?? 0.0;
    final freeTotal = (pStatus['freeTotal'] as num?)?.toDouble() ?? 0.0;
    final paidCount = pStatus['paidCount'] as int? ?? 0;
    final freeCount = pStatus['freeCount'] as int? ?? 0;
    final oSum = paidCount + freeCount;
    final paidPct = oSum > 0 ? ((paidCount / oSum) * 100).round() : 0;
    final freePct = oSum > 0 ? 100 - paidPct : 0;

    final topList = DashboardDataParser.parseTopProducts(
      analytics['topProducts'] as List<dynamic>?,
    );
    final lowStockList = DashboardDataParser.parseLowStockProducts(
      analytics['lowStockProducts'] as List<dynamic>?,
      storeId,
    );

    final catSalesMap = (analytics['categorySales'] as Map<String, dynamic>?) ?? {};
    final catLabels = (catSalesMap['labels'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final catData = (catSalesMap['data'] as List<dynamic>?)
            ?.map((e) => (e as num).toDouble())
            .toList() ??
        [];

    final hourlyMap = (analytics['hourlyTraffic'] as Map<String, dynamic>?) ?? {};
    final hourlyLabels = (hourlyMap['labels'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final hourlyData = (hourlyMap['data'] as List<dynamic>?)
            ?.map((e) => (e as num).toInt())
            .toList() ??
        [];

    untracked(() {
      dashboardSummarySignal.value = (
        totalRevenue: totalRevenue,
        totalOrders: totalOrders,
        aov: aov,
        lowStockCount: lowStockCount,
        revenueGrowth: (analytics['revenueGrowth'] as num?)?.toDouble() ?? 0.0,
        ordersGrowth: (analytics['ordersGrowth'] as num?)?.toDouble() ?? 0.0,
        aovGrowth: (analytics['aovGrowth'] as num?)?.toDouble() ?? 0.0,
      );
      dashboardPaymentMethodsSignal.value = (
        upiTotal: upiTotal,
        cashTotal: cashTotal,
        upiPercent: upiPct,
        cashPercent: cashPct,
      );
      dashboardPaymentStatusSignal.value = (
        paidTotal: paidTotal,
        freeTotal: freeTotal,
        paidCount: paidCount,
        freeCount: freeCount,
        paidPercent: paidPct,
        freePercent: freePct,
      );
      dashboardCategorySalesSignal.value = (
        labels: catLabels,
        data: catData,
      );
      if (hourlyData.isNotEmpty) {
        dashboardHourlyOrdersSignal.value = (
          labels: hourlyLabels,
          data: hourlyData,
        );
      }
      dashboardTopProductsSignal.value = topList;
      dashboardLowStockProductsSignal.value = lowStockList;
    });
  }

  /// Calculates summary metrics directly from an orders list when analytics endpoint is unavailable.
  static void applyOrdersFallback(OrderPaginatedResponse result) =>
      DashboardOrdersFallback.apply(result);
}
