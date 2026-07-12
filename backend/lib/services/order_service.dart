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
    String? terminalCode,
  }) async {
    final itemProductIds = productsInput
        .map((e) => e['productId'] as String)
        .toList();
    final products = await _productRepo.getByIds(itemProductIds);
    final productMap = {for (final p in products) p.id: p};

    var calculatedSubtotal = 0;
    var calculatedTaxTotal = 0;
    final calculatedItems = <Map<String, dynamic>>[];

    for (final itemData in productsInput) {
      final productId = itemData['productId'] as String;
      final quantity = itemData['quantity'] as int;

      final product = productMap[productId];
      if (product == null) {
        throw Exception('Product with ID $productId not found.');
      }

      final unitPrice = product.sellingPrice;
      final taxRate = product.taxRate;

      final itemSubtotal = unitPrice * quantity;
      final itemTax = (itemSubtotal * taxRate) / 100.0;
      final roundedItemTax = itemTax.round();

      calculatedSubtotal += itemSubtotal;
      calculatedTaxTotal += roundedItemTax;

      calculatedItems.add({
        'productId': productId,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'taxRate': taxRate,
      });
    }

    final calculatedGrandTotal = calculatedSubtotal + calculatedTaxTotal;

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
        status: OrderStatus.completed,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: paymentMethod,
        subtotal: calculatedSubtotal,
        taxTotal: calculatedTaxTotal,
        grandTotal: calculatedGrandTotal,
        terminalCode: terminalCode,
      );

      final createdItems = <OrderItemRow>[];
      for (final item in calculatedItems) {
        final productId = item['productId'] as String;
        final quantity = item['quantity'] as int;
        final unitPrice = item['unitPrice'] as int;
        final taxRate = item['taxRate'] as double;

        final orderItem = await _orderItemRepo.create(
          orderId: orderRow.id,
          productId: productId,
          storeId: storeId,
          quantity: quantity,
          unitPrice: unitPrice,
          taxRate: taxRate,
        );
        createdItems.add(orderItem);

        await _stockRepo.deductStock(
          productId: productId,
          storeId: storeId,
          quantityToDeduct: quantity,
        );
      }

      return orderRow.toOrder(createdItems);
    });
  }
}
