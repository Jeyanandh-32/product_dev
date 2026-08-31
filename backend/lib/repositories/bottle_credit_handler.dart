import 'package:backend/database/schema.dart';
import 'package:backend/extensions/bottle_return_row_extension.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Dedicated handler for bottle credit wallet and physical paper coupon redemption.
class BottleCreditHandler {
  const BottleCreditHandler(this.db);

  final ts.Database<DatabaseSchema> db;

  /// Fetches merchant-wide customer phone wallet balance.
  Future<int> getPhoneCreditBalance({
    required String merchantId,
    required String customerPhone,
  }) async {
    final rows = await db.bottleCredits
        .where(
          (c) =>
              c.merchantId.equals(ts.toExpr(merchantId)) &
              c.customerPhone.equals(ts.toExpr(customerPhone)),
        )
        .fetch();
    return rows.isEmpty ? 0 : rows.first.balance;
  }

  /// Debits credit balance when customer applies reward discount during checkout.
  Future<bool> applyCreditDeduction({
    required String merchantId,
    required String customerPhone,
    required int amount,
    required String storeId,
    String? orderId,
  }) async {
    final rows = await db.bottleCredits
        .where(
          (c) =>
              c.merchantId.equals(ts.toExpr(merchantId)) &
              c.customerPhone.equals(ts.toExpr(customerPhone)),
        )
        .fetch();
    if (rows.isEmpty || rows.first.balance < amount) return false;
    await db.bottleCredits
        .where((c) => c.id.equals(ts.toExpr(rows.first.id)))
        .update(
          (c, set) => set(
            balance: c.balance.subtractValue(amount),
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .execute();
    await db.bottleCreditTransactions
        .insertValue(
          merchantId: merchantId,
          customerPhone: customerPhone,
          amount: amount,
          type: BottleCreditTransactionType.debit.name,
          referenceOrderId: orderId,
          storeId: storeId,
        )
        .execute();
    return true;
  }

  /// Validates a physical paper coupon voucher without redeeming it.
  Future<BottlePhysicalCoupon?> validatePhysicalCoupon({
    required String merchantId,
    required String code,
    required String storeId,
  }) async {
    final rows = await db.bottlePhysicalCoupons
        .where(
          (c) =>
              c.merchantId.equals(ts.toExpr(merchantId)) &
              c.code.equals(ts.toExpr(code.trim().toUpperCase())),
        )
        .fetch();
    if (rows.isEmpty || rows.first.status != BottleCouponStatus.active.name) {
      return null;
    }
    return rows.first.toModel();
  }

  /// Marks a physical paper coupon voucher as redeemed upon order completion.
  Future<bool> redeemPhysicalCoupon({
    required String merchantId,
    required String code,
    required String storeId,
    required String orderId,
  }) async {
    final rows = await db.bottlePhysicalCoupons
        .where(
          (c) =>
              c.merchantId.equals(ts.toExpr(merchantId)) &
              c.code.equals(ts.toExpr(code.trim().toUpperCase())),
        )
        .fetch();
    if (rows.isEmpty || rows.first.status != BottleCouponStatus.active.name) {
      return false;
    }
    await db.bottlePhysicalCoupons
        .where((c) => c.id.equals(ts.toExpr(rows.first.id)))
        .update(
          (c, set) => set(
            status: ts.toExpr(BottleCouponStatus.redeemed.name),
            redeemedAt: ts.Expr.currentTimestamp,
            redeemedOrderId: ts.toExpr(orderId),
          ),
        )
        .execute();
    return true;
  }
}
