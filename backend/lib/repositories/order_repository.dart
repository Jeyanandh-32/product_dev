import 'package:backend/database/schema.dart';
import 'package:backend/repositories/customer_orders_query.dart';
import 'package:backend/repositories/order_mutation_repository.dart';
import 'package:backend/repositories/order_query_builder.dart';
import 'package:backend/repositories/order_reports_repository.dart';
import 'package:backend/repositories/order_types.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Repository for handling order queries, creation, and reports.
class OrderRepository {
  OrderRepository({required ts.Database<DatabaseSchema> db})
      : _db = db,
        _mutationRepo = OrderMutationRepository(db: db),
        _reportsRepo = OrderReportsRepository(db: db);

  final ts.Database<DatabaseSchema> _db;
  final OrderMutationRepository _mutationRepo;
  final OrderReportsRepository _reportsRepo;

  /// Inserts a new order row into the database.
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
  }) => _mutationRepo.create(
    merchantId: merchantId, storeId: storeId, orderReference: orderReference,
    billNo: billNo, source: source, type: type, status: status,
    paymentStatus: paymentStatus, paymentMethod: paymentMethod,
    subtotal: subtotal, discountTotal: discountTotal, taxTotal: taxTotal,
    grandTotal: grandTotal, walletDeduction: walletDeduction,
    terminalCode: terminalCode, customerId: customerId,
  );

  /// Returns the next incremental daily bill number for a store.
  Future<int> getNextBillNo(String storeId) => _mutationRepo.getNextBillNo(storeId);

  /// Updates existing order state, payment status, or payment method.
  Future<OrderRow?> update({
    required String id,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    PaymentMethod? paymentMethod,
    String? terminalCode,
  }) => _mutationRepo.update(
    id: id, status: status, paymentStatus: paymentStatus,
    paymentMethod: paymentMethod, terminalCode: terminalCode,
  );

  /// Fetches orders filtered by store, source, date range, and pagination.
  Future<List<OrderRow>> getAll({
    required String merchantId,
    String? storeId,
    String? source,
    String? terminalCode,
    DateTime? fromDate,
    DateTime? toDate,
    String? paymentMethod,
    String? status,
    String? paymentStatus,
    int? limit,
    int? offset,
  }) => OrderQueryBuilder.getAll(
    db: _db, merchantId: merchantId, storeId: storeId, source: source,
    terminalCode: terminalCode, fromDate: fromDate, toDate: toDate,
    paymentMethod: paymentMethod, status: status, paymentStatus: paymentStatus,
    limit: limit, offset: offset,
  );

  /// Counts total orders matching filter parameters.
  Future<int> count({
    required String merchantId,
    String? storeId,
    String? source,
    String? terminalCode,
    DateTime? fromDate,
    DateTime? toDate,
    String? paymentMethod,
    String? status,
    String? paymentStatus,
  }) => OrderQueryBuilder.count(
    db: _db, merchantId: merchantId, storeId: storeId, source: source,
    terminalCode: terminalCode, fromDate: fromDate, toDate: toDate,
    paymentMethod: paymentMethod, status: status, paymentStatus: paymentStatus,
  );

  /// Fetches single order row by primary key UUID.
  Future<OrderRow?> getById(String id) => _db.orders.where((o) => o.id.equals(ts.toExpr(id))).first.fetch();

  /// Fetches single order row by either bill number, UUID, or reference code.
  Future<OrderRow?> getByIdOrBillNo(String idOrBillNo, String storeId) =>
      OrderQueryBuilder.getByIdOrBillNo(db: _db, idOrBillNo: idOrBillNo, storeId: storeId);

  /// Fetches single order row by human-readable reference code.
  Future<OrderRow?> getByReference(String reference) =>
      _db.orders.where((o) => o.orderReference.equals(ts.toExpr(reference))).first.fetch();

  /// Computes order summary totals.
  Future<OrderSummaryResult> getOrderSummary({required String merchantId, String? storeId, DateTime? fromDate, DateTime? toDate}) =>
      _reportsRepo.getOrderSummary(merchantId: merchantId, storeId: storeId, fromDate: fromDate, toDate: toDate);

  /// Computes collected payments summary categorized by payment method.
  Future<PaymentSummaryResult> getPaymentSummary({required String merchantId, String? storeId, DateTime? fromDate, DateTime? toDate}) =>
      _reportsRepo.getPaymentSummary(merchantId: merchantId, storeId: storeId, fromDate: fromDate, toDate: toDate);

  /// Computes comprehensive Profit & Loss analytics report.
  Future<ProfitLossReportResult> getProfitLossReport({
    required String merchantId,
    required String storeId,
    DateTime? fromDate,
    DateTime? toDate,
    String? searchQuery,
    int limit = 10,
    int offset = 0,
  }) => _reportsRepo.getProfitLossReport(
    merchantId: merchantId, storeId: storeId, fromDate: fromDate,
    toDate: toDate, searchQuery: searchQuery, limit: limit, offset: offset,
  );

  /// Computes aggregated live dashboard metrics.
  Future<Map<String, dynamic>> getDashboardAnalytics({required String merchantId, required String storeId, DateTime? fromDate, DateTime? toDate}) =>
      _reportsRepo.getDashboardAnalytics(merchantId: merchantId, storeId: storeId, fromDate: fromDate, toDate: toDate);

  /// Fetches customer order history including item details and products.
  Future<({List<Order> items, int total})> getCustomerOrders({
    required String customerId,
    String? storeId,
    String? date,
    int limit = 10,
    int offset = 0,
  }) => CustomerOrdersQuery.fetchCustomerOrders(
    db: _db, customerId: customerId, storeId: storeId, date: date, limit: limit, offset: offset,
  );
}
