import 'package:backend/database/schema.dart';
import 'package:backend/repositories/customer_orders_query.dart';
import 'package:backend/repositories/order_query_builder.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Mixin providing order query filtering and pagination to the order repository.
mixin OrderQueryFacade {
  /// Access to the underlying database instance.
  ts.Database<DatabaseSchema> get db;

  /// Fetches orders filtered by criteria.
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
    db: db,
    merchantId: merchantId,
    storeId: storeId,
    source: source,
    terminalCode: terminalCode,
    fromDate: fromDate,
    toDate: toDate,
    paymentMethod: paymentMethod,
    status: status,
    paymentStatus: paymentStatus,
    limit: limit,
    offset: offset,
  );

  /// Counts total orders matching filter criteria.
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
    db: db,
    merchantId: merchantId,
    storeId: storeId,
    source: source,
    terminalCode: terminalCode,
    fromDate: fromDate,
    toDate: toDate,
    paymentMethod: paymentMethod,
    status: status,
    paymentStatus: paymentStatus,
  );

  /// Fetches customer order history.
  Future<({List<Order> items, int total})> getCustomerOrders({
    required String customerId,
    String? storeId,
    String? date,
    String? fromDate,
    String? toDate,
    int limit = 10,
    int offset = 0,
  }) => CustomerOrdersQuery.fetchCustomerOrders(
    db: db,
    customerId: customerId,
    storeId: storeId,
    date: date,
    fromDate: fromDate,
    toDate: toDate,
    limit: limit,
    offset: offset,
  );

  /// Fetches single order row by either bill number, UUID, or reference code.
  Future<OrderRow?> getByIdOrReference(String identifier, String storeId) =>
      OrderQueryBuilder.getByIdOrReference(
        db: db,
        identifier: identifier,
        storeId: storeId,
      );
}
