import 'package:backend/database/schema.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Database mutation helper for finalizing platform fee settlements.
abstract final class PlatformFeeStorageHelper {
  /// Completes a settlement and marks eligible completed orders as settled.
  static Future<void> completeSettlement({
    required ts.Database<DatabaseSchema> db,
    required String settlementId,
    required String paymentTransactionId,
  }) async {
    final updatedRow = await db.platformFeeSettlements
        .byKey(settlementId)
        .update(
          (s, set) => set(
            status: ts.toExpr(SettlementStatus.completed.name),
            paymentTransactionId: ts.toExpr(paymentTransactionId),
            settledAt: ts.toExpr(DateTime.now().toUtc()),
          ),
        )
        .returnUpdated()
        .executeAndFetch();

    final merchantId = updatedRow?.merchantId;
    if (merchantId == null) return;

    await db.orders
        .where((o) => o.merchantId.equals(ts.toExpr(merchantId)))
        .where((o) => o.platformFeeSettled.equals(ts.toExpr(false)))
        .where((o) => o.status.notEquals(ts.toExpr(OrderStatus.cancelled.name)))
        .where(
          (o) => o.paymentStatus.equals(
            ts.toExpr(PaymentStatus.completed.name),
          ),
        )
        .where((o) => o.platformFee > ts.toExpr(0))
        .update(
          (o, set) => set(
            platformFeeSettled: ts.toExpr(true),
            platformFeeSettlementId: ts.toExpr(settlementId),
          ),
        )
        .execute();
  }
}
