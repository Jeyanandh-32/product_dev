import 'package:backend/database/schema.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

class OrderItemRepository {
  OrderItemRepository({required ts.Database<DatabaseSchema> db}) : _db = db;

  final ts.Database<DatabaseSchema> _db;

  Future<List<OrderItemRow>> getAllForOrder(String orderId) async {
    return _db.orderItems
        .where((item) => item.orderId.equals(ts.toExpr(orderId)))
        .fetch();
  }

  Future<List<OrderItemRow>> getAllForOrders(List<String> orderIds) async {
    if (orderIds.isEmpty) return const [];

    return _db.orderItems.where((item) {
      var expr = item.orderId.equals(ts.toExpr(orderIds.first));
      for (var i = 1; i < orderIds.length; i++) {
        expr = expr.or(item.orderId.equals(ts.toExpr(orderIds[i])));
      }
      return expr;
    }).fetch();
  }

  Future<OrderItemRow> create({
    required String orderId,
    required String productId,
    required String storeId,
    required int quantity,
    required int unitPrice,
    required double taxRate,
  }) async {
    final row = _db.orderItems
        .insertValue(
          orderId: orderId,
          productId: productId,
          storeId: storeId,
          quantity: quantity,
          unitPrice: unitPrice,
          taxRate: taxRate,
        )
        .returnInserted()
        .executeAndFetch();

    return row;
  }

  Future<List<OrderItemRow>> createItems(List<OrderItemRow> items) async {
    final rows = _db.orderItems
        .insertValuesMapped(
          items,
          orderId: (o) => o.orderId,
          productId: (o) => o.productId,
          storeId: (o) => o.storeId,
          quantity: (o) => o.quantity,
          unitPrice: (o) => o.unitPrice,
          taxRate: (o) => o.taxRate,
        )
        .returnInserted()
        .executeAndFetch();

    return rows;
  }
}
