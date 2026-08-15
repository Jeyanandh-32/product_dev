import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/signals/dashboard_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

/// Fallback metric computation when dashboard analytics endpoint is unavailable.
class DashboardOrdersFallback {
  const DashboardOrdersFallback._();

  /// Calculates summary metrics directly from an orders list.
  static void apply(OrderPaginatedResponse result) {
    final summary = result.summary;
    final totalOrders = summary.totalOrders;
    final totalRevenue = summary.netRevenue > 0
        ? summary.netRevenue
        : summary.grossSubtotal;
    final aov = totalOrders > 0 ? (totalRevenue / totalOrders) : 0.0;

    var upiTotal = 0.0;
    var cashTotal = 0.0;
    var paidTotal = 0.0;
    var freeTotal = 0.0;
    var paidCount = 0;
    var freeCount = 0;

    for (final o in result.items) {
      if (o.paymentMethod == PaymentMethod.upi) {
        upiTotal += o.grandTotal;
      } else if (o.paymentMethod == PaymentMethod.cash) {
        cashTotal += o.grandTotal;
      }

      if (o.paymentMethod == PaymentMethod.complimentary) {
        freeTotal += o.subtotal > 0 ? o.subtotal : 1.0;
        freeCount++;
      } else {
        paidTotal += o.grandTotal;
        paidCount++;
      }
    }

    final pSum = upiTotal + cashTotal;
    final upiPct = pSum > 0 ? ((upiTotal / pSum) * 100).round() : 0;
    final cashPct = pSum > 0 ? 100 - upiPct : 0;

    final oSum = paidCount + freeCount;
    final paidPct = oSum > 0 ? ((paidCount / oSum) * 100).round() : 0;
    final freePct = oSum > 0 ? 100 - paidPct : 0;

    untracked(() {
      dashboardSummarySignal.value = (
        totalRevenue: totalRevenue,
        totalOrders: totalOrders,
        aov: aov,
        lowStockCount: 0,
        revenueGrowth: 0.0,
        ordersGrowth: 0.0,
        aovGrowth: 0.0,
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
      dashboardRecentOrdersSignal.value = AsyncData(result.items);
    });
  }
}
