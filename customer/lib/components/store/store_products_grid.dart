import 'package:customer/components/store/customer_product_card.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;
import 'package:models/models.dart';

/// Responsive grid displaying store products with quantity add/remove controls.
class StoreProductsGrid extends StatelessComponent {
  final List<Product> products;
  final Store? currentStore;
  final Map<String, CartItem> cartItems;
  final String searchQuery;
  final String? selectedCategoryId;

  const StoreProductsGrid({
    super.key,
    required this.products,
    required this.currentStore,
    required this.cartItems,
    required this.searchQuery,
    required this.selectedCategoryId,
  });

  @override
  Component build(BuildContext context) {
    final query = searchQuery.trim().toLowerCase();
    final filtered = products.where((product) {
      final matchesCategory =
          selectedCategoryId == null ||
          product.category?.id == selectedCategoryId;
      final matchesQuery =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          (product.description?.toLowerCase().contains(query) ?? false);
      return matchesCategory && matchesQuery;
    }).toList();

    if (filtered.isEmpty) {
      return div(
        classes: 'p-16 text-center bg-gray-50/50 rounded-3xl text-gray-400 font-medium border border-dashed border-gray-200 flex flex-col items-center gap-3',
        [
          SearchX(classes: 'w-10 h-10 text-gray-300'),
          .text(
            query.isEmpty && selectedCategoryId == null
                ? 'No products available in this store menu.'
                : 'No products match your filter.',
          ),
        ],
      );
    }

    return div(
      classes: 'grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 sm:gap-6',
      [
        if (currentStore case final store?)
          for (final product in filtered)
            CustomerProductCard(
              store: store,
              product: product,
              cartQty: cartItems[product.id]?.quantity ?? 0,
            ),
      ],
    );
  }
}
