import 'package:client_repositories/client_repositories.dart';
import 'package:customer/components/signal_component.dart';
import 'package:customer/components/store/floating_cart_bar.dart';
import 'package:customer/components/store/store_category_filters.dart';
import 'package:customer/components/store/store_product_search_bar.dart';
import 'package:customer/components/store/store_products_grid.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:customer/signals/recent_stores_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;
import 'package:jaspr_router/jaspr_router.dart';
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
  late final categoriesSignal = asyncSignal<List<Category>>(
    const AsyncLoading(),
  );

  String _searchQuery = '';
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _fetchStoreData();
  }

  @override
  void didUpdateComponent(StoreDetailPage oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (oldComponent.slug != component.slug) {
      _fetchStoreData();
    }
  }

  Future<void> _fetchStoreData() async {
    try {
      final store = await StoreRepository.getBySlug(component.slug);
      storeSignal.value = AsyncData(store);

      if (store != null) {
        setActiveStore(store);
        recordStoreVisitSignal(store.id);
        await Future.wait([
          _fetchCategories(store.id),
          _fetchProducts(store.id),
        ]);
      } else {
        productsSignal.value = const AsyncData([]);
        categoriesSignal.value = const AsyncData([]);
      }
    } catch (e, stack) {
      storeSignal.value = AsyncError(e, stack);
      productsSignal.value = AsyncError(e, stack);
      categoriesSignal.value = AsyncError(e, stack);
    }
  }

  Future<void> _fetchCategories(String storeId) async {
    try {
      final categoriesRes = await CategoryRepository.getAll(
        storeId: storeId,
        size: 100,
      );
      categoriesSignal.value = AsyncData(categoriesRes.items);
    } catch (e, stack) {
      categoriesSignal.value = AsyncError(e, stack);
    }
  }

  Future<void> _fetchProducts(String storeId) async {
    try {
      final productsRes = await ProductRepository.getAll(
        storeId: storeId,
        size: 100,
      );
      productsSignal.value = AsyncData(productsRes.items);
    } catch (e, stack) {
      productsSignal.value = AsyncError(e, stack);
    }
  }

  @override
  Component buildSignal(BuildContext context) {
    final storeState = storeSignal.value;
    final productsState = productsSignal.value;
    final categoriesState = categoriesSignal.value;

    final isCatalogLoading = storeState.isLoading ||
        productsState.isLoading ||
        categoriesState.isLoading;

    if (isCatalogLoading) {
      return div(
        classes:
            'flex-1 flex flex-col items-center justify-center min-h-[60vh] gap-3 text-center my-auto w-full',
        [
          span(classes: 'loading loading-spinner loading-lg text-black', []),
          p(classes: 'text-xs font-semibold text-gray-400', [
            .text('Loading store & menu...'),
          ]),
        ],
      );
    }

    if (storeState.hasError ||
        !storeState.hasValue ||
        storeState.value == null) {
      return div(
        classes:
            'flex-1 flex flex-col items-center justify-center min-h-[60vh] gap-4 text-center p-6 my-auto w-full',
        [
          h2(
            classes: 'text-2xl font-bold text-black',
            [.text('Store Not Found')],
          ),
          button(
            classes: 'btn btn-neutral rounded-full px-6 font-bold cursor-pointer',
            onClick: () => Router.of(context).push('/?all=true'),
            [.text('Browse All Stores')],
          ),
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
        div(classes: 'flex items-center gap-3', [
          button(
            classes:
                'w-9 h-9 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-700 flex items-center justify-center cursor-pointer border-0 transition-all active:scale-95 shrink-0',
            onClick: () => Router.of(context).push('/?all=true'),
            [ArrowLeft(classes: 'w-5 h-5')],
          ),
          div(classes: 'flex flex-col', [
            h1(
              classes:
                  'text-2xl sm:text-3xl font-extrabold text-black tracking-tight leading-tight',
              [.text(currentStore.name)],
            ),
            if (currentStore.storeType != null &&
                currentStore.storeType!.isNotEmpty)
              span(classes: 'text-xs text-gray-500 font-medium capitalize', [
                .text(currentStore.storeType!),
              ]),
          ]),
        ]),

        if (!currentStore.isOnlineEnabled)
          div(
            classes:
                'w-full bg-amber-50 border border-amber-200 text-amber-900 rounded-2xl p-4 flex items-center gap-3 text-sm font-semibold shadow-2xs',
            [
              span(
                classes: 'text-amber-600 text-lg font-bold shrink-0',
                [.text('⚠️')],
              ),
              span([
                .text(
                  'Online ordering is currently paused for this store. You can browse the menu, but online checkout is unavailable.',
                ),
              ]),
            ],
          ),

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
