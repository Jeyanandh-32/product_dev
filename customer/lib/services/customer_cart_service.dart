import 'package:client_repositories/client_repositories.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:customer/signals/toast_signal.dart';
import 'package:models/models.dart';

/// Service handling customer cart state mutations and submission.
class CustomerCartService {
  const CustomerCartService._();

  /// Adds a product to a specific store's cart.
  static void addToCart(String storeId, Product product, {Store? store}) {
    currentCartStoreIdSignal.value = storeId;
    if (store != null) {
      currentCartStoreSignal.value = store;
    }

    final allCarts = Map<String, Map<String, CartItem>>.from(
      storeCartsSignal.value.map(
        (k, v) => MapEntry(k, Map<String, CartItem>.from(v)),
      ),
    );

    final storeCart = allCarts[storeId] ?? <String, CartItem>{};
    final existing = storeCart[product.id];

    if (existing != null) {
      storeCart[product.id] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      storeCart[product.id] = CartItem(product: product, quantity: 1);
    }

    allCarts[storeId] = storeCart;
    storeCartsSignal.value = allCarts;
  }

  /// Removes a single unit of product from the specified store (or current active store).
  static void removeFromCart(Product product, {String? storeId}) {
    final targetStoreId = storeId ?? currentCartStoreIdSignal.value;
    if (targetStoreId == null) return;

    final allCarts = Map<String, Map<String, CartItem>>.from(
      storeCartsSignal.value.map(
        (k, v) => MapEntry(k, Map<String, CartItem>.from(v)),
      ),
    );

    final storeCart = allCarts[targetStoreId];
    if (storeCart == null) return;

    final existing = storeCart[product.id];
    if (existing != null) {
      if (existing.quantity > 1) {
        storeCart[product.id] =
            existing.copyWith(quantity: existing.quantity - 1);
      } else {
        storeCart.remove(product.id);
      }
    }

    if (storeCart.isEmpty) {
      allCarts.remove(targetStoreId);
    } else {
      allCarts[targetStoreId] = storeCart;
    }

    storeCartsSignal.value = allCarts;
  }

  /// Removes a product entirely from the specified store (or current active store).
  static void removeProductCompletely(String productId, {String? storeId}) {
    final targetStoreId = storeId ?? currentCartStoreIdSignal.value;
    if (targetStoreId == null) return;

    final allCarts = Map<String, Map<String, CartItem>>.from(
      storeCartsSignal.value.map(
        (k, v) => MapEntry(k, Map<String, CartItem>.from(v)),
      ),
    );

    final storeCart = allCarts[targetStoreId];
    if (storeCart == null) return;

    storeCart.remove(productId);
    if (storeCart.isEmpty) {
      allCarts.remove(targetStoreId);
    } else {
      allCarts[targetStoreId] = storeCart;
    }

    storeCartsSignal.value = allCarts;
  }

  /// Clears cart items for the currently active store (or a specific storeId).
  static void clearCart({String? storeId}) {
    final targetStoreId = storeId ?? currentCartStoreIdSignal.value;
    if (targetStoreId == null) return;

    final allCarts = Map<String, Map<String, CartItem>>.from(
      storeCartsSignal.value.map(
        (k, v) => MapEntry(k, Map<String, CartItem>.from(v)),
      ),
    );

    allCarts.remove(targetStoreId);
    storeCartsSignal.value = allCarts;
  }

  /// Submits the current active cart order.
  static Future<void> checkoutCurrentCart() async {
    final storeId = currentCartStoreIdSignal.value;
    final items = cartItemsSignal.value.values.toList();

    if (storeId == null || items.isEmpty || isCartSubmittingSignal.value) return;

    isCartSubmittingSignal.value = true;

    try {
      final productsPayload = items
          .map(
            (item) => {
              'productId': item.product.id,
              'quantity': item.quantity,
            },
          )
          .toList();

      await OrderRepository.create(
        storeId: storeId,
        products: productsPayload,
        source: OrderSource.web,
        type: OrderType.takeaway,
        paymentMethod: PaymentMethod.upi,
      );

      showCustomerToast('Order placed successfully!', type: ToastType.success);
      clearCart(storeId: storeId);
      closeCartDrawer();
    } catch (e) {
      showCustomerToast(e.toString(), type: ToastType.error);
    } finally {
      isCartSubmittingSignal.value = false;
    }
  }
}
