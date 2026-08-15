import 'package:backend/database/schema.dart';
import 'package:backend/repositories/customer_orders_query.dart';
import 'package:backend/repositories/dashboard_analytics_query.dart';
import 'package:backend/repositories/order_summary_calculator.dart';
import 'package:backend/repositories/profit_loss_report_query.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Repository for handling order queries, creation, and reports in the PostgreSQL database.
class OrderRepository {
  OrderRepository({required this._db});

  final ts.Database<DatabaseSchema> _db;

  /// Inserts a new order row into the orders table.
  Future<OrderRow> create({
    required String merchantId,
    required String storeId,
    required String orderReference,
    required int billNo,
    required OrderSource source,
    required OrderType type,
    required OrderStatus status,
    required PaymentStatus paymentStatus,
    required PaymentMethod paymentMethod,
    required int subtotal,
    required int discountTotal,
    required int taxTotal,
    required int grandTotal,
    int walletDeduction = 0,
    String? terminalCode,
    String? customerId,
  }) async {
    final row = await _db.orders
        .insertValue(
          merchantId: merchantId,
          storeId: storeId,
          orderReference: orderReference,
          billNo: billNo,
          source: source.name,
          type: type.name,
          status: status.name,
          paymentStatus: paymentStatus.name,
          paymentMethod: paymentMethod.name,
          subtotal: subtotal,
          discountTotal: discountTotal,
          taxTotal: taxTotal,
          grandTotal: grandTotal,
          walletDeduction: walletDeduction,
          terminalCode: terminalCode,
          customerId: customerId,
        )
        .returnInserted()
        .executeAndFetch();

    return row;
  }

  /// Returns the next incremental daily bill number for a store.
  Future<int> getNextBillNo(String storeId) async {
    final today = DateTime.now().toUtc();
    final startOfToday = DateTime.utc(today.year, today.month, today.day);

    final lastOrder = await _db.orders
        .where((o) => o.storeId.equals(ts.toExpr(storeId)))
        .where((o) => o.createdAt.isAfterValue(startOfToday))
        .orderBy((o) => [(o.billNo, ts.Order.descending)])
        .first
        .fetch();

    return (lastOrder?.billNo ?? 0) + 1;
  }

  /// Updates existing order state, payment status, or payment method.
  Future<OrderRow?> update({
    required String id,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    PaymentMethod? paymentMethod,
    String? terminalCode,
  }) async {
    final row = _db.orders
        .byKey(id)
        .update(
          (o, set) => set(
            status: status != null ? ts.toExpr(status.name) : o.status,
            paymentStatus: paymentStatus != null
                ? ts.toExpr(paymentStatus.name)
                : o.paymentStatus,
            paymentMethod: paymentMethod != null
                ? ts.toExpr(paymentMethod.name)
                : o.paymentMethod,
            terminalCode: terminalCode != null
                ? ts.toExpr(terminalCode)
                : o.terminalCode,
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returnUpdated()
        .executeAndFetch();

    return row;
  }

  /// Fetches orders filtered by merchant, store, date range, and pagination.
  Future<List<OrderRow>> getAll({
    required String merchantId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
    String? paymentMethod,
    String? status,
    String? paymentStatus,
    int? limit,
    int? offset,
  }) async {
    var query = _db.orders.where(
      (o) => o.merchantId.equals(ts.toExpr(merchantId)),
    );

    if (storeId != null) {
      query = query.where((o) => o.storeId.equals(ts.toExpr(storeId)));
    }
    if (fromDate != null) {
      query = query.where((o) => o.createdAt.isAfterValue(fromDate));
    }
    if (toDate != null) {
      query = query.where((o) => o.createdAt.isBeforeValue(toDate));
    }
    if (paymentMethod != null && paymentMethod.isNotEmpty) {
      query = query.where(
        (o) => o.paymentMethod.equals(ts.toExpr(paymentMethod)),
      );
    }
    if (status != null && status.isNotEmpty) {
      query = query.where((o) => o.status.equals(ts.toExpr(status)));
    }
    if (paymentStatus != null && paymentStatus.isNotEmpty) {
      query = query.where(
        (o) => o.paymentStatus.equals(ts.toExpr(paymentStatus)),
      );
    }
    if (offset != null) {
      query = query.offset(offset);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    final rows = query
        .orderBy((o) => [(o.createdAt, ts.Order.descending)])
        .fetch();

    return rows;
  }

  /// Computes order summary totals (count, gross, discounts, net revenue, and payment channels).
  Future<
    ({
      int totalOrders,
      double grossSubtotal,
      double totalDiscount,
      double netRevenue,
      double cashCollected,
      double upiCollected,
      double walletCollected,
      double freeTotal,
    })
  >
  getOrderSummary({
    required String merchantId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) => OrderSummaryCalculator.calculateOrderSummary(
    db: _db,
    merchantId: merchantId,
    storeId: storeId,
    fromDate: fromDate,
    toDate: toDate,
  );

  /// Computes collected payments summary categorized by Cash, UPI, and Free.
  Future<
    ({
      double cashCollected,
      double upiCollected,
      double freeTotal,
      double totalCollected,
    })
  >
  getPaymentSummary({
    required String merchantId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) => OrderSummaryCalculator.calculatePaymentSummary(
    db: _db,
    merchantId: merchantId,
    storeId: storeId,
    fromDate: fromDate,
    toDate: toDate,
  );

  /// Counts total orders matching filter parameters.
  Future<int> count({
    required String merchantId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
    String? paymentMethod,
    String? status,
    String? paymentStatus,
  }) async {
    var query = _db.orders.where(
      (o) => o.merchantId.equals(ts.toExpr(merchantId)),
    );

    if (storeId != null) {
      query = query.where((o) => o.storeId.equals(ts.toExpr(storeId)));
    }
    if (fromDate != null) {
      query = query.where((o) => o.createdAt.isAfterValue(fromDate));
    }
    if (toDate != null) {
      query = query.where((o) => o.createdAt.isBeforeValue(toDate));
    }
    if (paymentMethod != null && paymentMethod.isNotEmpty) {
      query = query.where(
        (o) => o.paymentMethod.equals(ts.toExpr(paymentMethod)),
      );
    }
    if (status != null && status.isNotEmpty) {
      query = query.where((o) => o.status.equals(ts.toExpr(status)));
    }
    if (paymentStatus != null && paymentStatus.isNotEmpty) {
      query = query.where(
        (o) => o.paymentStatus.equals(ts.toExpr(paymentStatus)),
      );
    }

    final total = await query.count().fetch();
    return total ?? 0;
  }

  /// Fetches single order row by primary key UUID.
  Future<OrderRow?> getById(String id) async {
    return _db.orders.where((o) => o.id.equals(ts.toExpr(id))).first.fetch();
  }

  /// Fetches single order row by either bill number, UUID, or reference code.
  Future<OrderRow?> getByIdOrBillNo(String idOrBillNo, String storeId) async {
    final billNo = int.tryParse(idOrBillNo);
    if (billNo != null) {
      final row = await _db.orders
          .where((o) => o.storeId.equals(ts.toExpr(storeId)))
          .where((o) => o.billNo.equals(ts.toExpr(billNo)))
          .first
          .fetch();
      if (row != null) return row;
    }

    final byId = await _db.orders
        .where((o) => o.id.equals(ts.toExpr(idOrBillNo)))
        .first
        .fetch();
    if (byId != null) return byId;

    return _db.orders
        .where((o) => o.orderReference.equals(ts.toExpr(idOrBillNo)))
        .first
        .fetch();
  }

  /// Fetches single order row by human-readable reference code.
  Future<OrderRow?> getByReference(String reference) async {
    return _db.orders
        .where((o) => o.orderReference.equals(ts.toExpr(reference)))
        .first
        .fetch();
  }

  /// Computes comprehensive Profit & Loss analytics using [ProfitLossReportQuery].
  Future<
    ({
      int total,
      List<ProfitLossItem> items,
      double totalCostPrice,
      double totalCollectedPrice,
      double totalProfit,
      double totalMarginPercentage,
    })
  >
  getProfitLossReport({
    required String merchantId,
    required String storeId,
    DateTime? fromDate,
    DateTime? toDate,
    String? searchQuery,
    int limit = 10,
    int offset = 0,
  }) {
    return ProfitLossReportQuery(db: _db).execute(
      merchantId: merchantId,
      storeId: storeId,
      fromDate: fromDate,
      toDate: toDate,
      searchQuery: searchQuery,
      limit: limit,
      offset: offset,
    );
  }

  /// Computes aggregated live dashboard metrics using [DashboardAnalyticsQuery].
  Future<Map<String, dynamic>> getDashboardAnalytics({
    required String merchantId,
    required String storeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return DashboardAnalyticsQuery(db: _db).execute(
      merchantId: merchantId,
      storeId: storeId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  /// Fetches customer order history including item details and products.
  Future<({List<Order> items, int total})> getCustomerOrders({
    required String customerId,
    String? storeId,
    String? date,
    int limit = 10,
    int offset = 0,
  }) => CustomerOrdersQuery.fetchCustomerOrders(
    db: _db,
    customerId: customerId,
    storeId: storeId,
    date: date,
    limit: limit,
    offset: offset,
  );
}
