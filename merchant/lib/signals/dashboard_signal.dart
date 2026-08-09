import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/signals/stores_signal.dart';
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

final dashboardTopProductsSignal =
    signal<
      List<
        ({
          String rank,
          String name,
          String category,
          String units,
          String revenue,
        })
      >
    >(const []);

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

      final totalRevenue =
          (analytics['totalRevenue'] as num?)?.toDouble() ?? 0.0;
      final totalOrders = analytics['totalOrders'] as int? ?? 0;
      final aov = (analytics['aov'] as num?)?.toDouble() ?? 0.0;
      final lowStockCount = analytics['lowStockCount'] as int? ?? 0;

      final pMethods =
          (analytics['paymentMethods'] as Map<String, dynamic>?) ?? {};
      final upiTotal = (pMethods['upiTotal'] as num?)?.toDouble() ?? 0.0;
      final cashTotal = (pMethods['cashTotal'] as num?)?.toDouble() ?? 0.0;
      final pSum = upiTotal + cashTotal;
      final upiPct = pSum > 0 ? ((upiTotal / pSum) * 100).round() : 0;
      final cashPct = pSum > 0 ? 100 - upiPct : 0;

      final pStatus =
          (analytics['paymentStatus'] as Map<String, dynamic>?) ?? {};
      final paidTotal = (pStatus['paidTotal'] as num?)?.toDouble() ?? 0.0;
      final freeTotal = (pStatus['freeTotal'] as num?)?.toDouble() ?? 0.0;
      final paidCount = pStatus['paidCount'] as int? ?? 0;
      final freeCount = pStatus['freeCount'] as int? ?? 0;
      final oSum = paidCount + freeCount;
      final paidPct = oSum > 0 ? ((paidCount / oSum) * 100).round() : 0;
      final freePct = oSum > 0 ? 100 - paidPct : 0;

      final rawTop = (analytics['topProducts'] as List<dynamic>?) ?? [];
      final topList =
          <
            ({
              String rank,
              String name,
              String category,
              String units,
              String revenue,
            })
          >[];
      for (var i = 0; i < rawTop.length; i++) {
        final map = rawTop[i] as Map<String, dynamic>;
        final price = (map['sellingPrice'] as num?)?.toDouble() ?? 0.0;
        final qty = map['quantity'] as int? ?? 0;
        topList.add((
          rank: '${i + 1}',
          name: map['name'] as String? ?? '',
          category: map['category'] as String? ?? 'General',
          units: '$qty in stock',
          revenue: '₹ ${(price / 100.0).toStringAsFixed(2)}',
        ));
      }

      final rawLow = (analytics['lowStockProducts'] as List<dynamic>?) ?? [];
      final lowStockList = rawLow.map((json) {
        final map = json as Map<String, dynamic>;
        final pricePaise = (map['sellingPrice'] as num?)?.toDouble() ?? 0.0;
        final qty = map['quantity'] as int? ?? 0;
        final thresh = map['lowStockThreshold'] as int? ?? 5;
        return Product(
          id: map['id'] as String? ?? '',
          merchantId: '',
          name: map['name'] as String? ?? '',
          basePrice: pricePaise / 100.0,
          sellingPrice: pricePaise / 100.0,
          taxRate: 0.0,
          isActive: true,
          category: Category(
            id: '',
            merchantId: '',
            storeId: selectedStore.id,
            name: map['category'] as String? ?? 'General',
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          stock: Stock(
            id: map['id'] as String? ?? '',
            productId: map['id'] as String? ?? '',
            storeId: selectedStore.id,
            quantity: qty,
            lowStockThreshold: thresh,
            stockMonitor: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }).toList();

      final catSalesMap =
          (analytics['categorySales'] as Map<String, dynamic>?) ?? {};
      final catLabels =
          (catSalesMap['labels'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      final catData =
          (catSalesMap['data'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [];

      final hourlyMap =
          (analytics['hourlyTraffic'] as Map<String, dynamic>?) ?? {};
      final hourlyLabels =
          (hourlyMap['labels'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      final hourlyData =
          (hourlyMap['data'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [];

      untracked(() {
        dashboardSummarySignal.value = (
          totalRevenue: totalRevenue,
          totalOrders: totalOrders,
          aov: aov,
          lowStockCount: lowStockCount,
          revenueGrowth:
              (analytics['revenueGrowth'] as num?)?.toDouble() ?? 0.0,
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
        if (catLabels.isNotEmpty) {
          dashboardCategorySalesSignal.value = (
            labels: catLabels,
            data: catData,
          );
        }
        if (hourlyData.isNotEmpty) {
          dashboardHourlyOrdersSignal.value = (
            labels: hourlyLabels,
            data: hourlyData,
          );
        }
        dashboardTopProductsSignal.value = topList;
        dashboardLowStockProductsSignal.value = lowStockList;
      });

      return;
    } catch (_) {}

    // Fallback to OrderRepository.getAll
    final result = await OrderRepository.getAll(
      storeId: selectedStore.id,
      fromDate: fromDateStr,
      page: 1,
      size: 50,
    );

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
  } catch (e, stack) {
    dashboardRecentOrdersSignal.value = AsyncError(e, stack);
  }
}
