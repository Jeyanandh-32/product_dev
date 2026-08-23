import 'dart:math';

import 'package:backend/database/schema.dart';
import 'package:backend/extensions/bottle_return_row_extension.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Handler for executing consolidated bottle return sessions from IoT machines and manual fallback.
class BottleReturnSessionHandler {
  const BottleReturnSessionHandler({required this.db});

  final ts.Database<DatabaseSchema> db;

  /// Processes a batch of scanned bottle tokens and issues consolidated reward.
  Future<BottleReturnSessionResult> processReturnBatch({
    required List<String> tokenStrings,
    required String storeId,
    required String merchantId,
  }) async {
    final cleanTokens = tokenStrings
        .map((t) => t.trim().toUpperCase())
        .toSet()
        .toList();
    if (cleanTokens.isEmpty) {
      throw ArgumentError('No valid bottle tokens provided.');
    }

    final cfgRows = await db.bottleReturnConfigs
        .where((c) => c.storeId.equals(ts.toExpr(storeId)))
        .fetch();
    final rewardRate = cfgRows.isNotEmpty && cfgRows.first.isEnabled
        ? cfgRows.first.rewardAmountInRupees
        : 10;

    final tokenRows = await db.bottleQrTokens
        .where(
          (t) =>
              t.merchantId.equals(ts.toExpr(merchantId)) &
              t.status.equals(ts.toExpr('active')),
        )
        .fetch();

    final validMatching = tokenRows
        .where((r) => cleanTokens.contains(r.token))
        .toList();
    if (validMatching.isEmpty) {
      throw ArgumentError('No active returnable bottles found.');
    }

    final totalCount = validMatching.length;
    final totalReward = totalCount * rewardRate;
    final primaryMode = validMatching.first.rewardMode == 'digital'
        ? BottleRewardMode.digital
        : BottleRewardMode.physical;
    final customerPhone = validMatching.first.customerPhone;

    for (final tok in validMatching) {
      await db.bottleQrTokens
          .where((t) => t.id.equals(ts.toExpr(tok.id)))
          .update(
            (t, set) => set(
              status: ts.toExpr('returned'),
              returnedAt: ts.Expr.currentTimestamp,
              returnedStoreId: ts.toExpr(storeId),
            ),
          )
          .execute();
    }

    if (primaryMode == BottleRewardMode.digital &&
        customerPhone != null &&
        customerPhone.isNotEmpty) {
      final existingCred = await db.bottleCredits
          .where(
            (c) =>
                c.merchantId.equals(ts.toExpr(merchantId)) &
                c.customerPhone.equals(ts.toExpr(customerPhone)),
          )
          .fetch();
      if (existingCred.isNotEmpty) {
        await db.bottleCredits
            .where((c) => c.id.equals(ts.toExpr(existingCred.first.id)))
            .update(
              (c, set) => set(
                balance: c.balance.addValue(totalReward),
                updatedAt: ts.Expr.currentTimestamp,
              ),
            )
            .execute();
      } else {
        await db.bottleCredits
            .insertValue(
              merchantId: merchantId,
              customerPhone: customerPhone,
              balance: totalReward,
            )
            .execute();
      }
      await db.bottleCreditTransactions
          .insertValue(
            merchantId: merchantId,
            customerPhone: customerPhone,
            amount: totalReward,
            type: 'credit',
            storeId: storeId,
          )
          .execute();

      return BottleReturnSessionResult(
        totalBottlesReturned: totalCount,
        totalRewardAmount: totalReward,
        rewardMode: BottleRewardMode.digital,
        customerPhone: customerPhone,
        message: '₹$totalReward credited to $customerPhone.',
      );
    }

    final couponCode = 'BTL${Random().nextInt(900000) + 100000}';
    final couponRow = await db.bottlePhysicalCoupons
        .insertValue(
          code: couponCode,
          merchantId: merchantId,
          storeId: storeId,
          amount: totalReward,
          status: 'active',
        )
        .returnInserted()
        .executeAndFetch();

    return BottleReturnSessionResult(
      totalBottlesReturned: totalCount,
      totalRewardAmount: totalReward,
      rewardMode: BottleRewardMode.physical,
      physicalCoupon: couponRow.toModel(),
      message: 'Voucher $couponCode generated for ₹$totalReward.',
    );
  }
}
