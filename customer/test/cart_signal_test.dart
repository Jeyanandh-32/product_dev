import 'package:customer/signals/cart_signal.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

/// Helper function to calculate cart subtotal in Rupees.
double calculateSubtotal(Iterable<CartItem> items) => items.fold<double>(
  0.0,
  (sum, item) => sum + (item.product.sellingPrice * item.quantity),
);

/// Helper function to calculate cart taxes in Rupees.
double calculateTotalTax(Iterable<CartItem> items) => items.fold<double>(
  0.0,
  (sum, item) {
    final itemPrice = item.product.sellingPrice * item.quantity;
    return sum + (itemPrice * (item.product.taxRate / 100.0));
  },
);

/// Helper function to calculate grand total in Rupees.
double calculateGrandTotal(Iterable<CartItem> items) =>
    calculateSubtotal(items) + calculateTotalTax(items);

/// Helper function to filter store products by category and search keyword.
List<Product> filterStoreProducts({
  required List<Product> products,
  String? categoryId,
  String searchQuery = '',
}) {
  final query = searchQuery.trim().toLowerCase();
  return products.where((product) {
    final matchesCategory =
        categoryId == null || product.category?.id == categoryId;
    final matchesQuery =
        query.isEmpty ||
        product.name.toLowerCase().contains(query) ||
        (product.description?.toLowerCase().contains(query) ?? false);
    return matchesCategory && matchesQuery;
  }).toList();
}

void main() {
  group('Customer Cart Signal & Multi-Store State Tests', () {
    final testStore1 = Store(
      id: 'store-1',
      merchantId: 'merchant-1',
      name: 'Downtown Cafe',
      slug: 'downtown-cafe',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final testStore2 = Store(
      id: 'store-2',
      merchantId: 'merchant-2',
      name: 'Uptown Bakery',
      slug: 'uptown-bakery',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final chaiCategory = Category(
      id: 'cat-beverages',
      merchantId: 'merchant-1',
      storeId: 'store-1',
      name: 'Beverages',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final bakeryCategory = Category(
      id: 'cat-bakery',
      merchantId: 'merchant-1',
      storeId: 'store-1',
      name: 'Bakery',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final masalaChai = Product(
      id: 'prod-chai',
      merchantId: 'merchant-1',
      name: 'Masala Chai',
      description: 'Traditional spiced Indian tea',
      basePrice: 15.0,
      sellingPrice: 30.0, // ₹30.00
      taxRate: 5.0, // 5% GST
      isActive: true,
      category: chaiCategory,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final samosa = Product(
      id: 'prod-samosa',
      merchantId: 'merchant-1',
      name: 'Crispy Samosa',
      description: 'Deep-fried potato pastry snack',
      basePrice: 10.0,
      sellingPrice: 25.0, // ₹25.00
      taxRate: 12.0, // 12% GST
      isActive: true,
      category: bakeryCategory,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final paneerPuff = Product(
      id: 'prod-puff',
      merchantId: 'merchant-1',
      name: 'Paneer Puff',
      description: 'Flaky baked pastry stuffed with cottage cheese',
      basePrice: 20.0,
      sellingPrice: 45.0, // ₹45.00
      taxRate: 18.0, // 18% GST
      isActive: true,
      category: bakeryCategory,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    setUp(() {
      storeCartsSignal.value = {};
      clearActiveStore();
      closeCartDrawer();
    });

    test('Initial cart state is empty and drawer is closed', () {
      expect(storeCartsSignal.value.isEmpty, isTrue);
      expect(currentCartStoreIdSignal.value, isNull);
      expect(currentCartStoreSignal.value, isNull);
      expect(cartItemsSignal.value.isEmpty, isTrue);
      expect(isCartDrawerOpenSignal.value, isFalse);
    });

    test('Toggling and managing drawer state', () {
      expect(isCartDrawerOpenSignal.value, isFalse);

      openCartDrawer();
      expect(isCartDrawerOpenSignal.value, isTrue);

      closeCartDrawer();
      expect(isCartDrawerOpenSignal.value, isFalse);

      toggleCartDrawer();
      expect(isCartDrawerOpenSignal.value, isTrue);

      toggleCartDrawer();
      expect(isCartDrawerOpenSignal.value, isFalse);
    });

    test('Adding items updates active store and calculates prices & taxes in Rupees', () {
      setActiveStore(testStore1);

      // Add 2 Masala Chai: 2 * ₹30.00 = ₹60.00, Tax 5% = ₹3.00
      addToCart(testStore1.id, masalaChai, store: testStore1);
      addToCart(testStore1.id, masalaChai, store: testStore1);

      // Add 3 Samosas: 3 * ₹25.00 = ₹75.00, Tax 12% = ₹9.00
      addToCart(testStore1.id, samosa, store: testStore1);
      addToCart(testStore1.id, samosa, store: testStore1);
      addToCart(testStore1.id, samosa, store: testStore1);

      final items = cartItemsSignal.value;
      expect(items.length, 2);
      expect(items[masalaChai.id]?.quantity, 2);
      expect(items[samosa.id]?.quantity, 3);

      final subtotal = calculateSubtotal(items.values);
      final totalTax = calculateTotalTax(items.values);
      final grandTotal = calculateGrandTotal(items.values);

      // Subtotal = ₹60.00 + ₹75.00 = ₹135.00
      expect(subtotal, 135.0);

      // Tax = ₹3.00 + ₹9.00 = ₹12.00
      expect(totalTax, 12.0);

      // Grand Total = ₹135.00 + ₹12.00 = ₹147.00
      expect(grandTotal, 147.0);
    });

    test('Decreasing quantity reduces items and removes at zero', () {
      setActiveStore(testStore1);
      addToCart(testStore1.id, masalaChai, store: testStore1);
      addToCart(testStore1.id, masalaChai, store: testStore1);

      expect(cartItemsSignal.value[masalaChai.id]?.quantity, 2);

      // Reduce 1 unit
      removeFromCart(masalaChai, storeId: testStore1.id);
      expect(cartItemsSignal.value[masalaChai.id]?.quantity, 1);
      expect(calculateSubtotal(cartItemsSignal.value.values), 30.0);

      // Reduce again -> product removed
      removeFromCart(masalaChai, storeId: testStore1.id);
      expect(cartItemsSignal.value.containsKey(masalaChai.id), isFalse);
      expect(cartItemsSignal.value.isEmpty, isTrue);
    });

    test('Removing product completely removes it regardless of quantity', () {
      setActiveStore(testStore1);
      addToCart(testStore1.id, paneerPuff, store: testStore1);
      addToCart(testStore1.id, paneerPuff, store: testStore1);
      addToCart(testStore1.id, paneerPuff, store: testStore1);
      expect(cartItemsSignal.value[paneerPuff.id]?.quantity, 3);

      removeProductCompletely(paneerPuff.id, storeId: testStore1.id);
      expect(cartItemsSignal.value.containsKey(paneerPuff.id), isFalse);
      expect(cartItemsSignal.value.isEmpty, isTrue);
    });

    test('Clearing active store cart resets store cart items', () {
      setActiveStore(testStore1);
      addToCart(testStore1.id, masalaChai, store: testStore1);
      addToCart(testStore1.id, samosa, store: testStore1);

      expect(cartItemsSignal.value.isNotEmpty, isTrue);

      clearCart(storeId: testStore1.id);
      expect(cartItemsSignal.value.isEmpty, isTrue);
      expect(storeCartsSignal.value.containsKey(testStore1.id), isFalse);
    });

    test('Multi-store cart isolation: adding to store 2 does not affect store 1', () {
      addToCart(testStore1.id, masalaChai, store: testStore1);
      addToCart(testStore2.id, paneerPuff, store: testStore2);

      // Switch to Store 1
      setActiveStore(testStore1);
      expect(cartItemsSignal.value.length, 1);
      expect(cartItemsSignal.value.containsKey(masalaChai.id), isTrue);
      expect(cartItemsSignal.value.containsKey(paneerPuff.id), isFalse);
      expect(calculateSubtotal(cartItemsSignal.value.values), 30.0);

      // Switch to Store 2
      setActiveStore(testStore2);
      expect(cartItemsSignal.value.length, 1);
      expect(cartItemsSignal.value.containsKey(paneerPuff.id), isTrue);
      expect(cartItemsSignal.value.containsKey(masalaChai.id), isFalse);
      expect(calculateSubtotal(cartItemsSignal.value.values), 45.0);

      // Clearing Store 1 does not affect Store 2
      clearCart(storeId: testStore1.id);
      expect(storeCartsSignal.value.containsKey(testStore1.id), isFalse);
      expect(storeCartsSignal.value.containsKey(testStore2.id), isTrue);
    });

    test('Filtering catalog products by search query and category', () {
      final allProducts = [masalaChai, samosa, paneerPuff];

      // No filters applied
      final allFiltered = filterStoreProducts(products: allProducts);
      expect(allFiltered.length, 3);

      // Filter by category: Beverages
      final beverageProducts = filterStoreProducts(
        products: allProducts,
        categoryId: chaiCategory.id,
      );
      expect(beverageProducts.length, 1);
      expect(beverageProducts.first.name, 'Masala Chai');

      // Filter by category: Bakery
      final bakeryProducts = filterStoreProducts(
        products: allProducts,
        categoryId: bakeryCategory.id,
      );
      expect(bakeryProducts.length, 2);
      expect(bakeryProducts.map((p) => p.name), containsAll(['Crispy Samosa', 'Paneer Puff']));

      // Filter by search query: 'chai'
      final searchChai = filterStoreProducts(
        products: allProducts,
        searchQuery: 'chai',
      );
      expect(searchChai.length, 1);
      expect(searchChai.first.id, masalaChai.id);

      // Filter by search query matching description: 'cottage cheese'
      final searchDescription = filterStoreProducts(
        products: allProducts,
        searchQuery: 'cottage cheese',
      );
      expect(searchDescription.length, 1);
      expect(searchDescription.first.id, paneerPuff.id);

      // Filter by both category and non-matching query
      final noMatches = filterStoreProducts(
        products: allProducts,
        categoryId: chaiCategory.id,
        searchQuery: 'puff',
      );
      expect(noMatches.isEmpty, isTrue);
    });
  });
}
