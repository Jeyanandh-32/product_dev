import 'package:customer/models/cart_item.dart';
import 'package:customer/services/customer_cart_service.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

export 'package:customer/models/cart_item.dart';

/// Cart state per store: `Map<storeId, Map<productId, CartItem>>`
final storeCartsSignal = signal<Map<String, Map<String, CartItem>>>({});

/// Currently selected/active store for the cart view
final currentCartStoreIdSignal = signal<String?>(null);
final currentCartStoreSignal = signal<Store?>(null);

final isCartDrawerOpenSignal = signal<bool>(false);
final isCartSubmittingSignal = signal<bool>(false);

/// Computed active cart items for the currently active store
final cartItemsSignal = computed<Map<String, CartItem>>(() {
  final storeId = currentCartStoreIdSignal.value;
  if (storeId == null) return {};
  final allCarts = storeCartsSignal.value;
  return allCarts[storeId] ?? {};
});

void toggleCartDrawer() {
  isCartDrawerOpenSignal.value = !isCartDrawerOpenSignal.value;
}

void openCartDrawer() {
  isCartDrawerOpenSignal.value = true;
}

void closeCartDrawer() {
  isCartDrawerOpenSignal.value = false;
}

/// Sets the active store context for the customer without wiping carts of other stores.
void setActiveStore(Store store) {
  currentCartStoreIdSignal.value = store.id;
  currentCartStoreSignal.value = store;
}

void clearActiveStore() {
  currentCartStoreIdSignal.value = null;
  currentCartStoreSignal.value = null;
}

/// Adds a product to a specific store's cart.
void addToCart(String storeId, Product product, {Store? store}) =>
    CustomerCartService.addToCart(storeId, product, store: store);

/// Removes a single unit of product from the specified store (or current active store).
void removeFromCart(Product product, {String? storeId}) =>
    CustomerCartService.removeFromCart(product, storeId: storeId);

/// Removes a product entirely from the specified store (or current active store).
void removeProductCompletely(String productId, {String? storeId}) =>
    CustomerCartService.removeProductCompletely(productId, storeId: storeId);

/// Clears cart items for the currently active store (or a specific storeId).
void clearCart({String? storeId}) =>
    CustomerCartService.clearCart(storeId: storeId);

/// Submits the current active cart order.
Future<void> checkoutCurrentCart() =>
    CustomerCartService.checkoutCurrentCart();
