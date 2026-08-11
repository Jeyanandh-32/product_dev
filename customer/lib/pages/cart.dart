import 'package:client_repositories/client_repositories.dart';
import 'package:customer/components/signal_component.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:customer/signals/toast_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/store.dart' as icon;
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

class CartPage extends SignalComponent {
  const CartPage({super.key});

  @override
  SignalState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends SignalState<CartPage> {
  late final storeSignal = asyncSignal<Store?>(const AsyncLoading());
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchCartStore();
  }

  Future<void> _fetchCartStore() async {
    final storeId = currentCartStoreIdSignal.value;
    if (storeId == null) {
      storeSignal.value = const AsyncData(null);
      return;
    }

    try {
      final stores = await StoreRepository.getOnlineStores();
      final store = stores.where((st) => st.id == storeId).firstOrNull;
      storeSignal.value = AsyncData(store);
    } catch (e, stack) {
      storeSignal.value = AsyncError(e, stack);
    }
  }

  Future<void> _checkoutOrder() async {
    final storeId = currentCartStoreIdSignal.value;
    final items = cartItemsSignal.value.values.toList();

    if (storeId == null || items.isEmpty || _isSubmitting) return;

    setState(() => _isSubmitting = true);

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
        paymentMethod: PaymentMethod.cash,
      );

      showCustomerToast('Order placed successfully!', type: ToastType.success);
      clearCart();
      Router.of(context).push('/');
    } catch (e) {
      setState(() => _isSubmitting = false);
      showCustomerToast(e.toString(), type: ToastType.error);
    }
  }

  @override
  Component buildSignal(BuildContext context) {
    final items = cartItemsSignal.value.values.toList();
    final storeState = storeSignal.value;
    final currentStore = storeState.value;

    final subtotal = items.fold<double>(
      0.0,
      (sum, item) => sum + item.product.sellingPrice * item.quantity,
    );

    return div(classes: 'max-w-4xl mx-auto w-full flex flex-col gap-8', [
      // Top Navigation Header Row
      div(classes: 'flex items-center justify-between border-b border-gray-100 pb-6', [
        div(classes: 'flex items-center gap-4', [
          button(
            classes:
                'w-10 h-10 rounded-full bg-gray-100 hover:bg-black hover:text-white text-black transition-all flex items-center justify-center cursor-pointer border-0',
            onClick: () {
              if (currentStore?.slug != null) {
                Router.of(context).push('/store/${currentStore!.slug!}');
              } else {
                Router.of(context).push('/');
              }
            },
            [
              ArrowLeft(classes: 'w-5 h-5'),
            ],
          ),
          div(classes: 'flex flex-col', [
            h1(classes: 'text-xl md:text-3xl font-extrabold text-black tracking-tight', [
              .text('Your Shopping Cart'),
            ]),
            if (currentStore != null)
              span(classes: 'text-xs font-bold text-gray-400', [
                .text('Ordering from ${currentStore.name}'),
              ]),
          ]),
        ]),

        if (items.isNotEmpty)
          button(
            classes: 'text-xs font-bold text-red-600 hover:text-red-800 cursor-pointer border-0 bg-transparent',
            onClick: clearCart,
            [
              .text('Clear Cart'),
            ],
          ),
      ]),

      // Cart Items List & Summary Container
      if (items.isEmpty)
        div(
          classes:
              'p-16 text-center bg-gray-50/50 rounded-3xl text-gray-400 font-medium border border-dashed border-gray-200 flex flex-col items-center justify-center gap-4',
          [
            div(
              classes: 'w-16 h-16 rounded-full bg-gray-100 flex items-center justify-center text-black',
              [
                ShoppingBag(classes: 'w-8 h-8'),
              ],
            ),
            h3(classes: 'text-lg font-bold text-black', [
              .text('Your cart is empty'),
            ]),
            p(classes: 'text-sm text-gray-500 max-w-sm', [
              .text('Browse store catalog menus to add items to your cart.'),
            ]),
            button(
              classes:
                  'mt-2 px-6 py-3 rounded-full bg-black text-white font-bold text-xs hover:bg-gray-800 transition-all cursor-pointer border-0',
              onClick: () => Router.of(context).push('/'),
              [
                .text('Explore Stores'),
              ],
            ),
          ],
        )
      else
        div(classes: 'grid grid-cols-1 lg:grid-cols-3 gap-8 items-start', [
          // Left Column: Items List
          div(classes: 'lg:col-span-2 flex flex-col gap-4', [
            for (final item in items)
              div(
                classes:
                    'bg-white rounded-2xl p-3 border border-gray-200 hover:border-black transition-all flex items-center justify-between gap-4 shadow-2xs group',
                [
                  div(classes: 'flex items-center gap-3.5 min-w-0 flex-1', [
                    div(
                      classes:
                          'w-16 h-16 bg-gray-100 rounded-xl flex items-center justify-center shrink-0 overflow-hidden border border-gray-100',
                      [
                        if (item.product.imageUrl != null && item.product.imageUrl!.isNotEmpty)
                          img(
                            src: item.product.imageUrl!,
                            classes: 'w-full h-full object-cover',
                          )
                        else
                          icon.Store(classes: 'w-6 h-6 text-gray-400'),
                      ],
                    ),
                    div(classes: 'flex flex-col min-w-0', [
                      h3(
                        classes: 'text-sm sm:text-base font-extrabold text-black truncate group-hover:opacity-80',
                        [
                          .text(item.product.name),
                        ],
                      ),
                      span(classes: 'text-xs text-gray-400 font-medium', [
                        .text('₹${item.product.sellingPrice.toStringAsFixed(2)}'),
                      ]),
                    ]),
                  ]),

                  // Terminal Stepper Pill (+ qty -) & Trash Removal Button
                  div(classes: 'flex items-center gap-2.5 shrink-0', [
                    div(
                      classes: 'bg-gray-100 p-1 rounded-full flex items-center gap-1 border border-gray-200 shadow-2xs',
                      [
                        button(
                          classes:
                              'w-7 h-7 rounded-full bg-white hover:bg-black hover:text-white text-black font-bold flex items-center justify-center cursor-pointer border-0 transition-colors shadow-2xs active:scale-95',
                          onClick: () => addToCart(
                            currentCartStoreIdSignal.value ?? '',
                            item.product,
                          ),
                          [
                            Plus(classes: 'w-3.5 h-3.5'),
                          ],
                        ),
                        span(
                          classes: 'font-black text-xs sm:text-sm text-black min-w-5.5 text-center select-none px-1',
                          [
                            .text('${item.quantity}'),
                          ],
                        ),
                        button(
                          classes:
                              'w-7 h-7 rounded-full bg-white hover:bg-black hover:text-white text-black font-bold flex items-center justify-center cursor-pointer border-0 transition-colors shadow-2xs active:scale-95',
                          onClick: () => removeFromCart(item.product),
                          [
                            Minus(classes: 'w-3.5 h-3.5'),
                          ],
                        ),
                      ],
                    ),

                    button(
                      classes:
                          'w-8 h-8 rounded-full text-red-500 hover:bg-red-600 hover:text-white flex items-center justify-center cursor-pointer border-0 transition-all active:scale-95',
                      onClick: () => removeProductCompletely(item.product.id),
                      [
                        Trash2(classes: 'w-4 h-4'),
                      ],
                    ),
                  ]),
                ],
              ),
          ]),

          // Right Column: Order Summary Card
          div(
            classes: 'bg-white rounded-3xl p-6 border border-gray-200/80 shadow-sm flex flex-col gap-6 sticky top-24',
            [
              h2(classes: 'text-lg font-extrabold text-black tracking-tight border-b border-gray-100 pb-4', [
                .text('Order Summary'),
              ]),

              div(classes: 'flex flex-col gap-3 text-sm', [
                div(classes: 'flex justify-between items-center text-gray-500', [
                  span([.text('Item Subtotal')]),
                  span(classes: 'font-semibold text-black', [
                    .text('₹${subtotal.toStringAsFixed(2)}'),
                  ]),
                ]),
                div(classes: 'flex justify-between items-center text-gray-500', [
                  span([.text('Order Type')]),
                  span(classes: 'font-semibold text-black', [
                    .text('Takeaway Pickup'),
                  ]),
                ]),
                div(classes: 'flex justify-between items-center text-gray-500', [
                  span([.text('Payment')]),
                  span(classes: 'font-semibold text-black', [
                    .text('Pay at Store (Cash)'),
                  ]),
                ]),
                div(
                  classes:
                      'border-t border-gray-100 pt-3 flex justify-between items-center text-base font-extrabold text-black',
                  [
                    span([.text('Total')]),
                    span([.text('₹${subtotal.toStringAsFixed(2)}')]),
                  ],
                ),
              ]),

              button(
                classes:
                    'w-full py-4 rounded-2xl bg-black hover:bg-gray-800 text-white font-bold text-sm flex items-center justify-center gap-2 cursor-pointer transition-all shadow-sm border-0 active:scale-98',
                onClick: _checkoutOrder,
                [
                  if (_isSubmitting)
                    span(classes: 'loading loading-spinner loading-sm', [])
                  else ...[
                    .text('Place Order Now'),
                    ArrowRight(classes: 'w-4 h-4'),
                  ],
                ],
              ),
            ],
          ),
        ]),
    ]);
  }
}
