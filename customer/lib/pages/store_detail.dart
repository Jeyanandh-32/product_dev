import 'package:client_repositories/client_repositories.dart';
import 'package:customer/components/signal_component.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/store.dart' as icon;
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

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
  String? _selectedCategoryId; // null = 'All'

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
        // If navigating to a different store, reset cart state
        final currentCartStoreId = currentCartStoreIdSignal.value;
        if (currentCartStoreId != null && currentCartStoreId != store.id) {
          clearCart();
        }

        _fetchCategoriesAndProducts(store.id);
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

  Future<void> _fetchCategoriesAndProducts(String storeId) async {
    final catFuture = CategoryRepository.getAll(storeId: storeId)
        .then<AsyncState<List<Category>>>((res) => AsyncData(res.items))
        .catchError((_, st) => const AsyncData<List<Category>>([]));

    final prodFuture = ProductRepository.getAll(storeId: storeId)
        .then<AsyncState<List<Product>>>((res) => AsyncData(res.items))
        .catchError((e, stack) => AsyncError<List<Product>>(e, stack));

    final results = await Future.wait([catFuture, prodFuture]);

    categoriesSignal.value = results[0] as AsyncState<List<Category>>;
    productsSignal.value = results[1] as AsyncState<List<Product>>;
  }

  @override
  Component buildSignal(BuildContext context) {
    final storeState = storeSignal.value;
    final productsState = productsSignal.value;
    final categoriesState = categoriesSignal.value;
    final cartItems = cartItemsSignal.value;

    final currentStore = storeState.value;
    final isLoading = storeState is AsyncLoading || productsState is AsyncLoading;

    if (isLoading) {
      return div(
        classes: 'flex-1 flex justify-center items-center min-h-[60vh] w-full',
        [
          span(
            classes: 'loading loading-spinner loading-lg text-black',
            [],
          ),
        ],
      );
    }

    final cartItemList = cartItems.values.toList();
    final totalCartCount = cartItemList.fold<int>(0, (sum, item) => sum + item.quantity);
    final totalCartPrice = cartItemList.fold<double>(
      0.0,
      (sum, item) => sum + (item.product.sellingPrice * item.quantity),
    );

    return div(
      classes: totalCartCount > 0 ? 'flex flex-col gap-6 pb-28' : 'flex flex-col gap-6',
      [
        // Store Top Nav Header Row
        div(classes: 'flex items-center justify-between border-b border-gray-200 pb-4', [
          div(classes: 'flex items-center gap-4', [
            button(
              classes:
                  'w-10 h-10 rounded-full bg-gray-100 hover:bg-black hover:text-white text-black transition-all flex items-center justify-center cursor-pointer border-0',
              onClick: () => Router.of(context).push('/'),
              [
                ArrowLeft(classes: 'w-5 h-5'),
              ],
            ),
            switch (storeState) {
              AsyncData(value: final store) => div(classes: 'flex flex-col', [
                h1(
                  classes: 'text-xl md:text-3xl font-extrabold text-black tracking-tight leading-tight',
                  [
                    .text(store?.name ?? 'Store Menu'),
                  ],
                ),
                if (store?.storeType != null)
                  span(classes: 'text-xs font-semibold text-gray-400', [
                    .text(store!.storeType!),
                  ]),
              ]),
              _ => span(classes: 'text-xl font-bold text-black', [
                .text('Store Catalog'),
              ]),
            },
          ]),
        ]),

        if (storeState.value != null && !storeState.value!.isOnlineEnabled)
          div(
            classes:
                'w-full bg-amber-50 border border-amber-200 text-amber-900 rounded-2xl p-4 flex items-center gap-3 text-sm font-semibold shadow-2xs',
            [
              span(classes: 'text-amber-600 text-lg font-bold shrink-0', [.text('⚠️')]),
              span([
                .text(
                  'Online ordering is currently paused for this store. You can browse the menu, but online checkout is unavailable.',
                ),
              ]),
            ],
          ),

        // Search Capsule & Horizontal Category Filter Chips
        div(classes: 'flex flex-col gap-3', [
          // Minimalist Search Capsule (h-12 / 48px height)
          div(classes: 'w-full', [
            label(
              classes:
                  'w-full flex items-center gap-3 px-4 h-12 bg-gray-50 hover:bg-gray-100/90 rounded-xl border border-gray-200 shadow-2xs transition-all cursor-text focus-within:bg-white focus-within:border-black focus-within:ring-1 focus-within:ring-black',
              [
                Search(classes: 'w-4 h-4 text-gray-500 shrink-0'),
                input(
                  type: .search,
                  classes:
                      'grow w-full bg-transparent text-sm text-black font-medium focus:outline-none placeholder:text-gray-400',
                  attributes: {
                    'placeholder': 'Search menu products...',
                    'value': _searchQuery,
                  },
                  onInput: (value) => setState(() => _searchQuery = (value as String?) ?? ''),
                ),
                if (_searchQuery.isNotEmpty)
                  button(
                    classes: 'btn btn-ghost btn-xs btn-circle text-gray-400 hover:text-black cursor-pointer',
                    onClick: () => setState(() => _searchQuery = ''),
                    [
                      X(classes: 'w-4 h-4'),
                    ],
                  ),
              ],
            ),
          ]),

          // Horizontal Category Filter Pills
          switch (categoriesState) {
            AsyncData(:final value) => div(
              classes: 'flex gap-2.5 overflow-x-auto pb-1 scrollbar-none -mx-4 px-4 sm:mx-0 sm:px-0',
              [
                button(
                  classes: _selectedCategoryId == null
                      ? 'bg-black text-white font-bold text-sm sm:text-base py-1.5 pl-1.5 pr-4 rounded-full cursor-pointer border-0 transition-all flex items-center gap-2.5 shrink-0 shadow-2xs'
                      : 'bg-gray-100 hover:bg-gray-200 text-black font-extrabold text-sm sm:text-base py-1.5 pl-1.5 pr-4 rounded-full cursor-pointer border-0 transition-all flex items-center gap-2.5 shrink-0',
                  onClick: () => setState(() => _selectedCategoryId = null),
                  [
                    div(
                      classes: 'w-8 h-8 rounded-full bg-white/20 flex items-center justify-center text-sm shrink-0',
                      [
                        .text('✨'),
                      ],
                    ),
                    .text('All Products'),
                  ],
                ),
                for (final cat in value)
                  button(
                    classes: _selectedCategoryId == cat.id
                        ? 'bg-black text-white font-bold text-sm sm:text-base py-1.5 pl-1.5 pr-4 rounded-full cursor-pointer border-0 transition-all flex items-center gap-2.5 shrink-0 shadow-2xs'
                        : 'bg-gray-100 hover:bg-gray-200 text-black font-extrabold text-sm sm:text-base py-1.5 pl-1.5 pr-4 rounded-full cursor-pointer border-0 transition-all flex items-center gap-2.5 shrink-0',
                    onClick: () => setState(() => _selectedCategoryId = cat.id),
                    [
                      if (cat.imageUrl != null && cat.imageUrl!.trim().isNotEmpty)
                        img(
                          src: cat.imageUrl!,
                          classes: 'w-8 h-8 rounded-full object-cover shrink-0 border border-black/10 shadow-2xs',
                        )
                      else
                        div(
                          classes:
                              'w-8 h-8 rounded-full bg-gray-200 text-black flex items-center justify-center text-xs font-extrabold shrink-0',
                          [
                            .text(
                              cat.name.isNotEmpty ? cat.name[0].toUpperCase() : '?',
                            ),
                          ],
                        ),
                      .text(cat.name),
                    ],
                  ),
              ],
            ),
            _ => div([]),
          },
        ]),

        // Section Title
        div(
          classes: 'flex items-center justify-between border-t border-gray-200 pt-6',
          [
            h2(classes: 'text-xl font-extrabold text-black tracking-tight', [
              .text(_searchQuery.isEmpty ? 'Menu Products' : 'Search Results'),
            ]),
          ],
        ),

        // Sleek Ultra-Minimalist Product Cards Grid
        switch (productsState) {
          AsyncData(value: final products) => () {
            final query = _searchQuery.trim().toLowerCase();
            final filtered = products.where((product) {
              final matchesCategory = _selectedCategoryId == null || product.category?.id == _selectedCategoryId;
              final matchesQuery =
                  query.isEmpty ||
                  product.name.toLowerCase().contains(query) ||
                  (product.description?.toLowerCase().contains(query) ?? false);
              return matchesCategory && matchesQuery;
            }).toList();

            if (filtered.isEmpty) {
              return div(
                classes:
                    'p-16 text-center bg-gray-50/50 rounded-3xl text-gray-400 font-medium border border-dashed border-gray-200 flex flex-col items-center gap-3',
                [
                  SearchX(classes: 'w-10 h-10 text-gray-300'),
                  .text(
                    query.isEmpty && _selectedCategoryId == null
                        ? 'No products available in this store menu.'
                        : 'No products match your filter.',
                  ),
                ],
              );
            }

            return div(
              classes: 'grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 sm:gap-6',
              [
                for (final product in filtered)
                  if (currentStore != null)
                    _buildProductCard(
                      currentStore,
                      product,
                      cartItems[product.id]?.quantity ?? 0,
                    ),
              ],
            );
          }(),
          AsyncError() => div(
            classes: 'p-6 bg-red-50 text-red-600 rounded-2xl text-center font-semibold border border-red-100 text-xs',
            [
              .text('Failed to load menu products.'),
            ],
          ),
          _ => div([]),
        },

        // Floating Bottom Cart Bar (Appears when cart has items)
        if (totalCartCount > 0)
          div(
            classes:
                'fixed bottom-6 inset-x-4 max-w-xl mx-auto z-50 bg-black text-white p-3.5 px-5 rounded-2xl shadow-2xl flex items-center justify-between gap-4 border border-gray-800 animate-in fade-in slide-in-from-bottom-4 duration-200',
            [
              div(classes: 'flex items-center gap-3', [
                div(
                  classes: 'bg-white text-black font-extrabold text-xs px-2.5 py-1 rounded-full shadow-2xs',
                  [
                    .text('$totalCartCount ${totalCartCount == 1 ? 'item' : 'items'}'),
                  ],
                ),
                span(classes: 'text-base font-extrabold text-white', [
                  .text('₹${totalCartPrice.toStringAsFixed(2)}'),
                ]),
              ]),
              button(
                classes:
                    'bg-white hover:bg-gray-100 text-black font-extrabold text-xs sm:text-sm px-4 py-2 rounded-xl flex items-center gap-2 transition-all cursor-pointer border-0 shadow-2xs active:scale-95',
                onClick: () => Router.of(context).push('/cart'),
                [
                  ShoppingBag(classes: 'w-4 h-4 text-black'),
                  .text('View Cart'),
                  ArrowRight(classes: 'w-4 h-4 text-black'),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Component _buildProductCard(Store store, Product product, int cartQty) {
    final formattedPrice = '₹${product.sellingPrice.toStringAsFixed(2)}';
    final isOutOfStock = product.stock != null && product.stock!.quantity <= 0;

    return div(
      classes:
          'bg-white rounded-2xl p-3.5 border border-gray-200 hover:border-black transition-all flex flex-col justify-between gap-3 group relative shadow-2xs hover:shadow-md',
      [
        // Top Compact Image Container (h-28 / 112px height)
        div(
          classes:
              'w-full h-28 bg-gray-100 rounded-xl flex items-center justify-center relative overflow-hidden group-hover:scale-[1.02] transition-transform',
          [
            if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
              img(
                src: product.imageUrl!,
                classes: 'w-full h-full object-cover',
              )
            else
              icon.Store(classes: 'w-8 h-8 text-gray-300 opacity-60'),

            if (isOutOfStock)
              span(
                classes:
                    'absolute top-2 left-2 bg-red-600 text-white font-bold text-[9px] uppercase px-2 py-0.5 rounded-full shadow-2xs',
                [
                  .text('Out of Stock'),
                ],
              ),
          ],
        ),

        // Product Information Body
        div(classes: 'flex flex-col gap-0.5', [
          h3(
            classes: 'text-sm font-extrabold text-black group-hover:opacity-80 transition-opacity line-clamp-1',
            [
              .text(product.name),
            ],
          ),
          if (product.description != null && product.description!.isNotEmpty)
            p(classes: 'text-xs text-gray-400 line-clamp-1', [
              .text(product.description!),
            ]),
        ]),

        // Price & Actions Column (Add button below price)
        div(
          classes: 'flex flex-col gap-2 pt-2 border-t border-gray-200 mt-auto',
          [
            span(classes: 'text-sm font-extrabold text-black', [
              .text(formattedPrice),
            ]),
            if (cartQty == 0)
              button(
                classes: isOutOfStock
                    ? 'w-full py-2.5 rounded-xl bg-gray-100 text-gray-400 font-extrabold text-xs sm:text-sm flex items-center justify-center gap-1.5 border border-gray-200/80 cursor-not-allowed opacity-60'
                    : 'w-full py-2.5 rounded-xl bg-gray-100 hover:bg-gray-200 text-black font-extrabold text-xs sm:text-sm flex items-center justify-center gap-1.5 transition-all border border-gray-200/80 shadow-2xs cursor-pointer active:scale-98',
                disabled: isOutOfStock,
                onClick: isOutOfStock ? null : () => addToCart(store.id, product, store: store),
                [
                  Plus(classes: 'w-4 h-4 text-black'),
                  .text('Add'),
                ],
              )
            else
              div(
                classes:
                    'w-full bg-gray-100 p-1 rounded-full flex items-center justify-between border border-gray-200 shadow-2xs',
                [
                  button(
                    classes:
                        'w-7 h-7 rounded-full bg-white hover:bg-black hover:text-white text-black font-bold flex items-center justify-center cursor-pointer border-0 transition-colors shadow-2xs active:scale-95',
                    onClick: () => removeFromCart(product),
                    [
                      Minus(classes: 'w-3.5 h-3.5'),
                    ],
                  ),
                  span(
                    classes: 'font-black text-sm sm:text-base text-black min-w-6 text-center select-none',
                    [
                      .text('$cartQty'),
                    ],
                  ),
                  button(
                    classes: isOutOfStock
                        ? 'w-7 h-7 rounded-full bg-gray-200 text-gray-400 font-bold flex items-center justify-center border-0 cursor-not-allowed opacity-50'
                        : 'w-7 h-7 rounded-full bg-white hover:bg-black hover:text-white text-black font-bold flex items-center justify-center cursor-pointer border-0 transition-colors shadow-2xs active:scale-95',
                    disabled: isOutOfStock,
                    onClick: isOutOfStock ? null : () => addToCart(store.id, product, store: store),
                    [
                      Plus(classes: 'w-3.5 h-3.5'),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
