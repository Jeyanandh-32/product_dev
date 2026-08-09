import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

final dashboardRangeSignal = signal<String>('7d');

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
    String? fromDateStr;
    final now = DateTime.now();

    switch (dashboardRangeSignal.value) {
      case '1d':
        final startOfToday = DateTime(now.year, now.month, now.day);
        fromDateStr = startOfToday.toIso8601String();
        break;
      case '7d':
        final start7d = now.subtract(const Duration(days: 7));
        fromDateStr = start7d.toIso8601String();
        break;
      case '30d':
        final start30d = now.subtract(const Duration(days: 30));
        fromDateStr = start30d.toIso8601String();
        break;
      case '1y':
        final startYear = DateTime(now.year, 1, 1);
        fromDateStr = startYear.toIso8601String();
        break;
    }

    // 1. Fetch store products to build category breakdown and top products
    try {
      final productsResult = await ProductRepository.getAll(
        storeId: selectedStore.id,
        size: 100,
      );
      final products = productsResult.items;

      final categoryMap = <String, double>{};
      for (final p in products) {
        final cat = p.category?.name ?? 'General';
        categoryMap[cat] = (categoryMap[cat] ?? 0.0) + p.sellingPrice;
      }

      final catLabels = categoryMap.keys.take(5).toList();
      final catData = catLabels.map((c) => categoryMap[c] ?? 0.0).toList();

      final topProds = products.take(5).toList();
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

      for (var i = 0; i < topProds.length; i++) {
        final p = topProds[i];
        final catName = p.category?.name ?? 'General';
        topList.add((
          rank: '${i + 1}',
          name: p.name,
          category: catName,
          units: '${(p.stock?.quantity ?? 0)} in stock',
          revenue: '₹ ${p.sellingPrice.toStringAsFixed(2)}',
        ));
      }

      final lowStockList = products
          .where(
            (p) =>
                (p.stock?.quantity ?? 0) <= (p.stock?.lowStockThreshold ?? 5),
          )
          .toList();

      untracked(() {
        if (catLabels.isNotEmpty) {
          dashboardCategorySalesSignal.value = (
            labels: catLabels,
            data: catData,
          );
        }
        dashboardTopProductsSignal.value = topList;
        dashboardLowStockProductsSignal.value = lowStockList;
      });
    } catch (_) {}

    // 2. Fetch backend analytics
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

      final rawRecent = (analytics['recentOrders'] as List<dynamic>?) ?? [];
      final recentOrders = rawRecent.map((json) {
        final map = json as Map<String, dynamic>;
        final pMethod = map['paymentMethod'] as String? ?? 'upi';
        return Order(
          id: map['id'] as String? ?? '',
          merchantId: '',
          storeId: selectedStore.id,
          orderReference: map['orderReference'] as String? ?? '',
          billNo: map['billNo'] as int? ?? 0,
          source: OrderSource.terminal,
          type: OrderType.dineIn,
          status: OrderStatus.completed,
          paymentStatus: PaymentStatus.paid,
          paymentMethod: pMethod.toLowerCase() == 'cash'
              ? PaymentMethod.cash
              : PaymentMethod.upi,
          subtotal: ((map['grandTotal'] as num?)?.toDouble() ?? 0.0) * 100,
          discountTotal: 0,
          taxTotal: 0,
          grandTotal: (map['grandTotal'] as num?)?.toDouble() ?? 0.0,
          items: const [],
          createdAt:
              DateTime.tryParse(map['createdAt'] as String? ?? '') ??
              DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }).toList();

      // Hourly distribution
      final hourlyCounts = List<int>.filled(8, 0);
      for (final order in recentOrders) {
        final hour = order.createdAt.hour;
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
        } else if (hour >= 22) {
          hourlyCounts[7]++;
        }
      }

      final revGrowth = (analytics['revenueGrowth'] as num?)?.toDouble() ?? 0.0;
      final ordGrowth = (analytics['ordersGrowth'] as num?)?.toDouble() ?? 0.0;
      final aovGrowth = (analytics['aovGrowth'] as num?)?.toDouble() ?? 0.0;

      untracked(() {
        dashboardSummarySignal.value = (
          totalRevenue: totalRevenue,
          totalOrders: totalOrders,
          aov: aov,
          lowStockCount: lowStockCount,
          revenueGrowth: revGrowth,
          ordersGrowth: ordGrowth,
          aovGrowth: aovGrowth,
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
          data: hourlyCounts,
        );
        dashboardRecentOrdersSignal.value = AsyncData(recentOrders);
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

    int lowStock = 0;
    try {
      final productsResult = await ProductRepository.getAll(
        storeId: selectedStore.id,
        size: 100,
      );
      lowStock = productsResult.items
          .where(
            (p) =>
                (p.stock?.quantity ?? 0) <= (p.stock?.lowStockThreshold ?? 5),
          )
          .length;
    } catch (_) {}

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
        lowStockCount: lowStock,
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
