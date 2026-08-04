import 'package:backend/database/schema.dart';
import 'package:models/models.dart';
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
        .returnInserted()
        .executeAndFetch();

    return row;
  }

  Future<StockRow?> update({
    required String id,
    int? quantity,
    int? lowStockThreshold,
    bool? stockMonitor,
    String? adjustmentType,
    int? amount,
    String? reason,
    String? customReason,
  }) async {
    final stockRows = await _db.stocks
        .where((ts.Expr<StockRow> s) => s.id.equalsValue(id))
        .fetch();

    if (stockRows.isEmpty) return null;
    final stockRow = stockRows.first;

    if (adjustmentType != null && amount != null && reason != null) {
      final productRow = await _db.products.byKey(stockRow.productId).fetch();
      final basePricePaise = productRow?.basePrice ?? 0;
      final isWastage =
          reason.toLowerCase() == StockAdjustmentReason.wastage.name;
      final wastageLossPaise = isWastage ? (basePricePaise * amount) : 0;

      await _db.stockAdjustments
          .insertValue(
            productId: stockRow.productId,
            storeId: stockRow.storeId,
            adjustmentType: adjustmentType,
            quantity: amount,
            reason: reason,
            customReason: customReason,
            wastageLossPaise: wastageLossPaise,
          )
          .execute();
    }

    final rows = await _db.stocks
        .where((ts.Expr<StockRow> s) => s.id.equalsValue(id))
        .update(
          (s, set) => set(
            quantity: quantity != null ? ts.toExpr(quantity) : s.quantity,
            lowStockThreshold: lowStockThreshold != null
                ? ts.toExpr(lowStockThreshold)
                : s.lowStockThreshold,
            stockMonitor: stockMonitor != null
                ? ts.toExpr(stockMonitor)
                : s.stockMonitor,
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returnUpdated()
        .executeAndFetch();

    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<StockRow?> getByProductAndStore({
    required String productId,
    required String storeId,
  }) async {
    final rows = await _db.stocks
        .where((s) => s.productId.equals(ts.toExpr(productId)))
        .where((s) => s.storeId.equals(ts.toExpr(storeId)))
        .fetch();

    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<StockRow?> deductStock({
    required String productId,
    required String storeId,
    required int quantityToDeduct,
  }) async {
    final rows = await _db.stocks
        .where((s) => s.productId.equals(ts.toExpr(productId)))
        .where((s) => s.storeId.equals(ts.toExpr(storeId)))
        .update(
          (s, set) => set(
            quantity: s.quantity.subtractValue(quantityToDeduct),
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returnUpdated()
        .executeAndFetch();

    if (rows.isEmpty) return null;
    return rows.first;
  }
}
