import 'dart:math';
import 'package:backend/database/schema.dart';
import 'package:backend/extensions/bottle_return_row_extension.dart';
import 'package:backend/repositories/bottle_credit_handler.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Repository managing bottle return configurations, QR tokens, and credit balances.
class BottleReturnRepository {
  const BottleReturnRepository({required this.db});

  final ts.Database<DatabaseSchema> db;

  BottleCreditHandler get _credits => BottleCreditHandler(db);

  /// Retrieves store bottle return configuration or null if not provisioned.
  Future<BottleReturnConfig?> getConfig(String storeId) async {
    final rows = await db.bottleReturnConfigs.where((c) => c.storeId.equals(ts.toExpr(storeId))).fetch();
    return rows.isEmpty ? null : rows.first.toModel();
  }

  /// Developer provisioning helper to enable/update store configuration.
  Future<BottleReturnConfig> saveConfig({
    required String storeId,
    bool isEnabled = true,
    int rewardAmountInRupees = 10,
    String? iotApiKey,
  }) async {
    final existing = await getConfig(storeId);
    if (existing != null) {
      final updated = await db.bottleReturnConfigs.where((c) => c.storeId.equals(ts.toExpr(storeId))).update(
        (c, set) => set(
          isEnabled: ts.toExpr(isEnabled),
          rewardAmountInRupees: ts.toExpr(rewardAmountInRupees),
          iotApiKey: iotApiKey != null ? ts.toExpr(iotApiKey) : c.iotApiKey,
          updatedAt: ts.Expr.currentTimestamp,
        ),
      ).returnUpdated().executeAndFetch();
      return updated.first.toModel();
    }
    final inserted = await db.bottleReturnConfigs.insertValue(
      storeId: storeId,
      isEnabled: isEnabled,
      rewardAmountInRupees: rewardAmountInRupees,
      iotApiKey: iotApiKey,
    ).returnInserted().executeAndFetch();
    return inserted.toModel();
  }

  /// Generates unique bottle QR tokens for returnable order items (idempotent per order).
  Future<List<BottleQrToken>> generateTokensForOrder({
    required String merchantId,
    required String storeId,
    required String orderId,
    required List<({String productId, int quantity, bool isReturnable})> items,
    required BottleRewardMode rewardMode,
    String? customerPhone,
  }) async {
    final existingTokens = await getTokensByOrderId(orderId);
    if (existingTokens.isNotEmpty) {
      if (customerPhone != null || rewardMode != BottleRewardMode.digital) {
        for (final tok in existingTokens) {
          await db.bottleQrTokens.where((t) => t.id.equals(ts.toExpr(tok.id))).update(
            (t, set) => set(
              rewardMode: ts.toExpr(rewardMode.name),
              customerPhone: customerPhone != null ? ts.toExpr(customerPhone) : t.customerPhone,
            ),
          ).execute();
        }
        return getTokensByOrderId(orderId);
      }
      return existingTokens;
    }

    final generated = <BottleQrToken>[];
    final rand = Random();
    for (final item in items) {
      if (!item.isReturnable) continue;
      for (var i = 0; i < item.quantity; i++) {
        final tokenStr = 'BTL_${DateTime.now().microsecondsSinceEpoch.toRadixString(36).toUpperCase()}_${rand.nextInt(999999).toString().padLeft(6, '0')}';
        final row = await db.bottleQrTokens.insertValue(
          token: tokenStr,
          merchantId: merchantId,
          storeId: storeId,
          orderId: orderId,
          productId: item.productId,
          rewardMode: rewardMode.name,
          customerPhone: customerPhone,
          status: 'active',
        ).returnInserted().executeAndFetch();
        generated.add(row.toModel());
      }
    }
    return generated;
  }

  /// Gets all generated tokens for a specific order.
  Future<List<BottleQrToken>> getTokensByOrderId(String orderId) async {
    final rows = await db.bottleQrTokens.where((t) => t.orderId.equals(ts.toExpr(orderId))).fetch();
    return rows.map((r) => r.toModel()).toList();
  }

  /// Fetches merchant-wide customer phone wallet balance.
  Future<int> getPhoneCreditBalance({required String merchantId, required String customerPhone}) =>
      _credits.getPhoneCreditBalance(merchantId: merchantId, customerPhone: customerPhone);

  /// Debits credit balance when customer applies reward discount during checkout.
  Future<bool> applyCreditDeduction({
    required String merchantId,
    required String customerPhone,
    required int amount,
    required String storeId,
    String? orderId,
  }) => _credits.applyCreditDeduction(
    merchantId: merchantId,
    customerPhone: customerPhone,
    amount: amount,
    storeId: storeId,
    orderId: orderId,
  );

  /// Validates a physical paper coupon voucher without redeeming it.
  Future<BottlePhysicalCoupon?> validatePhysicalCoupon({
    required String merchantId,
    required String code,
    required String storeId,
  }) => _credits.validatePhysicalCoupon(merchantId: merchantId, code: code, storeId: storeId);

  /// Marks a physical paper coupon voucher as redeemed upon order completion.
  Future<bool> redeemPhysicalCoupon({
    required String merchantId,
    required String code,
    required String storeId,
    required String orderId,
  }) => _credits.redeemPhysicalCoupon(merchantId: merchantId, code: code, storeId: storeId, orderId: orderId);
}
