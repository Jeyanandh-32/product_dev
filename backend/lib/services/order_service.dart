import 'package:backend/database/schema.dart';
import 'package:backend/repositories/order_item_repository.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:backend/repositories/stock_repository.dart';
import 'package:backend/services/order_calculator.dart';
import 'package:backend/services/order_checkout_executor.dart';
import 'package:backend/services/order_status_manager.dart';
import 'package:models/models.dart';

/// Core domain service coordinating calculations, checkout transactions, and inventory deductions.
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

  /// Validates availability and calculates exact subtotal, discounts, taxes, and grand totals.
  Future<CalculatedOrderSummary> calculateOrderTotals({
    required String storeId,
    required List<Map<String, dynamic>> productsInput,
    double discountTotalInput = 0.0,
    bool isComplimentary = false,
  }) async {
    final resolvedItems = <({String productId, int quantity, int sellingPrice, double taxRate, double discount})>[];

    for (final p in productsInput) {
      final productId = p['productId'] as String;
      final quantity = p['quantity'] as int;
      final discount = (p['discount'] as num?)?.toDouble() ?? 0.0;

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

      resolvedItems.add((
        productId: productId,
        quantity: quantity,
        sellingPrice: productRow.sellingPrice,
        taxRate: productRow.taxRate,
        discount: discount,
      ));
    }

    return OrderCalculator.calculate(
      lineItems: resolvedItems,
      discountTotalInput: discountTotalInput,
      isComplimentary: isComplimentary,
    );
  }

  /// Executes atomic checkout creating the order and its items in a transaction.
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

    final totals = await calculateOrderTotals(
      storeId: storeId,
      productsInput: productsInput,
      discountTotalInput: discountTotalInput,
      isComplimentary: isComplimentary,
    );

    return OrderCheckoutExecutor.execute(
      merchantId: merchantId,
      storeId: storeId,
      orderRepo: _orderRepo,
      orderItemRepo: _orderItemRepo,
      stockRepo: _stockRepo,
      totals: totals,
      source: source,
      type: type,
      paymentMethod: paymentMethod,
      walletDeductionInput: walletDeductionInput,
      status: status,
      paymentStatus: paymentStatus,
      terminalCode: terminalCode,
      customerId: customerId,
    );
  }

  /// Deducts inventory when an online payment completes successfully.
  Future<void> completeOrderPayment({
    required OrderRow orderRow,
    required List<OrderItemRow> orderItems,
  }) => OrderStatusManager.completePayment(
    orderRow: orderRow,
    orderItems: orderItems,
    orderRepo: _orderRepo,
    stockRepo: _stockRepo,
  );

  /// Marks an order as cancelled and issues refunds when applicable.
  Future<void> cancelOrder({
    required OrderRow orderRow,
  }) => OrderStatusManager.cancelOrder(
    orderRow: orderRow,
    orderRepo: _orderRepo,
  );
}
