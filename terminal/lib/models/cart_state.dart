import 'package:terminal/models/cart_item.dart';

/// State representation of the terminal shopping cart.
class CartState {
  final List<CartItem> items;
  final int noOfItems;
  final int orderQuantity;
  final double subtotal;
  final double discountTotal;
  final double taxTotal;
  final double grandTotal;

  CartState({
    required this.items,
    required this.noOfItems,
    required this.orderQuantity,
    required this.subtotal,
    required this.discountTotal,
    required this.taxTotal,
    required this.grandTotal,
  });

  factory CartState.initial() => CartState(
    items: [],
    noOfItems: 0,
    orderQuantity: 0,
    subtotal: 0.0,
    discountTotal: 0.0,
    taxTotal: 0.0,
    grandTotal: 0.0,
  );
}
