import 'package:backend/database/schema.dart';
import 'package:backend/repositories/dashboard_metrics_models.dart';
import 'package:models/models.dart';

export 'dashboard_metrics_models.dart';

/// Aggregates order metrics and hourly distribution.
class DashboardOrderAggregator {
  const DashboardOrderAggregator._();

  /// Computes revenue, payment channels, hourly distribution, and totals.
  static DashboardOrderMetrics aggregateOrders(List<OrderRow> orderRows) {
    var totalRevenuePaise = 0;
    var upiPaise = 0;
    var cashPaise = 0;
    var paidPaise = 0;
    var freePaise = 0;
    var paidCount = 0;
    var freeCount = 0;

    final hourlyCounts = List<int>.filled(8, 0);

    for (final o in orderRows) {
      final hour = o.createdAt.toLocal().hour;
      if (hour >= 8 && hour < 10) {
        hourlyCounts[0]++;
      } else if (hour >= 10 && hour < 12) {
        hourlyCounts[1]++;
      } else if (hour >= 12 && hour < 14) {
        hourlyCounts[2]++;
      } else if (hour >= 14 && hour < 16) {
        hourlyCounts[3]++;
      } else if (hour >= 16 && hour < 18) {
        hourlyCounts[4]++;
      } else if (hour >= 18 && hour < 20) {
        hourlyCounts[5]++;
      } else if (hour >= 20 && hour < 22) {
        hourlyCounts[6]++;
      } else {
        hourlyCounts[7]++;
      }

      final method = o.paymentMethod.toLowerCase();
      final pStatus = o.paymentStatus.toLowerCase();
      final isPaid =
          pStatus == PaymentStatus.completed.name || pStatus == 'paid';
      final isComplimentary = method == PaymentMethod.complimentary.name;

      if (isComplimentary) {
        freePaise += o.subtotal > 0 ? o.subtotal : 100;
        freeCount++;
      } else if (isPaid) {
        totalRevenuePaise += o.grandTotal;
        paidPaise += o.grandTotal;
        paidCount++;

        if (method == PaymentMethod.upi.name) {
          upiPaise += o.grandTotal;
        } else if (method == PaymentMethod.cash.name) {
          cashPaise += o.grandTotal;
        }
      }
    }

    final totalOrders = paidCount + freeCount;
    final totalRevenue = totalRevenuePaise / 100.0;
    final aov = totalOrders > 0 ? (totalRevenue / totalOrders) : 0.0;

    return DashboardOrderMetrics(
      totalRevenue: totalRevenue,
      totalOrders: totalOrders,
      aov: aov,
      upiTotal: upiPaise / 100.0,
      cashTotal: cashPaise / 100.0,
      paidTotal: paidPaise / 100.0,
      freeTotal: freePaise / 100.0,
      paidCount: paidCount,
      freeCount: freeCount,
      hourlyCounts: hourlyCounts,
    );
  }

  /// Computes percentage growth between current and previous period.
  static DashboardGrowthMetrics calculateGrowth({
    required double currentRevenue,
    required int currentOrders,
    required double currentAov,
    required double prevRevenue,
    required int prevOrders,
    required double prevAov,
  }) {
    var revenueGrowth = 0.0;
    var ordersGrowth = 0.0;
    var aovGrowth = 0.0;

    if (prevRevenue > 0) {
      revenueGrowth = ((currentRevenue - prevRevenue) / prevRevenue) * 100.0;
    } else if (currentRevenue > 0) {
      revenueGrowth = 100.0;
    }

    if (prevOrders > 0) {
      ordersGrowth = ((currentOrders - prevOrders) / prevOrders) * 100.0;
    } else if (currentOrders > 0) {
      ordersGrowth = 100.0;
    }

    if (prevAov > 0) {
      aovGrowth = ((currentAov - prevAov) / prevAov) * 100.0;
    } else if (currentAov > 0) {
      aovGrowth = 100.0;
    }

    return DashboardGrowthMetrics(
      revenueGrowth: revenueGrowth,
      ordersGrowth: ordersGrowth,
      aovGrowth: aovGrowth,
    );
  }
}
