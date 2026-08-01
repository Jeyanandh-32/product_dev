import 'dart:math';
import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/extensions/order_row_extension.dart';
import 'package:backend/repositories/order_item_repository.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:backend/repositories/stock_repository.dart';
import 'package:models/models.dart';

class OrderService {
  const OrderService({
    required OrderRepository orderRepo,
    required OrderItemRepository orderItemRepo,
    required ProductRepository productRepo,
    required StockRepository stockRepo,
  }) : _orderRepo = orderRepo,
       _orderItemRepo = orderItemRepo,
       _productRepo = productRepo,
       _stockRepo = stockRepo;

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

  Future<Order> checkout({
    required String merchantId,
    required String storeId,
    required List<Map<String, dynamic>> productsInput,
    required OrderSource source,
    required OrderType type,
    required PaymentMethod paymentMethod,
    double discountTotalInput = 0.0,
    String? terminalCode,
  }) async {
    final isComplimentary = paymentMethod == .complimentary;

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

    const paymentStatus = PaymentStatus.paid;

    return Database.db.transact(() async {
      final billNo = await _orderRepo.getNextBillNo(storeId);
      final orderReference = _generateOrderReference();

      final orderRow = await _orderRepo.create(
        merchantId: merchantId,
        storeId: storeId,
        orderReference: orderReference,
        billNo: billNo,
        source: source,
        type: type,
        status: .completed,
        paymentStatus: paymentStatus,
        paymentMethod: paymentMethod,
        subtotal: calculatedSubtotal,
        discountTotal: calculatedDiscountTotal,
        taxTotal: calculatedTaxTotal,
        grandTotal: calculatedGrandTotal,
        terminalCode: terminalCode,
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

        if (stockRow != null && stockRow.stockMonitor) {
          final newQty = max(0, stockRow.quantity - quantity);
          await _stockRepo.update(id: stockRow.id, quantity: newQty);
        }
      }

      return orderRow.toOrder(createdItems);
    });
  }
}
