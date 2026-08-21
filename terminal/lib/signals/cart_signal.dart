import 'dart:math';

import 'package:client_repositories/client_repositories.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/models/cart_item.dart';
import 'package:terminal/models/cart_state.dart';

export 'package:terminal/models/cart_state.dart';

final paymentModeSignal = signal<PaymentMethod>(PaymentMethod.cash);
final discountInputSignal = signal<double>(0.0);
final printBillSignal = signal<bool>(true);
final showOrderSummaryDetailsSignal = signal<bool>(true);
final cartSignal = signal<CartState>(CartState.initial());

/// Resets all cart-related signals to their clean initial state.
void resetCartSignal() {
  discountInputSignal.value = 0.0;
  paymentModeSignal.value = PaymentMethod.cash;
  printBillSignal.value = true;
  showOrderSummaryDetailsSignal.value = true;
  cartSignal.value = CartState.initial();
}

abstract final class CartController {
  static void addItem(Product product, {int quantity = 1}) {
    final current = cartSignal.value;
    final existingIndex = current.items.indexWhere(
      (item) => item.product.id == product.id,
    );
    final updatedItems = List<CartItem>.from(current.items);

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
    _updateState(
      current.items.where((i) => i.product.id != productId).toList(),
    );
  }

  static void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) return removeItem(productId);
    final current = cartSignal.value;
    _updateState(
      current.items
          .map(
            (i) =>
                i.product.id == productId ? i.copyWith(quantity: quantity) : i,
          )
          .toList(),
    );
  }

  static void setDiscount(double discount) {
    final current = cartSignal.value;
    final maxDiscount = current.subtotal + current.taxTotal;
    discountInputSignal.value = max(
      0.0,
      min(discount, maxDiscount > 0 ? maxDiscount : discount),
    );
    _updateState(cartSignal.value.items);
  }

  static void setPaymentMode(PaymentMethod mode) {
    paymentModeSignal.value = mode;
    _updateState(cartSignal.value.items);
  }

  static void togglePrintBill([bool? value]) {
    printBillSignal.value = value ?? !printBillSignal.value;
  }

  static void toggleSummaryDetails([bool? value]) {
    showOrderSummaryDetailsSignal.value =
        value ?? !showOrderSummaryDetailsSignal.value;
  }

  static void clear() => resetCartSignal();

  static void _updateState(List<CartItem> items) {
    var orderQuantity = 0;
    var subtotal = 0.0;
    var taxTotal = 0.0;

    for (final item in items) {
      final price = item.product.sellingPrice * item.quantity;
      subtotal += price;
      taxTotal += price * (item.product.taxRate / 100);
      orderQuantity += item.quantity;
    }

    final isComplimentary =
        paymentModeSignal.value == PaymentMethod.complimentary;
    final maxAllowedDiscount = subtotal + taxTotal;
    final discountTotal = isComplimentary
        ? maxAllowedDiscount
        : min(maxAllowedDiscount, discountInputSignal.value);

    cartSignal.value = CartState(
      items: items,
      noOfItems: items.length,
      orderQuantity: orderQuantity,
      subtotal: subtotal,
      discountTotal: discountTotal,
      taxTotal: taxTotal,
      grandTotal: max(0.0, subtotal - discountTotal + taxTotal),
    );
  }

  static Future<Order> checkout({
    required String storeId,
    required PaymentMethod paymentMethod,
  }) async {
    final products = cartSignal.value.items
        .map((i) => {'productId': i.product.id, 'quantity': i.quantity})
        .toList();

    final order = await OrderRepository.create(
      storeId: storeId,
      products: products,
      paymentMethod: paymentMethod,
      discountTotal: cartSignal.value.discountTotal,
      source: OrderSource.terminal,
      type: OrderType.dineIn,
    );
    clear();
    return order;
  }
}
