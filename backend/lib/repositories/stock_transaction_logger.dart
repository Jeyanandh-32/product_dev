import 'package:backend/database/schema.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Helper handler for recording and normalizing stock inventory audit transactions.
class StockTransactionLogger {
  const StockTransactionLogger._();

  /// Logs an adjustment transaction in `stock_transactions` table.
  static Future<void> logAdjustment({
    required ts.Database<DatabaseSchema> db,
    required StockRow stockRow,
    int? targetQuantity,
    String? transactionType,
    int? amount,
    String? reason,
    String? customReason,
  }) async {
    if (transactionType == null || amount == null) return;

    var actualType = transactionType;
    var actualAmount = amount;

    if (transactionType == 'set' && targetQuantity != null) {
      final delta = targetQuantity - stockRow.quantity;
      if (delta > 0) {
        actualType = 'add';
        actualAmount = delta;
      } else if (delta < 0) {
        actualType = 'reduce';
        actualAmount = delta.abs();
      } else {
        actualAmount = 0;
      }
    }

    final actualReason = reason ?? (actualType == 'add' ? 'restock' : 'adjustment');

    if (actualAmount > 0) {
      await db.stockTransactions
          .insertValue(
            productId: stockRow.productId,
            storeId: stockRow.storeId,
            adjustmentType: actualType,
            quantity: actualAmount,
            reason: actualReason,
            customReason: customReason,
          )
          .execute();
    }
  }
}
