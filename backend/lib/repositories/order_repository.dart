import 'package:backend/database/schema.dart';
import 'package:backend/repositories/order_mutation_repository.dart';
import 'package:backend/repositories/order_query_builder.dart';
import 'package:backend/repositories/order_query_facade.dart';
import 'package:backend/repositories/order_reports_facade.dart';
import 'package:backend/repositories/order_reports_repository.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

export 'package:backend/repositories/order_query_facade.dart';
export 'package:backend/repositories/order_reports_facade.dart';

/// Repository facade for order mutations, queries, reports, and analytics.
class OrderRepository with OrderQueryFacade, OrderReportsFacade {
  /// Creates an order repository with underlying database and sub-repositories.
  OrderRepository({required ts.Database<DatabaseSchema> db})
    : _db = db,
      _mutations = OrderMutationRepository(db: db),
      _reports = OrderReportsRepository(db: db);

  final ts.Database<DatabaseSchema> _db;
  final OrderMutationRepository _mutations;
  final OrderReportsRepository _reports;

  @override
  ts.Database<DatabaseSchema> get db => _db;

  @override
  OrderReportsRepository get reports => _reports;

  /// Underlying order mutations repository.
  OrderMutationRepository get mutations => _mutations;

  /// Inserts a new order row.
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
    int platformFee = 0,
    int gatewayCharges = 0,
    String? terminalCode,
    String? customerId,
  }) => _mutations.create(
    merchantId: merchantId,
    storeId: storeId,
    orderReference: orderReference,
    billNo: billNo,
    source: source,
    type: type,
    status: status,
    paymentStatus: paymentStatus,
    paymentMethod: paymentMethod,
    subtotal: subtotal,
    discountTotal: discountTotal,
    taxTotal: taxTotal,
    grandTotal: grandTotal,
    walletDeduction: walletDeduction,
    platformFee: platformFee,
    gatewayCharges: gatewayCharges,
    terminalCode: terminalCode,
    customerId: customerId,
  );

  /// Returns the next daily bill number for a store.
  Future<int> getNextBillNo(String storeId) =>
      _mutations.getNextBillNo(storeId);

  /// Updates existing order state.
  Future<OrderRow?> update({
    required String id,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    PaymentMethod? paymentMethod,
    String? terminalCode,
  }) => _mutations.update(
    id: id,
    status: status,
    paymentStatus: paymentStatus,
    paymentMethod: paymentMethod,
    terminalCode: terminalCode,
  );

  /// Fetches order row by UUID.
  Future<OrderRow?> getById(String id) =>
      _db.orders.where((o) => o.id.equals(ts.toExpr(id))).first.fetch();

  /// Fetches order row by bill number or UUID.
  Future<OrderRow?> getByIdOrBillNo(String idOrBillNo, String storeId) =>
      OrderQueryBuilder.getByIdOrBillNo(
        db: _db,
        idOrBillNo: idOrBillNo,
        storeId: storeId,
      );

  /// Fetches order row by reference code.
  Future<OrderRow?> getByReference(String reference) => _db.orders
      .where((o) => o.orderReference.equals(ts.toExpr(reference)))
      .first
      .fetch();
}
