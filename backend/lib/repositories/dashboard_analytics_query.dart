import 'package:backend/database/schema.dart';
import 'package:backend/repositories/dashboard_analytics_result_builder.dart';
import 'package:backend/repositories/dashboard_order_aggregator.dart';
import 'package:backend/repositories/dashboard_product_aggregator.dart';
import 'package:backend/repositories/dashboard_sales_aggregator.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Database query and aggregator helper for merchant analytics dashboard.
class DashboardAnalyticsQuery {
  /// Creates a query coordinator for dashboard analytics.
  const DashboardAnalyticsQuery({required this.db});

  /// The database instance.
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

    final ordersFuture = query
        .orderBy((o) => [(o.createdAt, ts.Order.descending)])
        .fetch();
    final stocksFuture = db.stocks
        .where((s) => s.storeId.equals(ts.toExpr(storeId)))
        .fetch();

    final productsFuture = db.products
        .leftJoin(db.stocks)
        .on((p, s) => p.id.equals(s.productId))
        .leftJoin(db.categories)
        .on((p, s, c) => p.categoryId.equals(c.id))
        .where((p, s, c) => p.storeId.equals(ts.toExpr(storeId)))
        .fetch();

    final orderItemsFuture = db.orderItems
        .leftJoin(db.orders)
        .on((item, o) => item.orderId.equals(o.id))
        .leftJoin(db.products)
        .on((item, o, p) => item.productId.equals(p.id))
        .leftJoin(db.categories)
        .on((item, o, p, c) => p.categoryId.equals(c.id))
        .where((item, o, p, c) => item.storeId.equals(ts.toExpr(storeId)))
        .fetch();

    final prevOrdersFuture = fromDate != null
        ? _fetchPrevOrders(
            merchantId: merchantId,
            storeId: storeId,
            fromDate: fromDate,
            toDate: toDate,
          )
        : null;

    final (orderRows, stocks, productRows, orderItemTuples) = await (
      ordersFuture,
      stocksFuture,
      productsFuture,
      orderItemsFuture,
    ).wait;

    final orderMetrics = DashboardOrderAggregator.aggregateOrders(orderRows);
    final lowStockCount = stocks
        .where((s) => s.quantity <= s.lowStockThreshold)
        .length;

    var growth = const DashboardGrowthMetrics(
      revenueGrowth: 0,
      ordersGrowth: 0,
      aovGrowth: 0,
    );
    if (prevOrdersFuture != null) {
      final prevRows = await prevOrdersFuture;
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

    final salesMetrics = DashboardSalesAggregator.aggregateItemSales(
      orderItemTuples,
      fromDate: fromDate,
      toDate: toDate,
    );
    final lowStockProducts = DashboardProductAggregator.formatLowStockProducts(
      productRows,
    );

    return DashboardAnalyticsResultBuilder.build(
      orderMetrics: orderMetrics,
      growth: growth,
      salesMetrics: salesMetrics,
      lowStockProducts: lowStockProducts,
      lowStockCount: lowStockCount,
    );
  }

  Future<List<OrderRow>> _fetchPrevOrders({
    required String merchantId,
    required String storeId,
    required DateTime fromDate,
    DateTime? toDate,
  }) {
    final now = toDate ?? DateTime.now().toUtc();
    final duration = now.difference(fromDate);
    final prevFromDate = fromDate.subtract(duration);
    return db.orders
        .where((o) => o.merchantId.equals(ts.toExpr(merchantId)))
        .where((o) => o.storeId.equals(ts.toExpr(storeId)))
        .where((o) => o.createdAt.isAfterValue(prevFromDate))
        .where((o) => o.createdAt.isBeforeValue(fromDate))
        .fetch();
  }
}
