import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/extensions/platform_fee_settlement_row_extension.dart';
import 'package:backend/repositories/platform_fee_storage_helper.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Repository for calculating and settling merchant platform fees.
class PlatformFeeRepository {
  const PlatformFeeRepository({ts.Database<DatabaseSchema>? db}) : _customDb = db;

  final ts.Database<DatabaseSchema>? _customDb;
  ts.Database<DatabaseSchema> get db => _customDb ?? Database.db;

  /// Fetches unsettled platform fees summary for all stores of a merchant.
  Future<MerchantPlatformFeeSummary> getPlatformFeeSummary(
    String merchantId,
  ) async {
    final ordersQuery = db.orders
        .where((o) => o.merchantId.equals(ts.toExpr(merchantId)))
        .where((o) => o.platformFeeSettled.equals(ts.toExpr(false)))
        .where((o) => o.status.notEquals(ts.toExpr(OrderStatus.cancelled.name)))
        .where(
          (o) => o.paymentStatus.equals(
            ts.toExpr(PaymentStatus.completed.name),
          ),
        )
        .where((o) => o.platformFee > ts.toExpr(0));

    final (unsettledAmount, unsettledOrders) = await db.select(
      (
        ordersQuery.asSubQuery.select((o) => (o.platformFee,)).sum(),
        ordersQuery.asSubQuery.count(),
      ),
    ).fetchOrNulls();

    final settlements = await db.platformFeeSettlements
        .where((s) => s.merchantId.equals(ts.toExpr(merchantId)))
        .orderBy((s) => [(s.createdAt, ts.Order.descending)])
        .limit(20)
        .fetch();

    return MerchantPlatformFeeSummary(
      unsettledAmountInPaise: unsettledAmount ?? 0,
      unsettledOrdersCount: unsettledOrders ?? 0,
      recentSettlements: settlements.map((s) => s.toModel()).toList(),
    );
  }

  /// Fetches all pending settlements for a merchant.
  Future<List<PlatformFeeSettlement>> getPendingSettlements(
    String merchantId,
  ) async {
    final settlements = await db.platformFeeSettlements
        .where((s) => s.merchantId.equals(ts.toExpr(merchantId)))
        .where(
          (s) => s.status.equals(
            ts.toExpr(SettlementStatus.pending.name),
          ),
        )
        .orderBy((s) => [(s.createdAt, ts.Order.descending)])
        .fetch();

    return settlements.map((s) => s.toModel()).toList();
  }

  /// Creates a new pending settlement record.
  Future<PlatformFeeSettlement> createSettlement({
    required String merchantId,
    required int amountInPaise,
    required int ordersCount,
    required String paymentGateway,
  }) async {
    final row = await db.platformFeeSettlements
        .insertValue(
          merchantId: merchantId,
          amountInPaise: amountInPaise,
          ordersCount: ordersCount,
          paymentGateway: paymentGateway,
          status: SettlementStatus.pending.name,
        )
        .returnInserted()
        .executeAndFetch();

    return row.toModel();
  }

  /// Marks a settlement completed and tags eligible orders as settled.
  Future<void> markSettlementCompleted({
    required String settlementId,
    required String paymentTransactionId,
  }) =>
      PlatformFeeStorageHelper.completeSettlement(
        db: db,
        settlementId: settlementId,
        paymentTransactionId: paymentTransactionId,
      );

  /// Marks a settlement as failed.
  Future<void> markSettlementFailed(String settlementId) async {
    await db.platformFeeSettlements
        .byKey(settlementId)
        .update(
          (s, set) => set(
            status: ts.toExpr(SettlementStatus.failed.name),
          ),
        )
        .execute();
  }
}
