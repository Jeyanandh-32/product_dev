import 'package:backend/database/schema.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

class StockRepository {
  StockRepository({required ts.Database<DatabaseSchema> db}) : _db = db;

  final ts.Database<DatabaseSchema> _db;

  Future<StockRow> create({
    required String productId,
    required String storeId,
  }) async {
    final row = await _db.stocks
        .insertValue(
          productId: productId,
          storeId: storeId,
        )
        .returning((ts.Expr<StockRow> s) => (s,))
        .executeAndFetch();

    return row;
  }

  Future<StockRow?> update({
    required String id,
    int? quantity,
    int? lowStockThreshold,
    bool? stockMonitor,
  }) async {
    final rows = await _db.stocks
        .where((ts.Expr<StockRow> s) => s.id.equalsValue(id))
        .update(
          (s, set) => set(
            quantity: quantity != null ? ts.toExpr(quantity) : s.quantity,
            lowStockThreshold: lowStockThreshold != null
                ? ts.toExpr(lowStockThreshold)
                : s.lowStockThreshold,
            stockMonitor:
                stockMonitor != null ? ts.toExpr(stockMonitor) : s.stockMonitor,
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returning((ts.Expr<StockRow> s) => (s,))
        .executeAndFetch();

    if (rows.isEmpty) return null;
    return rows.first;
  }
}
