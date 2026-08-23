import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/repositories/bottle_return_repository.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Helper service that creates bottle QR tokens ONLY when store has bottle returns explicitly enabled.
class OrderBottleTokenHelper {
  const OrderBottleTokenHelper._();

  /// Automatically inspects order items and generates bottle tokens for returnable products.
  static Future<void> generateIfApplicable({
    required String merchantId,
    required String storeId,
    required String orderId,
    required List<({String productId, int quantity})> items,
    String? customerId,
    String? customerPhone,
  }) async {
    if (items.isEmpty) return;

    final configRows = await Database.db.bottleReturnConfigs
        .where(
          (c) =>
              c.storeId.equals(ts.toExpr(storeId)) &
              c.isEnabled.equals(ts.toExpr(true)),
        )
        .fetch();

    if (configRows.isEmpty) {
      return;
    }

    final returnableRows = await Database.db.bottleReturnProducts
        .where(
          (p) =>
              p.storeId.equals(ts.toExpr(storeId)) &
              p.isReturnable.equals(ts.toExpr(true)),
        )
        .fetch();
    final returnableIds = returnableRows.map((p) => p.productId).toSet();

    final returnableItems = items
        .where((i) => returnableIds.contains(i.productId))
        .map(
          (i) => (
            productId: i.productId,
            quantity: i.quantity,
            isReturnable: true,
          ),
        )
        .toList();

    if (returnableItems.isEmpty) return;

    var resolvedPhone = customerPhone;
    if (resolvedPhone == null && customerId != null) {
      final cust = await Database.db.customers.byKey(customerId).fetch();
      resolvedPhone = cust?.mobileNumber;
    }

    final repo = BottleReturnRepository(db: Database.db);
    await repo.generateTokensForOrder(
      merchantId: merchantId,
      storeId: storeId,
      orderId: orderId,
      items: returnableItems,
      rewardMode: BottleRewardMode.digital,
      customerPhone: resolvedPhone,
    );
  }
}
