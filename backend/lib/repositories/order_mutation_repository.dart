import 'package:backend/database/schema.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Database handler for creating and updating order records.
class OrderMutationRepository {
  const OrderMutationRepository({required this.db});

  final ts.Database<DatabaseSchema> db;

  /// Inserts a new order row into the orders table.
  Future<OrderRow> create({
    required String merchantId,
    required String storeId,
    required String orderReference,
    required int billNo,
    required OrderSource source,
    required OrderType type,
    required OrderStatus status,
    required PaymentStatus paymentStatus,
    required PaymentMethod paymentMethod,
    required int subtotal,
    required int discountTotal,
    required int taxTotal,
    required int grandTotal,
    int walletDeduction = 0,
    int platformFee = 0,
    int gatewayCharges = 0,
    String? terminalCode,
    String? customerId,
  }) async {
    final row = await db.orders
        .insertValue(
          merchantId: merchantId,
          storeId: storeId,
          orderReference: orderReference,
          billNo: billNo,
          source: source.name,
          type: type.name,
          status: status.name,
          paymentStatus: paymentStatus.name,
          paymentMethod: paymentMethod.name,
          subtotal: subtotal,
          discountTotal: discountTotal,
          taxTotal: taxTotal,
          grandTotal: grandTotal,
          walletDeduction: walletDeduction,
          platformFee: platformFee,
          gatewayCharges: gatewayCharges,
          terminalCode: terminalCode,
          customerId: customerId,
        )
        .returnInserted()
        .executeAndFetch();

    return row;
  }

  /// Returns the next incremental daily bill number for a store.
  Future<int> getNextBillNo(String storeId) async {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day).toUtc();

    final lastOrder = await db.orders
        .where((o) => o.storeId.equals(ts.toExpr(storeId)))
        .where((o) => o.createdAt.isAfterValue(startOfToday))
        .orderBy((o) => [(o.billNo, ts.Order.descending)])
        .first
        .fetch();

    return (lastOrder?.billNo ?? 0) + 1;
  }

  /// Updates existing order state, payment status, or payment method.
  Future<OrderRow?> update({
    required String id,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    PaymentMethod? paymentMethod,
    String? terminalCode,
  }) async {
    final row = await db.orders
        .byKey(id)
        .update(
          (o, set) => set(
            status: status != null ? ts.toExpr(status.name) : o.status,
            paymentStatus: paymentStatus != null
                ? ts.toExpr(paymentStatus.name)
                : o.paymentStatus,
            paymentMethod: paymentMethod != null
                ? ts.toExpr(paymentMethod.name)
                : o.paymentMethod,
            terminalCode: terminalCode != null
                ? ts.toExpr(terminalCode)
                : o.terminalCode,
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returnUpdated()
        .executeAndFetch();

    return row;
  }
}
