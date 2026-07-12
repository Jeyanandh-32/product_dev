import 'package:backend/database/schema.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

class OrderRepository {
  OrderRepository({required ts.Database<DatabaseSchema> db}) : _db = db;

  final ts.Database<DatabaseSchema> _db;

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
    required int taxTotal,
    required int grandTotal,
    String? terminalCode,
  }) async {
    final row = _db.orders
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
          taxTotal: taxTotal,
          grandTotal: grandTotal,
          terminalCode: terminalCode,
        )
        .returnInserted()
        .executeAndFetch();

    return row;
  }

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

  Future<List<OrderRow>> getAll({
    required String merchantId,
    String? storeId,
    int? limit,
    int? offset,
  }) async {
    var query = _db.orders.where(
      (o) => o.merchantId.equals(ts.toExpr(merchantId)),
    );

    if (storeId != null) {
      query = query.where((o) => o.storeId.equals(ts.toExpr(storeId)));
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

  Future<OrderRow?> getById(String id) async {
    final row = _db.orders
        .where((o) => o.id.equals(ts.toExpr(id)))
        .first
        .fetch();

    return row;
  }

  Future<OrderRow?> getByReference(String reference) async {
    final row = _db.orders
        .where((o) => o.orderReference.equals(ts.toExpr(reference)))
        .first
        .fetch();

    return row;
  }
}
