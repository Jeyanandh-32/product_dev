import 'package:customer/signals/cart_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/store.dart' as icon;
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;

class DrawerCartItemRow extends StatelessComponent {
  final CartItem item;

  const DrawerCartItemRow({super.key, required this.item});

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'bg-neutral/40 rounded-2xl p-4 flex items-center justify-between gap-4 border-0',
      [
        div(classes: 'flex items-center gap-3 min-w-0', [
          div(
            classes:
                'w-14 h-14 bg-white rounded-xl flex items-center justify-center shrink-0 overflow-hidden shadow-2xs',
            [
              if (item.product.imageUrl != null &&
                  item.product.imageUrl!.isNotEmpty)
                img(
                  src: item.product.imageUrl!,
                  classes: 'w-full h-full object-cover',
                )
              else
                icon.Store(classes: 'w-6 h-6 text-gray-300'),
            ],
          ),
          div(classes: 'flex flex-col min-w-0', [
            h4(
              classes: 'text-sm font-bold text-gray-900 truncate',
              [.text(item.product.name)],
            ),
            span(
              classes: 'text-xs font-semibold text-emerald-accent',
              [
                .text(
                  '₹${item.product.sellingPrice.toStringAsFixed(2)}',
                ),
              ],
            ),
          ]),
        ]),

        // Quantity Modifier Controls
        div(
          classes:
              'flex items-center gap-2 bg-white rounded-xl p-1 shadow-2xs border-0 shrink-0',
          [
            button(
              classes:
                  'w-7 h-7 rounded-lg bg-gray-50 hover:bg-gray-100 flex items-center justify-center text-gray-700 cursor-pointer border-0',
              onClick: () => removeFromCart(item.product),
              [Minus(classes: 'w-3.5 h-3.5')],
            ),
            span(
              classes:
                  'font-bold text-xs min-w-[16px] text-center text-gray-900',
              [.text('${item.quantity}')],
            ),
            button(
              classes:
                  'w-7 h-7 rounded-lg bg-emerald-accent hover:bg-emerald-dark text-white flex items-center justify-center cursor-pointer border-0 shadow-2xs',
              onClick: () => addToCart(
                currentCartStoreIdSignal.value ?? '',
                item.product,
              ),
              [Plus(classes: 'w-3.5 h-3.5')],
            ),
          ],
        ),
      ],
    );
  }
}
