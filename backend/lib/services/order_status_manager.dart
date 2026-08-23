import 'dart:math';

import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:backend/repositories/stock_repository.dart';
import 'package:backend/services/order_bottle_token_helper.dart';
import 'package:models/models.dart';

/// Handles status transitions and side effects like stock deduction and wallet refunds.
class OrderStatusManager {
  const OrderStatusManager._();

  /// Deducts inventory and generates bottle return tokens when an online payment completes successfully.
  static Future<void> completePayment({
    required OrderRow orderRow,
    required List<OrderItemRow> orderItems,
    required OrderRepository orderRepo,
    required StockRepository stockRepo,
  }) async {
    if (orderRow.paymentStatus == PaymentStatus.completed.name) return;

    await Database.db.transact(() async {
      await orderRepo.update(
        id: orderRow.id,
        paymentStatus: PaymentStatus.completed,
        status: OrderStatus.pending,
      );

      for (final item in orderItems) {
        final stockRow = await stockRepo.getByProductAndStore(
          storeId: orderRow.storeId,
          productId: item.productId,
        );

        if (stockRow != null) {
          final newQty = max(0, stockRow.quantity - item.quantity);
          await stockRepo.update(
            id: stockRow.id,
            quantity: newQty,
            transactionType: StockTransactionType.reduce.name,
            amount: item.quantity,
            reason: StockTransactionReason.sale.name,
            customReason: 'Order #${orderRow.billNo}',
          );
        }
      }

      await OrderBottleTokenHelper.generateIfApplicable(
        merchantId: orderRow.merchantId,
        storeId: orderRow.storeId,
        orderId: orderRow.id,
        items: orderItems.map((i) => (productId: i.productId, quantity: i.quantity)).toList(),
        customerId: orderRow.customerId,
      );
    });
  }

  /// Cancels order and issues wallet refunds if applicable.
  static Future<void> cancelOrder({
    required OrderRow orderRow,
    required OrderRepository orderRepo,
  }) async {
    if (orderRow.status == OrderStatus.cancelled.name) return;

    await Database.db.transact(() async {
      await orderRepo.update(
        id: orderRow.id,
        paymentStatus: PaymentStatus.failed,
        status: OrderStatus.cancelled,
      );

      if (orderRow.walletDeduction > 0 && orderRow.customerId != null) {
        final customerRepo = CustomerRepository(db: Database.db);

        await customerRepo.updateStoreWalletBalance(
          customerId: orderRow.customerId!,
          storeId: orderRow.storeId,
          amountDeltaPaise: orderRow.walletDeduction,
        );

        await customerRepo.createWalletTransaction(
          customerId: orderRow.customerId!,
          storeId: orderRow.storeId,
          amount: orderRow.walletDeduction,
          type: WalletTransactionType.refundCredit.name,
          reference: '${orderRow.orderReference}-REFUND',
        );
      }
    });
  }
}
