import 'package:merchant/signals/dashboard_data_parser.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

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
        double onlineTotal,
        double inStoreTotal,
        double platformFeeTotal,
        double netRevenue,
      })
    >((
      totalRevenue: 0.0,
      totalOrders: 0,
      aov: 0.0,
      lowStockCount: 0,
      revenueGrowth: 0.0,
      ordersGrowth: 0.0,
      aovGrowth: 0.0,
      onlineTotal: 0.0,
      inStoreTotal: 0.0,
      platformFeeTotal: 0.0,
      netRevenue: 0.0,
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

final dashboardRevenueTrendsSignal =
    signal<
      ({
        List<String> labels,
        List<double> data,
      })
    >((
      labels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      data: const [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
    ));

final dashboardTopProductsSignal = signal<List<DashboardTopProduct>>([]);

final dashboardLowStockProductsSignal = signal<List<Product>>([]);

final dashboardRecentOrdersSignal = asyncSignal<List<Order>>(
  const AsyncLoading(),
);
