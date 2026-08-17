/// Aggregated order metrics for merchant dashboard analytics.
class DashboardOrderMetrics {
  const DashboardOrderMetrics({
    required this.totalRevenue,
    required this.totalOrders,
    required this.aov,
    required this.upiTotal,
    required this.cashTotal,
    required this.paidTotal,
    required this.freeTotal,
    required this.paidCount,
    required this.freeCount,
    required this.hourlyCounts,
  });

  final double totalRevenue;
  final int totalOrders;
  final double aov;
  final double upiTotal;
  final double cashTotal;
  final double paidTotal;
  final double freeTotal;
  final int paidCount;
  final int freeCount;
  final List<int> hourlyCounts;
}

/// Aggregated period-over-period growth metrics.
class DashboardGrowthMetrics {
  const DashboardGrowthMetrics({
    required this.revenueGrowth,
    required this.ordersGrowth,
    required this.aovGrowth,
  });

  final double revenueGrowth;
  final double ordersGrowth;
  final double aovGrowth;
}
