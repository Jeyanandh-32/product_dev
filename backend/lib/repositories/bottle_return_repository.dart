import 'package:backend/database/schema.dart';
import 'package:backend/extensions/bottle_return_row_extension.dart';
import 'package:backend/repositories/bottle_credit_handler.dart';
import 'package:backend/repositories/bottle_token_handler.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Repository managing bottle return configurations, QR tokens, and credit balances.
class BottleReturnRepository {
  const BottleReturnRepository({required this.db});

  final ts.Database<DatabaseSchema> db;

  BottleCreditHandler get _credits => BottleCreditHandler(db);
  BottleTokenHandler get _tokens => BottleTokenHandler(db);

  /// Retrieves store bottle return configuration or null if not provisioned.
  Future<BottleReturnConfig?> getConfig(String storeId) async {
    final rows = await db.bottleReturnConfigs
        .where((c) => c.storeId.equals(ts.toExpr(storeId)))
        .fetch();
    return rows.isEmpty ? null : rows.first.toModel();
  }

  /// Updates store bottle return configuration for provisioned stores.
  /// Stores can only be added to bottle_return_configs directly via database.
  Future<BottleReturnConfig> saveConfig({
    required String storeId,
    bool isEnabled = true,
    int rewardAmountInRupees = 10,
    String? iotApiKey,
  }) async {
    final existing = await getConfig(storeId);
    if (existing == null) {
      throw ArgumentError(
        'Store $storeId is not provisioned in bottle_return_configs. Stores must be added directly via database.',
      );
    }
    final updated = await db.bottleReturnConfigs
        .where((c) => c.storeId.equals(ts.toExpr(storeId)))
        .update(
          (c, set) => set(
            isEnabled: ts.toExpr(isEnabled),
            rewardAmountInRupees: ts.toExpr(rewardAmountInRupees),
            iotApiKey: iotApiKey != null ? ts.toExpr(iotApiKey) : c.iotApiKey,
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returnUpdated()
        .executeAndFetch();
    return updated.first.toModel();
  }

  /// Generates unique bottle QR tokens for returnable order items (idempotent per order).
  Future<List<BottleQrToken>> generateTokensForOrder({
    required String merchantId,
    required String storeId,
    required String orderId,
    required List<({String productId, int quantity, bool isReturnable})> items,
    required BottleRewardMode rewardMode,
    String? customerPhone,
  }) => _tokens.generateTokensForOrder(
    merchantId: merchantId,
    storeId: storeId,
    orderId: orderId,
    items: items,
    rewardMode: rewardMode,
    customerPhone: customerPhone,
  );

  /// Gets all generated tokens for a specific order.
  Future<List<BottleQrToken>> getTokensByOrderId(String orderId) =>
      _tokens.getTokensByOrderId(orderId);

  /// Fetches merchant-wide customer phone wallet balance.
  Future<int> getPhoneCreditBalance({
    required String merchantId,
    required String customerPhone,
  }) => _credits.getPhoneCreditBalance(
    merchantId: merchantId,
    customerPhone: customerPhone,
  );

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
  }) => _credits.validatePhysicalCoupon(
    merchantId: merchantId,
    code: code,
    storeId: storeId,
  );

  /// Marks a physical paper coupon voucher as redeemed upon order completion.
  Future<bool> redeemPhysicalCoupon({
    required String merchantId,
    required String code,
    required String storeId,
    required String orderId,
  }) => _credits.redeemPhysicalCoupon(
    merchantId: merchantId,
    code: code,
    storeId: storeId,
    orderId: orderId,
  );
}
