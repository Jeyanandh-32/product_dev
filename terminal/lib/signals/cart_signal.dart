import 'package:client_repositories/client_repositories.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/models/cart_item.dart';

final paymentModeSignal = signal<PaymentMethod>(PaymentMethod.cash);

class CartState {
  final List<CartItem> items;
  final int noOfItems;
  final int orderQuantity;
  final double subtotal;
  final double taxTotal;
  final double grandTotal;

  CartState({
    required this.items,
    required this.noOfItems,
    required this.orderQuantity,
    required this.subtotal,
    required this.taxTotal,
    required this.grandTotal,
  });

  factory CartState.initial() => CartState(
    items: [],
    noOfItems: 0,
    orderQuantity: 0,
    subtotal: 0.0,
    taxTotal: 0.0,
    grandTotal: 0.0,
  );
}

final cartSignal = signal<CartState>(CartState.initial());

abstract final class CartController {
  static void addItem(Product product, {int quantity = 1}) {
    final current = cartSignal.value;
    final existingIndex = current.items.indexWhere(
      (item) => item.product.id == product.id,
    );
    List<CartItem> updatedItems = List.from(current.items);

    if (existingIndex >= 0) {
      final existing = current.items[existingIndex];
      updatedItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    } else {
      updatedItems.add(CartItem(product: product, quantity: quantity));
    }

    _updateState(updatedItems);
  }

  static void removeItem(String productId) {
    final current = cartSignal.value;
    final updatedItems = current.items
        .where((item) => item.product.id != productId)
        .toList();

    _updateState(updatedItems);
  }

  static void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final current = cartSignal.value;
    final updatedItems = current.items
        .map(
          (item) => item.product.id == productId
              ? item.copyWith(quantity: quantity)
              : item,
        )
        .toList();

    _updateState(updatedItems);
  }

  static void clear() {
    cartSignal.value = CartState.initial();
  }

  static void _updateState(List<CartItem> items) {
    int noOfItems = items.length;
    int orderQuantity = 0;

    double subtotal = 0.0;
    double taxTotal = 0.0;

    for (final item in items) {
      final price = item.product.sellingPrice * item.quantity;
      subtotal += price;

      final tax = price * (item.product.taxRate / 100);
      taxTotal += tax;

      orderQuantity += item.quantity;
    }

    cartSignal.value = CartState(
      items: items,
      noOfItems: noOfItems,
      orderQuantity: orderQuantity,
      subtotal: subtotal,
      taxTotal: taxTotal,
      grandTotal: subtotal + taxTotal,
    );
  }

  static Future<Order> checkout({
    required String storeId,
    required PaymentMethod paymentMethod,
  }) async {
    final products = cartSignal.value.items
        .map(
          (item) => {'productId': item.product.id, 'quantity': item.quantity},
        )
        .toList();

    try {
      final order = await OrderRepository.create(
        storeId: storeId,
        products: products,
        paymentMethod: paymentMethod,
        source: OrderSource.terminal,
        type: OrderType.dineIn,
      );
      clear();
      return order;
    } catch (e) {
      rethrow;
    }
  }
}
