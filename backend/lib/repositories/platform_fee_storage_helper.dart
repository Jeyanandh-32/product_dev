import 'package:models/models.dart';
import 'package:postgres/postgres.dart';

/// Low-level SQL mapping and mutation helper for platform fee settlements.
abstract final class PlatformFeeStorageHelper {
  /// Maps a PostgreSQL row into a [PlatformFeeSettlement] model.
  static PlatformFeeSettlement mapRow(List<dynamic> r) => PlatformFeeSettlement(
    id: '${r[0]}',
    merchantId: '${r[1]}',
    amountInPaise: (r[2] as num?)?.toInt() ?? 0,
    ordersCount: (r[3] as num?)?.toInt() ?? 0,
    paymentGateway: '${r[4]}',
    paymentTransactionId: r[5]?.toString(),
    status: '${r[6]}',
    createdAt: r[7] as DateTime?,
    settledAt: r[8] as DateTime?,
  );

  /// Completes a settlement and marks related orders as settled.
  static Future<void> completeSettlement({
    required Pool<Object> pool,
    required String settlementId,
    required String paymentTransactionId,
  }) async {
    final res = await pool.execute(
      Sql.named('''
        UPDATE platform_fee_settlements
        SET status = 'completed',
            payment_transaction_id = @txId,
            settled_at = NOW()
        WHERE id = @settlementId
        RETURNING merchant_id;
      '''),
      parameters: {
        'settlementId': settlementId,
        'txId': paymentTransactionId,
      },
    );

    final merchantId = res.firstOrNull?[0] as String?;
    if (merchantId == null) return;

    await pool.execute(
      Sql.named('''
        UPDATE orders
        SET platform_fee_settled = TRUE,
            platform_fee_settlement_id = @settlementId
        WHERE store_id IN (SELECT id FROM stores WHERE merchant_id = @merchantId)
          AND platform_fee_settled = FALSE
          AND status != 'cancelled'
          AND platform_fee > 0;
      '''),
      parameters: {
        'settlementId': settlementId,
        'merchantId': merchantId,
      },
    );
  }
}
