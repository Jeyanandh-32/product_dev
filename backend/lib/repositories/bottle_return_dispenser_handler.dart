import 'package:backend/database/schema.dart';
import 'package:backend/extensions/bottle_return_row_extension.dart';
import 'package:backend/extensions/order_row_extension.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Result status for the dispenser order payload lookup.
sealed class DispenserOrderResult {
  const DispenserOrderResult();
}

/// Order found in pending status, successfully completed, and returned with optional tokens.
class DispenserOrderSuccess extends DispenserOrderResult {
  const DispenserOrderSuccess({
    required this.order,
    this.bottleTokens,
  });

  final Order order;
  final List<BottleQrToken>? bottleTokens;
}

/// Order with given reference does not exist.
class DispenserOrderNotFound extends DispenserOrderResult {
  const DispenserOrderNotFound();
}

/// Order was already marked completed/dispensed previously.
class DispenserOrderAlreadyCompleted extends DispenserOrderResult {
  const DispenserOrderAlreadyCompleted();
}

/// Order has been cancelled.
class DispenserOrderCancelled extends DispenserOrderResult {
  const DispenserOrderCancelled();
}

/// Handler for the in-store Order Pickup & Dispenser device.
class BottleReturnDispenserHandler {
  const BottleReturnDispenserHandler({required this.db});

  final ts.Database<DatabaseSchema> db;

  /// Retrieves order details, updates status to completed, and auto-returns bottle tokens if store enabled.
  Future<DispenserOrderResult> getDispenserOrderPayload(
    String orderReference,
  ) async {
    final orderRows = await db.orders
        .where((o) => o.orderReference.equals(ts.toExpr(orderReference.trim())))
        .fetch();
    if (orderRows.isEmpty) return const DispenserOrderNotFound();
    final orderRow = orderRows.first;

    if (orderRow.status == OrderStatus.completed.name) {
      return const DispenserOrderAlreadyCompleted();
    }

    if (orderRow.status == OrderStatus.cancelled.name) {
      return const DispenserOrderCancelled();
    }

    await db.orders.byKey(orderRow.id).update(
      (o, set) => set(
        status: ts.toExpr(OrderStatus.completed.name),
        updatedAt: ts.Expr.currentTimestamp,
      ),
    ).execute();

    final updatedOrderRows = await db.orders.byKey(orderRow.id).fetch();
    final currentOrderRow = updatedOrderRows ?? orderRow;

    final itemRows = await db.orderItems
        .where((i) => i.orderId.equals(ts.toExpr(currentOrderRow.id)))
        .fetch();

    final productIds = itemRows.map((i) => i.productId).toSet().toList();
    final productRows = await db.products.where((p) {
      if (productIds.isEmpty) return ts.toExpr(false);
      var expr = p.id.equals(ts.toExpr(productIds.first));
      for (var i = 1; i < productIds.length; i++) {
        expr = expr.or(p.id.equals(ts.toExpr(productIds[i])));
      }
      return expr;
    }).fetch();
    final productMap = {for (final p in productRows) p.id: p};

    CustomerRow? customerRow;
    if (currentOrderRow.customerId != null) {
      customerRow = await db.customers.byKey(currentOrderRow.customerId!).fetch();
    }

    final order = currentOrderRow.toOrder(
      itemRows,
      productRows: productMap,
      customerRow: customerRow,
    );

    final configRows = await db.bottleReturnConfigs
        .where(
          (c) =>
              c.storeId.equals(ts.toExpr(currentOrderRow.storeId)) &
              c.isEnabled.equals(ts.toExpr(true)),
        )
        .fetch();

    List<BottleQrToken>? tokens;
    if (configRows.isNotEmpty) {
      final tokenRows = await db.bottleQrTokens
          .where((t) => t.orderId.equals(ts.toExpr(currentOrderRow.id)))
          .fetch();
      if (tokenRows.isNotEmpty) {
        tokens = tokenRows.map((r) => r.toModel()).toList();
      }
    }

    return DispenserOrderSuccess(
      order: order,
      bottleTokens: tokens,
    );
  }
}
