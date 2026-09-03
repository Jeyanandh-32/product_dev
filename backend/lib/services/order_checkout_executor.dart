import 'dart:math';

import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/extensions/order_row_extension.dart';
import 'package:backend/repositories/order_item_repository.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:backend/repositories/stock_repository.dart';
import 'package:backend/services/order_bottle_token_helper.dart';
import 'package:backend/services/order_calculator.dart';
import 'package:backend/services/order_reference_generator.dart';
import 'package:models/models.dart';

/// Transactional coordinator executing atomic checkout and inventory reductions.
class OrderCheckoutExecutor {
  const OrderCheckoutExecutor._();

  static Future<Order> execute({
    required String merchantId,
    required String storeId,
    required OrderRepository orderRepo,
    required OrderItemRepository orderItemRepo,
    required StockRepository stockRepo,
    required CalculatedOrderSummary totals,
    required OrderSource source,
    required OrderType type,
    required PaymentMethod paymentMethod,
    double walletDeductionInput = 0.0,
    OrderStatus status = OrderStatus.completed,
    PaymentStatus paymentStatus = PaymentStatus.completed,
    String? terminalCode,
    String? customerId,
  }) {
    return Database.db.transact(() async {
      for (final item in totals.items) {
        final stockRow = await stockRepo.getByProductAndStore(
          storeId: storeId,
          productId: item.productId,
        );

        if (stockRow != null && stockRow.quantity < item.quantity) {
          throw Exception(
            'Insufficient stock for product. Available: ${stockRow.quantity}, Requested: ${item.quantity}.',
          );
        }
      }

      final billNo = await orderRepo.getNextBillNo(storeId);
      final orderReference = OrderReferenceGenerator.generate();

      final orderRow = await orderRepo.create(
        merchantId: merchantId,
        storeId: storeId,
        orderReference: orderReference,
        billNo: billNo,
        source: source,
        type: type,
        status: status,
        paymentStatus: paymentStatus,
        paymentMethod: paymentMethod,
        subtotal: totals.subtotal,
        discountTotal: totals.discountTotal,
        taxTotal: totals.taxTotal,
        platformFee: totals.platformFee,
        gatewayCharges: totals.gatewayCharges,
        grandTotal: totals.grandTotal,
        walletDeduction: (walletDeductionInput * 100).round(),
        terminalCode: terminalCode,
        customerId: customerId,
      );

      final createdItems = <OrderItemRow>[];
      for (final item in totals.items) {
        final orderItem = await orderItemRepo.create(
          orderId: orderRow.id,
          productId: item.productId,
          storeId: storeId,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
          taxRate: item.taxRate,
          discount: item.discount,
        );
        createdItems.add(orderItem);

        final stockRow = await stockRepo.getByProductAndStore(
          storeId: storeId,
          productId: item.productId,
        );

        if (stockRow != null && paymentStatus == PaymentStatus.completed) {
          if (stockRow.quantity < item.quantity) {
            throw Exception(
              'Stock decreased during checkout. Requested: ${item.quantity}, Available: ${stockRow.quantity}.',
            );
          }
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

      if (paymentStatus == PaymentStatus.completed) {
        await OrderBottleTokenHelper.generateIfApplicable(
          merchantId: merchantId,
          storeId: storeId,
          orderId: orderRow.id,
          items: totals.items
              .map((i) => (productId: i.productId, quantity: i.quantity))
              .toList(),
          customerId: customerId,
        );
      }

      return orderRow.toOrder(createdItems);
    });
  }
}
