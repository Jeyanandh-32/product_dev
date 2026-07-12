import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:terminal/models/cart_item.dart';
import 'package:terminal/repositories/order_repository.dart';

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
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(
  CartNotifier.new,
);

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() {
    return CartState(
      items: [],
      noOfItems: 0,
      orderQuantity: 0,
      subtotal: 0.0,
      taxTotal: 0.0,
      grandTotal: 0.0,
    );
  }

  void addItem(Product product, {int quantity = 1}) {
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == product.id,
    );
    List<CartItem> updatedItems = List.from(state.items);

    if (existingIndex >= 0) {
      final existing = state.items[existingIndex];
      updatedItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    } else {
      updatedItems.add(CartItem(product: product, quantity: quantity));
    }

    _updateState(updatedItems);
  }

  void removeItem(String productId) {
    final updatedItems = state.items
        .where((item) => item.product.id != productId)
        .toList();

    _updateState(updatedItems);
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final updatedItems = state.items
        .map(
          (item) => item.product.id == productId
              ? item.copyWith(quantity: quantity)
              : item,
        )
        .toList();

    _updateState(updatedItems);
  }

  void clear() {
    state = CartState(
      items: [],
      noOfItems: 0,
      orderQuantity: 0,
      subtotal: 0.0,
      taxTotal: 0.0,
      grandTotal: 0.0,
    );
  }

  void _updateState(List<CartItem> items) {
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

    state = CartState(
      items: items,
      noOfItems: noOfItems,
      orderQuantity: orderQuantity,
      subtotal: subtotal,
      taxTotal: taxTotal,
      grandTotal: subtotal + taxTotal,
    );
  }

  Future<Order> checkout({
    required String storeId,
    required String paymentMethod,
  }) async {
    final products = state.items
        .map(
          (item) => {'productId': item.product.id, 'quantity': item.quantity},
        )
        .toList();

    try {
      final order = await OrderRepository.create(
        storeId: storeId,
        products: products,
        paymentMethod: paymentMethod,
        source: 'terminal',
        type: 'dineIn',
      );
      clear();
      return order;
    } catch (e) {
      rethrow;
    }
  }
}
