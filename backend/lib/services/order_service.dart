import 'dart:math';
import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/extensions/order_row_extension.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/repositories/order_item_repository.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:backend/repositories/stock_repository.dart';
import 'package:models/models.dart';

class OrderService {
  const OrderService({
    required this._orderRepo,
    required this._orderItemRepo,
    required this._productRepo,
    required this._stockRepo,
  });

  final OrderRepository _orderRepo;
  final OrderItemRepository _orderItemRepo;
  final ProductRepository _productRepo;
  final StockRepository _stockRepo;

  String _generateOrderReference() {
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final suffix = List.generate(
      6,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
    return 'ORD-${DateTime.now().millisecondsSinceEpoch}-$suffix';
  }

  Future<({int subtotal, int taxTotal, int grandTotal, int discountTotal, List<Map<String, dynamic>> items})>
  calculateOrderTotals({
    required String storeId,
    required List<Map<String, dynamic>> productsInput,
    double discountTotalInput = 0.0,
    bool isComplimentary = false,
  }) async {
    var calculatedSubtotal = 0;
    var calculatedTaxTotal = 0;
    final calculatedItems = <Map<String, dynamic>>[];

    for (final p in productsInput) {
      final productId = p['productId'] as String;
      final quantity = p['quantity'] as int;
      final itemDiscountDouble = (p['discount'] as num?)?.toDouble() ?? 0.0;
      final itemDiscountPaise = (itemDiscountDouble * 100).round();

      final result = await _productRepo.getById(productId);
      if (result == null) {
        throw Exception('Product with id "$productId" not found');
      }
      final (productRow, _, _, _) = result;

      final stockRow = await _stockRepo.getByProductAndStore(
        storeId: storeId,
        productId: productId,
      );

      if (stockRow != null && stockRow.quantity < quantity) {
        throw Exception(
          'Insufficient stock for product "${productRow.name}". Available: ${stockRow.quantity}, Requested: $quantity.',
        );
      }

      final sellingPricePaise = productRow.sellingPrice;
      final itemSubtotalPaise = sellingPricePaise * quantity;

      final taxRateDouble = productRow.taxRate;
      final taxRateDecimal = taxRateDouble / 100.0;
      final taxableAmountPaise = max(0, itemSubtotalPaise - itemDiscountPaise);
      final itemTaxPaise = (taxableAmountPaise * taxRateDecimal).round();

      calculatedSubtotal += itemSubtotalPaise;
      calculatedTaxTotal += itemTaxPaise;

      calculatedItems.add({
        'productId': productId,
        'quantity': quantity,
        'unitPrice': sellingPricePaise,
        'discount': itemDiscountPaise,
        'taxRate': taxRateDouble,
      });
    }

    final overallDiscountPaise = (discountTotalInput * 100).round();
    final calculatedDiscountTotal = isComplimentary
        ? (calculatedSubtotal + calculatedTaxTotal)
        : overallDiscountPaise;

    final calculatedGrandTotal = max(
      0,
      calculatedSubtotal + calculatedTaxTotal - calculatedDiscountTotal,
    );

    return (
      subtotal: calculatedSubtotal,
      taxTotal: calculatedTaxTotal,
      grandTotal: calculatedGrandTotal,
      discountTotal: calculatedDiscountTotal,
      items: calculatedItems,
    );
  }

  Future<Order> checkout({
    required String merchantId,
    required String storeId,
    required List<Map<String, dynamic>> productsInput,
    required OrderSource source,
    required OrderType type,
    required PaymentMethod paymentMethod,
    double discountTotalInput = 0.0,
    double walletDeductionInput = 0.0,
    OrderStatus status = OrderStatus.completed,
    PaymentStatus paymentStatus = PaymentStatus.completed,
    String? terminalCode,
    String? customerId,
  }) async {
    final isComplimentary = paymentMethod == PaymentMethod.complimentary;

    var calculatedSubtotal = 0;
    var calculatedTaxTotal = 0;
    final calculatedItems = <Map<String, dynamic>>[];

    for (final p in productsInput) {
      final productId = p['productId'] as String;
      final quantity = p['quantity'] as int;
      final itemDiscountDouble = (p['discount'] as num?)?.toDouble() ?? 0.0;
      final itemDiscountPaise = (itemDiscountDouble * 100).round();

      final result = await _productRepo.getById(productId);
      if (result == null) {
        throw Exception('Product with id "$productId" not found');
      }
      final (productRow, _, _, _) = result;

      final stockRow = await _stockRepo.getByProductAndStore(
        storeId: storeId,
        productId: productId,
      );

      if (stockRow != null) {
        if (stockRow.quantity < quantity) {
          throw Exception(
            'Insufficient stock for product "${productRow.name}". Available: ${stockRow.quantity}, Requested: $quantity.',
          );
        }
      }

      final sellingPricePaise = productRow.sellingPrice;
      final itemSubtotalPaise = sellingPricePaise * quantity;

      final taxRateDouble = productRow.taxRate;
      final taxRateDecimal = taxRateDouble / 100.0;
      final taxableAmountPaise = max(0, itemSubtotalPaise - itemDiscountPaise);
      final itemTaxPaise = (taxableAmountPaise * taxRateDecimal).round();

      calculatedSubtotal += itemSubtotalPaise;
      calculatedTaxTotal += itemTaxPaise;

      calculatedItems.add({
        'productId': productId,
        'quantity': quantity,
        'unitPrice': sellingPricePaise,
        'discount': itemDiscountPaise,
        'taxRate': taxRateDouble,
      });
    }

    final overallDiscountPaise = (discountTotalInput * 100).round();
    final calculatedDiscountTotal = isComplimentary
        ? (calculatedSubtotal + calculatedTaxTotal)
        : overallDiscountPaise;

    final calculatedGrandTotal = max(
      0,
      calculatedSubtotal + calculatedTaxTotal - calculatedDiscountTotal,
    );

    return Database.db.transact(() async {
      // 1. Re-validate stock inside atomic transaction to prevent race conditions
      for (final p in productsInput) {
        final productId = p['productId'] as String;
        final quantity = p['quantity'] as int;

        final result = await _productRepo.getById(productId);
        if (result == null) {
          throw Exception('Product with id "$productId" not found');
        }
        final productRow = result.$1;

        final stockRow = await _stockRepo.getByProductAndStore(
          storeId: storeId,
          productId: productId,
        );

        if (stockRow != null && stockRow.quantity < quantity) {
          throw Exception(
            'Insufficient stock for product "${productRow.name}". Available: ${stockRow.quantity}, Requested: $quantity.',
          );
        }
      }

      final billNo = await _orderRepo.getNextBillNo(storeId);
      final orderReference = _generateOrderReference();

      final orderRow = await _orderRepo.create(
        merchantId: merchantId,
        storeId: storeId,
        orderReference: orderReference,
        billNo: billNo,
        source: source,
        type: type,
        status: status,
        paymentStatus: paymentStatus,
        paymentMethod: paymentMethod,
        subtotal: calculatedSubtotal,
        discountTotal: calculatedDiscountTotal,
        taxTotal: calculatedTaxTotal,
        grandTotal: calculatedGrandTotal,
        walletDeduction: (walletDeductionInput * 100).round(),
        terminalCode: terminalCode,
        customerId: customerId,
      );

      final createdItems = <OrderItemRow>[];
      for (final item in calculatedItems) {
        final productId = item['productId'] as String;
        final quantity = item['quantity'] as int;
        final unitPrice = item['unitPrice'] as int;
        final discount = item['discount'] as int;
        final taxRate = item['taxRate'] as double;

        final orderItem = await _orderItemRepo.create(
          orderId: orderRow.id,
          productId: productId,
          storeId: storeId,
          quantity: quantity,
          unitPrice: unitPrice,
          taxRate: taxRate,
          discount: discount,
        );
        createdItems.add(orderItem);

        final stockRow = await _stockRepo.getByProductAndStore(
          storeId: storeId,
          productId: productId,
        );

        if (stockRow != null && paymentStatus == PaymentStatus.completed) {
          if (stockRow.quantity < quantity) {
            throw Exception(
              'Stock decreased during checkout. Requested: $quantity, Available: ${stockRow.quantity}.',
            );
          }
          final newQty = max(0, stockRow.quantity - quantity);
          await _stockRepo.update(
            id: stockRow.id,
            quantity: newQty,
            transactionType: StockTransactionType.reduce.name,
            amount: quantity,
            reason: StockTransactionReason.sale.name,
            customReason: 'Order #${orderRow.billNo}',
          );
        }
      }

      return orderRow.toOrder(createdItems);
    });
  }

  /// Deducts inventory when an online payment completes successfully
  Future<void> completeOrderPayment({
    required OrderRow orderRow,
    required List<OrderItemRow> orderItems,
  }) async {
    if (orderRow.paymentStatus == PaymentStatus.completed.name) return;

    await Database.db.transact(() async {
      await _orderRepo.update(
        id: orderRow.id,
        paymentStatus: PaymentStatus.completed,
        status: OrderStatus.pending,
      );

      for (final item in orderItems) {
        final stockRow = await _stockRepo.getByProductAndStore(
          storeId: orderRow.storeId,
          productId: item.productId,
        );

        if (stockRow != null) {
          final newQty = max(0, stockRow.quantity - item.quantity);
          await _stockRepo.update(
            id: stockRow.id,
            quantity: newQty,
            transactionType: StockTransactionType.reduce.name,
            amount: item.quantity,
            reason: StockTransactionReason.sale.name,
            customReason: 'Order #${orderRow.billNo}',
          );
        }
      }
    });
  }

  /// Marks an order as cancelled when payment fails or is abandoned, and refunds wallet deduction if applied
  Future<void> cancelOrder({
    required OrderRow orderRow,
  }) async {
    if (orderRow.status == OrderStatus.cancelled.name) return;

    await Database.db.transact(() async {
      await _orderRepo.update(
        id: orderRow.id,
        paymentStatus: PaymentStatus.failed,
        status: OrderStatus.cancelled,
      );

      // If a wallet deduction was applied and there is an associated customer, refund it back to their store wallet
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
