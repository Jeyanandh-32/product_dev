import 'package:customer/components/signal_component.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:customer/signals/customer_auth_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router;
import 'package:jaspr_router/jaspr_router.dart';

class AppLayout extends SignalComponent {
  const AppLayout({super.key, required this.child});

  final Component child;

  @override
  SignalState<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends SignalState<AppLayout> {
  @override
  Component buildSignal(BuildContext context) {
    final customer = customerAuthSignal.value.value;
    final cartItems = cartItemsSignal.value.values.toList();
    final totalCartCount = cartItems.fold<int>(0, (sum, item) => sum + item.quantity);

    return div(
      classes: 'min-h-screen bg-white text-gray-900 flex flex-col font-sans selection:bg-gray-900 selection:text-white',
      [
        // Sleek Ultra-Minimalist Top Header Navigation Bar
        header(
          classes: 'bg-white/80 backdrop-blur-md border-b border-gray-200 sticky top-0 z-40 px-6 py-4 transition-all',
          [
            div(
              classes: 'max-w-6xl mx-auto flex items-center justify-between',
              [
                // Brand Logo (Script Typography without icon)
                button(
                  classes: 'cursor-pointer border-0 bg-transparent p-0 text-left group',
                  onClick: () => Router.of(context).push('/'),
                  [
                    h1(
                      classes: 'font-script text-primary text-3xl font-normal hover:opacity-80 transition-opacity',
                      [
                        .text('Branding'),
                      ],
                    ),
                  ],
                ),

                // Right Actions: Cart Pill & Customer Avatar
                div(classes: 'flex items-center gap-4', [
                  // Minimalist Cart Trigger Pill
                  button(
                    classes:
                        'px-4 py-2 rounded-full bg-neutral hover:bg-gray-200 text-black font-semibold text-xs flex items-center gap-2.5 cursor-pointer border border-gray-200/60 transition-all shadow-2xs active:scale-98',
                    onClick: () => Router.of(context).push('/cart'),
                    [
                      ShoppingBag(classes: 'w-4 h-4 text-black'),
                      span(classes: 'font-bold', [
                        .text('Cart'),
                      ]),
                      if (totalCartCount > 0)
                        span(
                          classes: 'bg-black text-white px-2 py-0.5 rounded-full text-[10px] font-extrabold',
                          [
                            .text('$totalCartCount'),
                          ],
                        ),
                    ],
                  ),

                  // Customer Initials Pill
                  if (customer != null)
                    div(
                      classes:
                          'w-8 h-8 rounded-full bg-gray-100 text-black font-bold text-xs flex items-center justify-center border border-gray-200/80',
                      [
                        .text(customer.name.isNotEmpty ? customer.name[0].toUpperCase() : 'C'),
                      ],
                    ),
                ]),
              ],
            ),
          ],
        ),

        // Main Route Content Container (Tightened Compact Layout)
        main_(classes: 'flex-1 max-w-5xl w-full mx-auto p-4 md:p-6 flex flex-col gap-6', [
          component.child,
        ]),
      ],
    );
  }
}
