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
}
