import 'package:customer/signals/cart_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/store.dart' as icon;
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;

/// Renders an individual product item row inside the customer cart with quantity controls.
class CartItemCard extends StatelessComponent {
  final CartItem item;

  const CartItemCard({super.key, required this.item});

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'bg-white rounded-2xl p-3 border border-border-medium hover:border-slate-400 transition-all flex items-center justify-between gap-4 shadow-2xs group',
      [
        div(classes: 'flex items-center gap-3.5 min-w-0 flex-1', [
          div(
            classes: 'w-16 h-16 bg-slate-50 rounded-xl flex items-center justify-center shrink-0 overflow-hidden border border-border-light',
            [
              if (item.product.imageUrl case final url? when url.isNotEmpty)
                img(
                  src: url,
                  classes: 'w-full h-full object-cover',
                )
              else
                icon.Store(classes: 'w-6 h-6 text-slate-300'),
            ],
          ),
          div(classes: 'flex flex-col min-w-0 gap-0.5', [
            h3(
              classes: 'text-sm sm:text-base font-extrabold text-slate-900 truncate group-hover:text-[#0B132B] transition-colors',
              [
                .text(item.product.name),
              ],
            ),
            span(classes: 'text-xs text-slate-400 font-medium', [
              .text(
                '₹${item.product.sellingPrice.toStringAsFixed(2)} × ${item.quantity}',
              ),
            ]),
            span(
              classes:
                  'text-xs sm:text-sm font-extrabold text-slate-900 mt-0.5',
              [
                .text(
                  '₹${(item.product.sellingPrice * item.quantity).toStringAsFixed(2)}',
                ),
              ],
            ),
          ]),
        ]),

        // Terminal Stepper Pill (- qty +) & Trash Removal Button
        div(classes: 'flex items-center gap-2.5 shrink-0', [
          div(
            classes: 'bg-slate-100 p-1 rounded-full flex items-center gap-1 border border-border-medium shadow-2xs',
            [
              button(
                classes: 'w-7 h-7 rounded-full bg-white hover:bg-[#0B132B] hover:text-white text-slate-800 font-bold flex items-center justify-center cursor-pointer border-0 transition-colors shadow-2xs active:scale-95',
                onClick: () => removeFromCart(item.product),
                [
                  Minus(classes: 'w-3.5 h-3.5'),
                ],
              ),
              span(
                classes: 'font-black text-xs sm:text-sm text-slate-900 min-w-5.5 text-center select-none px-1',
                [
                  .text('${item.quantity}'),
                ],
              ),
              button(
                classes: 'w-7 h-7 rounded-full bg-white hover:bg-[#0B132B] hover:text-white text-slate-800 font-bold flex items-center justify-center cursor-pointer border-0 transition-colors shadow-2xs active:scale-95',
                onClick: () => addToCart(
                  currentCartStoreIdSignal.value ?? '',
                  item.product,
                ),
                [
                  Plus(classes: 'w-3.5 h-3.5'),
                ],
              ),
            ],
          ),

          button(
            classes: 'w-8 h-8 rounded-full text-red-500 hover:bg-red-600 hover:text-white flex items-center justify-center cursor-pointer border-0 transition-all active:scale-95',
            onClick: () => removeProductCompletely(item.product.id),
            [
              Trash2(classes: 'w-4 h-4'),
            ],
          ),
        ]),
      ],
    );
  }
}
