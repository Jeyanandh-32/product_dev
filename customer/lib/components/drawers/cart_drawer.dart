import 'package:customer/components/drawers/drawer_cart_item_row.dart';
import 'package:customer/components/signal_component.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;

class CartDrawer extends SignalComponent {
  const CartDrawer({super.key});

  @override
  SignalState<CartDrawer> createState() => _CartDrawerState();
}

class _CartDrawerState extends SignalState<CartDrawer> {
  @override
  Component buildSignal(BuildContext context) {
    final isOpen = isCartDrawerOpenSignal.value;
    final items = cartItemsSignal.value.values.toList();
    final isSubmitting = isCartSubmittingSignal.value;

    final subtotal = items.fold<double>(
      0.0,
      (sum, item) => sum + (item.product.sellingPrice / 100) * item.quantity,
    );

    if (!isOpen) return div([]);

    return div(classes: 'fixed inset-0 z-50 overflow-hidden', [
      // Backdrop Blur Overlay
      div(
        classes:
            'absolute inset-0 bg-black/40 backdrop-blur-xs transition-opacity animate-in fade-in',
        events: {'click': (e) => closeCartDrawer()},
        [],
      ),

      // Slide-over Right Drawer Container
      div(classes: 'fixed inset-y-0 right-0 max-w-full flex pl-10', [
        div(
          classes:
              'w-screen max-w-md bg-white shadow-2xl flex flex-col justify-between transform transition-transform duration-300 ease-in-out',
          [
            // Drawer Header
            div(
              classes:
                  'p-6 border-b border-gray-100 flex items-center justify-between bg-neutral/50',
              [
                div(classes: 'flex items-center gap-3', [
                  div(
                    classes:
                        'w-10 h-10 rounded-xl bg-soft-green text-soft-green-content flex items-center justify-center font-bold',
                    [
                      ShoppingBag(classes: 'w-5 h-5 text-emerald-accent'),
                    ],
                  ),
                  div(classes: 'flex flex-col', [
                    h2(classes: 'text-base font-bold text-gray-900', [
                      .text('Your Shopping Cart'),
                    ]),
                    span(classes: 'text-xs text-gray-500 font-medium', [
                      .text('${items.length} unique items'),
                    ]),
                  ]),
                ]),
                button(
                  classes:
                      'w-9 h-9 rounded-full bg-white hover:bg-gray-100 text-gray-500 flex items-center justify-center transition-all cursor-pointer border-0 shadow-2xs',
                  onClick: closeCartDrawer,
                  [
                    X(classes: 'w-5 h-5'),
                  ],
                ),
              ],
            ),

            // Item List Body
            div(classes: 'flex-1 overflow-y-auto p-6 flex flex-col gap-4', [
              if (items.isEmpty)
                div(
                  classes:
                      'h-full flex flex-col items-center justify-center text-center p-8 gap-4',
                  [
                    div(
                      classes:
                          'w-20 h-20 rounded-full bg-soft-green flex items-center justify-center text-emerald-accent',
                      [
                        ShoppingBag(classes: 'w-10 h-10'),
                      ],
                    ),
                    h3(classes: 'text-base font-bold text-gray-800', [
                      .text('Your cart is currently empty'),
                    ]),
                    p(classes: 'text-xs text-gray-500 max-w-xs', [
                      .text(
                        'Browse stores and add products to start your order checkout.',
                      ),
                    ]),
                  ],
                )
              else
                for (final item in items) DrawerCartItemRow(item: item),
            ]),

            // Drawer Footer Checkout Action
            if (items.isNotEmpty)
              div(
                classes:
                    'p-6 border-t border-gray-100 bg-white flex flex-col gap-4',
                [
                  div(classes: 'flex justify-between items-center', [
                    span(classes: 'text-sm font-medium text-gray-500', [
                      .text('Subtotal'),
                    ]),
                    span(
                      classes: 'text-lg font-extrabold text-gray-900',
                      [
                        .text('₹${subtotal.toStringAsFixed(2)}'),
                      ],
                    ),
                  ]),
                  button(
                    classes:
                        'w-full py-4 rounded-2xl bg-emerald-accent hover:bg-emerald-dark text-white font-bold text-base flex items-center justify-center gap-2 cursor-pointer transition-all shadow-md active:scale-98 border-0',
                    onClick: checkoutCurrentCart,
                    [
                      if (isSubmitting)
                        span(classes: 'loading loading-spinner loading-sm', [])
                      else ...[
                        .text('Place Order Now'),
                        ArrowRight(classes: 'w-5 h-5'),
                      ],
                    ],
                  ),
                ],
              ),
          ],
        ),
      ]),
    ]);
  }
}
