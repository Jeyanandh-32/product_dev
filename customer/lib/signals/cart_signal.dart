import 'package:client_repositories/client_repositories.dart';
import 'package:customer/signals/toast_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

/// Item stored in global cart
class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
  });

  final Product product;
  final int quantity;

  CartItem copyWith({int? quantity}) => CartItem(
    product: product,
    quantity: quantity ?? this.quantity,
  );
}

/// Global Reactive Cart State
final cartItemsSignal = signal<Map<String, CartItem>>({});
final currentCartStoreIdSignal = signal<String?>(null);
final currentCartStoreSignal = signal<Store?>(null);
final isCartDrawerOpenSignal = signal<bool>(false);
final isCartSubmittingSignal = signal<bool>(false);

void toggleCartDrawer() {
  isCartDrawerOpenSignal.value = !isCartDrawerOpenSignal.value;
}

void openCartDrawer() {
  isCartDrawerOpenSignal.value = true;
}

void closeCartDrawer() {
  isCartDrawerOpenSignal.value = false;
}

void addToCart(String storeId, Product product, {Store? store}) {
  final currentStoreId = currentCartStoreIdSignal.value;

  // If adding from a different store, reset cart
  if (currentStoreId != null && currentStoreId != storeId && cartItemsSignal.value.isNotEmpty) {
    cartItemsSignal.value = {};
    currentCartStoreSignal.value = null;
  }

  currentCartStoreIdSignal.value = storeId;
  if (store != null) {
    currentCartStoreSignal.value = store;
  }

  final items = Map<String, CartItem>.from(cartItemsSignal.value);
  final existing = items[product.id];

  if (existing != null) {
    items[product.id] = existing.copyWith(quantity: existing.quantity + 1);
  } else {
    items[product.id] = CartItem(product: product, quantity: 1);
  }

  cartItemsSignal.value = items;
}

void removeFromCart(Product product) {
  final items = Map<String, CartItem>.from(cartItemsSignal.value);
  final existing = items[product.id];

  if (existing != null) {
    if (existing.quantity > 1) {
      items[product.id] = existing.copyWith(quantity: existing.quantity - 1);
    } else {
      items.remove(product.id);
    }
  }

  cartItemsSignal.value = items;
}

void removeProductCompletely(String productId) {
  final items = Map<String, CartItem>.from(cartItemsSignal.value);
  items.remove(productId);
  cartItemsSignal.value = items;
}

void clearCart() {
  cartItemsSignal.value = {};
}

Future<void> checkoutCurrentCart() async {
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
    clearCart();
    closeCartDrawer();
  } catch (e) {
    showCustomerToast(e.toString(), type: ToastType.error);
  } finally {
    isCartSubmittingSignal.value = false;
  }
}
