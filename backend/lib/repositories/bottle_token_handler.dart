import 'dart:math';

import 'package:backend/database/schema.dart';
import 'package:backend/extensions/bottle_return_row_extension.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Handler managing bottle QR token generation and retrieval.
class BottleTokenHandler {
  const BottleTokenHandler(this.db);

  final ts.Database<DatabaseSchema> db;

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
          await db.bottleQrTokens
              .where((t) => t.id.equals(ts.toExpr(tok.id)))
              .update(
                (t, set) => set(
                  rewardMode: ts.toExpr(rewardMode.name),
                  customerPhone: customerPhone != null
                      ? ts.toExpr(customerPhone)
                      : t.customerPhone,
                ),
              )
              .execute();
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
        final tokenStr =
            'BTL_${DateTime.now().microsecondsSinceEpoch.toRadixString(36).toUpperCase()}_${rand.nextInt(999999).toString().padLeft(6, '0')}';
        final row = await db.bottleQrTokens
            .insertValue(
              token: tokenStr,
              merchantId: merchantId,
              storeId: storeId,
              orderId: orderId,
              productId: item.productId,
              rewardMode: rewardMode.name,
              customerPhone: customerPhone,
              status: 'active',
            )
            .returnInserted()
            .executeAndFetch();
        generated.add(row.toModel());
      }
    }
    return generated;
  }

  /// Gets all generated tokens for a specific order.
  Future<List<BottleQrToken>> getTokensByOrderId(String orderId) async {
    final rows = await db.bottleQrTokens
        .where((t) => t.orderId.equals(ts.toExpr(orderId)))
        .fetch();
    return rows.map((r) => r.toModel()).toList();
  }
}
