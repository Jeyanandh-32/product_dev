import 'package:customer/signals/cart_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/store.dart' as icon;
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;

class CartItemCard extends StatelessComponent {
  final CartItem item;

  const CartItemCard({super.key, required this.item});

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'bg-white rounded-2xl p-3 border border-gray-200 hover:border-black transition-all flex items-center justify-between gap-4 shadow-2xs group',
      [
        div(classes: 'flex items-center gap-3.5 min-w-0 flex-1', [
          div(
            classes:
                'w-16 h-16 bg-gray-100 rounded-xl flex items-center justify-center shrink-0 overflow-hidden border border-gray-100',
            [
              if (item.product.imageUrl != null &&
                  item.product.imageUrl!.isNotEmpty)
                img(
                  src: item.product.imageUrl!,
                  classes: 'w-full h-full object-cover',
                )
              else
                icon.Store(classes: 'w-6 h-6 text-gray-400'),
            ],
          ),
          div(classes: 'flex flex-col min-w-0 gap-0.5', [
            h3(
              classes:
                  'text-sm sm:text-base font-extrabold text-black truncate group-hover:opacity-80',
              [
                .text(item.product.name),
              ],
            ),
            span(classes: 'text-xs text-gray-400 font-medium', [
              .text(
                '₹${item.product.sellingPrice.toStringAsFixed(2)} × ${item.quantity}',
              ),
            ]),
            span(
              classes: 'text-xs sm:text-sm font-extrabold text-black mt-0.5',
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
            classes:
                'bg-gray-100 p-1 rounded-full flex items-center gap-1 border border-gray-200 shadow-2xs',
            [
              button(
                classes:
                    'w-7 h-7 rounded-full bg-white hover:bg-black hover:text-white text-black font-bold flex items-center justify-center cursor-pointer border-0 transition-colors shadow-2xs active:scale-95',
                onClick: () => removeFromCart(item.product),
                [
                  Minus(classes: 'w-3.5 h-3.5'),
                ],
              ),
              span(
                classes:
                    'font-black text-xs sm:text-sm text-black min-w-5.5 text-center select-none px-1',
                [
                  .text('${item.quantity}'),
                ],
              ),
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
    );
  }
}
