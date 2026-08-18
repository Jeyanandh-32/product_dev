import 'package:backend/database/schema.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Query builder helper for filtered orders listing, lookup, and counting.
class OrderQueryBuilder {
  const OrderQueryBuilder._();

  /// Fetches orders filtered by merchant, store, tab source, date range, and pagination.
  static Future<List<OrderRow>> getAll({
    required ts.Database<DatabaseSchema> db,
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
  }) async {
    var query = db.orders.where((o) => o.merchantId.equals(ts.toExpr(merchantId)));

    if (storeId != null) query = query.where((o) => o.storeId.equals(ts.toExpr(storeId)));
    if (source != null && source.isNotEmpty) {
      if (source == 'online') {
        query = query.where((o) => o.source.equals(ts.toExpr(OrderSource.web.name)).or(o.source.equals(ts.toExpr(OrderSource.mobileApp.name))));
      } else {
        query = query.where((o) => o.source.equals(ts.toExpr(source)));
      }
    }
    if (terminalCode != null && terminalCode.isNotEmpty) {
      query = query.where((o) => o.terminalCode.equals(ts.toExpr(terminalCode)));
    }
    if (fromDate != null) query = query.where((o) => o.createdAt.isAfterValue(fromDate));
    if (toDate != null) query = query.where((o) => o.createdAt.isBeforeValue(toDate));
    if (paymentMethod != null && paymentMethod.isNotEmpty) {
      query = query.where((o) => o.paymentMethod.equals(ts.toExpr(paymentMethod)));
    }
    if (status != null && status.isNotEmpty) query = query.where((o) => o.status.equals(ts.toExpr(status)));
    if (paymentStatus != null && paymentStatus.isNotEmpty) {
      query = query.where((o) => o.paymentStatus.equals(ts.toExpr(paymentStatus)));
    }
    if (offset != null) query = query.offset(offset);
    if (limit != null) query = query.limit(limit);

    return query.orderBy((o) => [(o.createdAt, ts.Order.descending)]).fetch();
  }

  /// Counts total orders matching filter parameters.
  static Future<int> count({
    required ts.Database<DatabaseSchema> db,
    required String merchantId,
    String? storeId,
    String? source,
    String? terminalCode,
    DateTime? fromDate,
    DateTime? toDate,
    String? paymentMethod,
    String? status,
    String? paymentStatus,
  }) async {
    var query = db.orders.where((o) => o.merchantId.equals(ts.toExpr(merchantId)));

    if (storeId != null) query = query.where((o) => o.storeId.equals(ts.toExpr(storeId)));
    if (source != null && source.isNotEmpty) {
      if (source == 'online') {
        query = query.where((o) => o.source.equals(ts.toExpr(OrderSource.web.name)).or(o.source.equals(ts.toExpr(OrderSource.mobileApp.name))));
      } else {
        query = query.where((o) => o.source.equals(ts.toExpr(source)));
      }
    }
    if (terminalCode != null && terminalCode.isNotEmpty) {
      query = query.where((o) => o.terminalCode.equals(ts.toExpr(terminalCode)));
    }
    if (fromDate != null) query = query.where((o) => o.createdAt.isAfterValue(fromDate));
    if (toDate != null) query = query.where((o) => o.createdAt.isBeforeValue(toDate));
    if (paymentMethod != null && paymentMethod.isNotEmpty) {
      query = query.where((o) => o.paymentMethod.equals(ts.toExpr(paymentMethod)));
    }
    if (status != null && status.isNotEmpty) query = query.where((o) => o.status.equals(ts.toExpr(status)));
    if (paymentStatus != null && paymentStatus.isNotEmpty) {
      query = query.where((o) => o.paymentStatus.equals(ts.toExpr(paymentStatus)));
    }

    final total = await query.count().fetch();
    return total ?? 0;
  }

  /// Fetches single order row by either bill number, UUID, or reference code.
  static Future<OrderRow?> getByIdOrBillNo({
    required ts.Database<DatabaseSchema> db,
    required String idOrBillNo,
    required String storeId,
  }) async {
    final billNo = int.tryParse(idOrBillNo);
    if (billNo != null) {
      final row = await db.orders
          .where((o) => o.storeId.equals(ts.toExpr(storeId)))
          .where((o) => o.billNo.equals(ts.toExpr(billNo)))
          .first
          .fetch();
      if (row != null) return row;
    }

    final byId = await db.orders.where((o) => o.id.equals(ts.toExpr(idOrBillNo))).first.fetch();
    if (byId != null) return byId;

    return db.orders.where((o) => o.orderReference.equals(ts.toExpr(idOrBillNo))).first.fetch();
  }
}
