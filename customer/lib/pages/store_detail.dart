import 'package:customer/components/signal_component.dart';
import 'package:customer/components/store/floating_cart_bar.dart';
import 'package:customer/components/store/store_category_filters.dart';
import 'package:customer/components/store/store_detail_header.dart';
import 'package:customer/components/store/store_product_search_bar.dart';
import 'package:customer/components/store/store_products_grid.dart';
import 'package:customer/services/store_detail_loader.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

/// Store catalog and interactive ordering page for customers.
class StoreDetailPage extends SignalComponent {
  const StoreDetailPage({super.key, required this.slug});

  final String slug;

  @override
  SignalState<StoreDetailPage> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends SignalState<StoreDetailPage> {
  late final storeSignal = asyncSignal<Store?>(const AsyncLoading());
  late final productsSignal = asyncSignal<List<Product>>(const AsyncLoading());
  late final categoriesSignal = asyncSignal<List<Category>>(const AsyncLoading());

  String _searchQuery = '';
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void didUpdateComponent(StoreDetailPage oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (oldComponent.slug != component.slug) {
      _fetch();
    }
  }

  void _fetch() {
    StoreDetailLoader.loadStoreData(
      slug: component.slug,
      storeSignal: storeSignal,
      productsSignal: productsSignal,
      categoriesSignal: categoriesSignal,
    );
  }

  @override
  Component buildSignal(BuildContext context) {
    final storeState = storeSignal.value;
    final productsState = productsSignal.value;
    final categoriesState = categoriesSignal.value;

    if (storeState.isLoading || productsState.isLoading || categoriesState.isLoading) {
      return div(
        classes:
            'flex-1 min-h-[60vh] flex flex-col items-center justify-center gap-4 text-center my-auto w-full',
        [
          span(classes: 'loading loading-spinner loading-lg text-black', []),
          p(classes: 'text-sm font-semibold text-gray-500', [
            .text('Loading store menu...'),
          ]),
        ],
      );
    }

    if (storeState.hasError || storeState.value == null) {
      return div(
        classes:
            'min-h-[50vh] flex flex-col items-center justify-center gap-4 text-center px-4',
        [
          h1(classes: 'text-2xl font-bold text-black', [.text('Store Not Found')]),
          p(classes: 'text-sm text-gray-500', [
            .text('The requested store catalog does not exist or is inactive.'),
          ]),
        ],
      );
    }

    final currentStore = storeState.value!;
    final cartItems = storeCartsSignal.value[currentStore.id] ?? {};
    final totalCartCount = cartItems.values.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );
    final totalCartPrice = cartItems.values.fold<double>(
      0.0,
      (sum, item) => sum + ((item.product.sellingPrice * item.quantity) / 100.0),
    );

    return div(
      classes: 'flex flex-col gap-6 max-w-4xl w-full mx-auto pb-28',
      [
        StoreDetailHeader(store: currentStore),

        div(classes: 'flex flex-col gap-3', [
          StoreProductSearchBar(
            searchQuery: _searchQuery,
            onQueryChanged: (val) => setState(() => _searchQuery = val),
          ),
          if (categoriesState.hasValue &&
              (categoriesState.value?.isNotEmpty ?? false))
            StoreCategoryFilters(
              categories: categoriesState.value!,
              selectedCategoryId: _selectedCategoryId,
              onSelectCategory: (catId) =>
                  setState(() => _selectedCategoryId = catId),
            ),
        ]),

        div(
          classes:
              'flex items-center justify-between border-t border-gray-200 pt-6',
          [
            h2(classes: 'text-xl font-extrabold text-black tracking-tight', [
              .text(_searchQuery.isEmpty ? 'Menu Products' : 'Search Results'),
            ]),
          ],
        ),

        switch (productsState) {
          AsyncData(value: final products) => StoreProductsGrid(
            products: products,
            currentStore: currentStore,
            cartItems: cartItems,
            searchQuery: _searchQuery,
            selectedCategoryId: _selectedCategoryId,
          ),
          AsyncError() => div(
            classes:
                'p-6 bg-red-50 text-red-600 rounded-2xl text-center font-semibold border border-red-100 text-xs',
            [
              .text('Failed to load menu products.'),
            ],
          ),
          _ => div([]),
        },

        FloatingCartBar(
          totalCartCount: totalCartCount,
          totalCartPrice: totalCartPrice,
        ),
      ],
    );
  }
}
