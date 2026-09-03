import 'package:backend/config/database.dart';
import 'package:backend/repositories/platform_fee_storage_helper.dart';
import 'package:models/models.dart';
import 'package:postgres/postgres.dart';

/// Repository for calculating and settling merchant platform fees.
class PlatformFeeRepository {
  const PlatformFeeRepository({Pool<Object>? pool}) : _customPool = pool;

  final Pool<Object>? _customPool;
  Pool<Object> get pool => _customPool ?? Database.pool;

  /// Fetches unsettled platform fees summary for all stores of a merchant.
  Future<MerchantPlatformFeeSummary> getPlatformFeeSummary(
    String merchantId,
  ) async {
    final unsettledRes = await pool.execute(
      Sql.named('''
        SELECT 
          COALESCE(SUM(o.platform_fee), 0) as unsettled_amount,
          COUNT(o.id) as unsettled_orders
        FROM orders o
        JOIN stores s ON o.store_id = s.id
        WHERE s.merchant_id = @merchantId
          AND o.platform_fee_settled = FALSE
          AND o.status != 'cancelled'
          AND o.platform_fee > 0;
      '''),
      parameters: {'merchantId': merchantId},
    );

    final row = unsettledRes.firstOrNull;
    final unsettledAmount = (row?[0] as num?)?.toInt() ?? 0;
    final unsettledOrders = (row?[1] as num?)?.toInt() ?? 0;

    final settlementsRes = await pool.execute(
      Sql.named('''
        SELECT id, merchant_id, amount_in_paise, orders_count, 
               payment_gateway, payment_transaction_id, status, created_at, settled_at
        FROM platform_fee_settlements
        WHERE merchant_id = @merchantId
        ORDER BY created_at DESC
        LIMIT 20;
      '''),
      parameters: {'merchantId': merchantId},
    );

    return MerchantPlatformFeeSummary(
      unsettledAmountInPaise: unsettledAmount,
      unsettledOrdersCount: unsettledOrders,
      recentSettlements: settlementsRes
          .map(PlatformFeeStorageHelper.mapRow)
          .toList(),
    );
  }

  /// Fetches all pending settlements for a merchant.
  Future<List<PlatformFeeSettlement>> getPendingSettlements(
    String merchantId,
  ) async {
    final res = await pool.execute(
      Sql.named('''
        SELECT id, merchant_id, amount_in_paise, orders_count, 
               payment_gateway, payment_transaction_id, status, created_at, settled_at
        FROM platform_fee_settlements
        WHERE merchant_id = @merchantId AND status = 'pending'
        ORDER BY created_at DESC;
      '''),
      parameters: {'merchantId': merchantId},
    );
    return res.map(PlatformFeeStorageHelper.mapRow).toList();
  }

  /// Creates a new pending settlement record.
  Future<PlatformFeeSettlement> createSettlement({
    required String merchantId,
    required int amountInPaise,
    required int ordersCount,
    required String paymentGateway,
  }) async {
    final res = await pool.execute(
      Sql.named('''
        INSERT INTO platform_fee_settlements 
          (merchant_id, amount_in_paise, orders_count, payment_gateway, status)
        VALUES 
          (@merchantId, @amountInPaise, @ordersCount, @paymentGateway, 'pending')
        RETURNING id, merchant_id, amount_in_paise, orders_count, 
                  payment_gateway, payment_transaction_id, status, created_at, settled_at;
      '''),
      parameters: {
        'merchantId': merchantId,
        'amountInPaise': amountInPaise,
        'ordersCount': ordersCount,
        'paymentGateway': paymentGateway,
      },
    );

    return PlatformFeeStorageHelper.mapRow(res.first);
  }

  /// Marks a settlement completed and tags all pending orders as settled.
  Future<void> markSettlementCompleted({
    required String settlementId,
    required String paymentTransactionId,
  }) => PlatformFeeStorageHelper.completeSettlement(
    pool: pool,
    settlementId: settlementId,
    paymentTransactionId: paymentTransactionId,
  );

  /// Marks a settlement as failed.
  Future<void> markSettlementFailed(String settlementId) async {
    await pool.execute(
      Sql.named('''
        UPDATE platform_fee_settlements
        SET status = 'failed'
        WHERE id = @settlementId;
      '''),
      parameters: {'settlementId': settlementId},
    );
  }
}
