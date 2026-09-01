import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/signals/dashboard_signals_state.dart';
import 'package:merchant/signals/dashboard_signals_updater.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:signals/signals.dart';

export 'package:merchant/signals/dashboard_data_parser.dart'
    show DashboardTopProduct;
export 'package:merchant/signals/dashboard_signals_state.dart';

void resetDashboardSignal() {
  dashboardRangeSignal.value = .days7;
  dashboardSummarySignal.value = (
    totalRevenue: 0.0,
    totalOrders: 0,
    aov: 0.0,
    lowStockCount: 0,
    revenueGrowth: 0.0,
    ordersGrowth: 0.0,
    aovGrowth: 0.0,
    onlineTotal: 0.0,
    inStoreTotal: 0.0,
    netRevenue: 0.0,
  );
  dashboardRevenueTrendsSignal.value = (
    labels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    data: const [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
  );
  dashboardTopProductsSignal.value = [];
  dashboardLowStockProductsSignal.value = [];
  dashboardCategorySalesSignal.value = (
    labels: const ['Beverages', 'Bakery', 'Snacks', 'Desserts', 'Other'],
    data: const [0.0, 0.0, 0.0, 0.0, 0.0],
  );
  dashboardHourlyOrdersSignal.value = (
    labels: const [
      '8 AM',
      '10 AM',
      '12 PM',
      '2 PM',
      '4 PM',
      '6 PM',
      '8 PM',
      '10 PM',
    ],
    data: const [0, 0, 0, 0, 0, 0, 0, 0],
  );
  dashboardPaymentMethodsSignal.value = (
    upiTotal: 0.0,
    cashTotal: 0.0,
    upiPercent: 0,
    cashPercent: 0,
  );
  dashboardPaymentStatusSignal.value = (
    paidTotal: 0.0,
    freeTotal: 0.0,
    paidCount: 0,
    freeCount: 0,
    paidPercent: 0,
    freePercent: 0,
  );
  dashboardRecentOrdersSignal.value = const AsyncData([]);
}

Future<void> refreshDashboardSignal() async {
  final selectedStore = storeSignal.value;
  if (selectedStore == null) {
    untracked(() {
      dashboardRecentOrdersSignal.value = const AsyncData([]);
    });
    return;
  }

  untracked(() {
    dashboardRecentOrdersSignal.value = const AsyncLoading();
  });

  try {
    final now = DateTime.now();
    final fromDateStr = switch (dashboardRangeSignal.value) {
      .today => DateTime(now.year, now.month, now.day).toIso8601String(),
      .days7 => now.subtract(const Duration(days: 7)).toIso8601String(),
      .days30 => now.subtract(const Duration(days: 30)).toIso8601String(),
      .year1 => DateTime(now.year, 1, 1).toIso8601String(),
    };

    // 1. Fetch backend analytics
    try {
      final analytics = await OrderRepository.getDashboardAnalytics(
        storeId: selectedStore.id,
        fromDate: fromDateStr,
      );

      DashboardSignalsUpdater.applyAnalytics(
        analytics: analytics,
        storeId: selectedStore.id,
      );
      return;
    } catch (_) {}

    // 2. Fallback to OrderRepository.getAll
    final result = await OrderRepository.getAll(
      storeId: selectedStore.id,
      fromDate: fromDateStr,
      page: 1,
      size: 50,
    );

    DashboardSignalsUpdater.applyOrdersFallback(result);
  } catch (e, stack) {
    dashboardRecentOrdersSignal.value = AsyncError(e, stack);
  }
}
