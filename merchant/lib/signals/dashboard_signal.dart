import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/signals/dashboard_data_parser.dart';
import 'package:merchant/signals/dashboard_signals_updater.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

export 'package:merchant/signals/dashboard_data_parser.dart'
    show DashboardTopProduct;

final dashboardRangeSignal = signal<DashboardRange>(.days7);

final dashboardSummarySignal =
    signal<
      ({
        double totalRevenue,
        int totalOrders,
        double aov,
        int lowStockCount,
        double revenueGrowth,
        double ordersGrowth,
        double aovGrowth,
      })
    >((
      totalRevenue: 0.0,
      totalOrders: 0,
      aov: 0.0,
      lowStockCount: 0,
      revenueGrowth: 0.0,
      ordersGrowth: 0.0,
      aovGrowth: 0.0,
    ));

final dashboardPaymentMethodsSignal =
    signal<
      ({
        double upiTotal,
        double cashTotal,
        int upiPercent,
        int cashPercent,
      })
    >((
      upiTotal: 0.0,
      cashTotal: 0.0,
      upiPercent: 0,
      cashPercent: 0,
    ));

final dashboardPaymentStatusSignal =
    signal<
      ({
        double paidTotal,
        double freeTotal,
        int paidCount,
        int freeCount,
        int paidPercent,
        int freePercent,
      })
    >((
      paidTotal: 0.0,
      freeTotal: 0.0,
      paidCount: 0,
      freeCount: 0,
      paidPercent: 0,
      freePercent: 0,
    ));

final dashboardCategorySalesSignal =
    signal<
      ({
        List<String> labels,
        List<double> data,
      })
    >((
      labels: const ['Beverages', 'Bakery', 'Snacks', 'Desserts', 'Other'],
      data: const [0.0, 0.0, 0.0, 0.0, 0.0],
    ));

final dashboardHourlyOrdersSignal =
    signal<
      ({
        List<String> labels,
        List<int> data,
      })
    >((
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
    ));

final dashboardTopProductsSignal = signal<List<DashboardTopProduct>>(const []);

final dashboardLowStockProductsSignal = signal<List<Product>>(const []);

final dashboardRecentOrdersSignal = asyncSignal<List<Order>>(
  const AsyncLoading(),
);

void resetDashboardSignal() {
  dashboardSummarySignal.value = (
    totalRevenue: 0.0,
    totalOrders: 0,
    aov: 0.0,
    lowStockCount: 0,
    revenueGrowth: 0.0,
    ordersGrowth: 0.0,
    aovGrowth: 0.0,
  );
  dashboardTopProductsSignal.value = const [];
  dashboardLowStockProductsSignal.value = const [];
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
