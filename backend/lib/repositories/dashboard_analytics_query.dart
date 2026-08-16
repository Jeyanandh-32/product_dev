import 'package:backend/database/schema.dart';
import 'package:backend/repositories/dashboard_order_aggregator.dart';
import 'package:backend/repositories/dashboard_product_aggregator.dart';
import 'package:backend/repositories/dashboard_sales_aggregator.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Database query and aggregator helper for merchant analytics dashboard.
class DashboardAnalyticsQuery {
  const DashboardAnalyticsQuery({required this.db});

  final ts.Database<DatabaseSchema> db;

  /// Calculates aggregated dashboard metrics, payment methods, hourly traffic, and top products.
  Future<Map<String, dynamic>> execute({
    required String merchantId,
    required String storeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    var query = db.orders
        .where((o) => o.merchantId.equals(ts.toExpr(merchantId)))
        .where((o) => o.storeId.equals(ts.toExpr(storeId)));

    if (fromDate != null) {
      query = query.where((o) => o.createdAt.isAfterValue(fromDate));
    }
    if (toDate != null) {
      query = query.where((o) => o.createdAt.isBeforeValue(toDate));
    }

    final orderRows = await query
        .orderBy((o) => [(o.createdAt, ts.Order.descending)])
        .fetch();

    final orderMetrics = DashboardOrderAggregator.aggregateOrders(orderRows);

    final stocks = await db.stocks
        .where((s) => s.storeId.equals(ts.toExpr(storeId)))
        .fetch();
    final lowStockCount = stocks
        .where((s) => s.quantity <= s.lowStockThreshold)
        .length;

    var growth = (
      revenueGrowth: 0.0,
      ordersGrowth: 0.0,
      aovGrowth: 0.0,
    );

    if (fromDate != null) {
      final now = toDate ?? DateTime.now().toUtc();
      final duration = now.difference(fromDate);
      final prevFromDate = fromDate.subtract(duration);
      final prevToDate = fromDate;

      final prevRows = await db.orders
          .where((o) => o.merchantId.equals(ts.toExpr(merchantId)))
          .where((o) => o.storeId.equals(ts.toExpr(storeId)))
          .where((o) => o.createdAt.isAfterValue(prevFromDate))
          .where((o) => o.createdAt.isBeforeValue(prevToDate))
          .fetch();

      final prevMetrics = DashboardOrderAggregator.aggregateOrders(prevRows);

      growth = DashboardOrderAggregator.calculateGrowth(
        currentRevenue: orderMetrics.totalRevenue,
        currentOrders: orderMetrics.totalOrders,
        currentAov: orderMetrics.aov,
        prevRevenue: prevMetrics.totalRevenue,
        prevOrders: prevMetrics.totalOrders,
        prevAov: prevMetrics.aov,
      );
    }

    final productRows = await db.products
        .leftJoin(db.stocks)
        .on((p, s) => p.id.equals(s.productId))
        .leftJoin(db.categories)
        .on((p, s, c) => p.categoryId.equals(c.id))
        .where((p, s, c) => p.storeId.equals(ts.toExpr(storeId)))
        .fetch();

    final orderItemTuples = await db.orderItems
        .leftJoin(db.orders)
        .on((item, o) => item.orderId.equals(o.id))
        .leftJoin(db.products)
        .on((item, o, p) => item.productId.equals(p.id))
        .leftJoin(db.categories)
        .on((item, o, p, c) => p.categoryId.equals(c.id))
        .where((item, o, p, c) => item.storeId.equals(ts.toExpr(storeId)))
        .fetch();

    final salesMetrics = DashboardSalesAggregator.aggregateItemSales(
      orderItemTuples,
      fromDate: fromDate,
      toDate: toDate,
    );

    final categoryLabels = salesMetrics.categorySales.isEmpty
        ? <String>[]
        : salesMetrics.categorySales.keys.take(5).toList();
    final categoryData = categoryLabels
        .map((cat) => salesMetrics.categorySales[cat] ?? 0.0)
        .toList();

    final lowStockProducts =
        DashboardProductAggregator.formatLowStockProducts(productRows);

    return {
      'totalRevenue': orderMetrics.totalRevenue,
      'totalOrders': orderMetrics.totalOrders,
      'aov': orderMetrics.aov,
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
      'categorySales': {
        'labels': categoryLabels,
        'data': categoryData,
      },
      'hourlyTraffic': {
        'labels': [
          '8 AM',
          '10 AM',
          '12 PM',
          '2 PM',
          '4 PM',
          '6 PM',
          '8 PM',
          '10 PM',
        ],
        'data': orderMetrics.hourlyCounts,
      },
      'topProducts': salesMetrics.topProducts,
      'lowStockProducts': lowStockProducts,
    };
  }
}
