import 'package:customer/signals/cart_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/store.dart' as icon;
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;

/// Renders a compact item preview row in the slide-over cart drawer.
class DrawerCartItemRow extends StatelessComponent {
  final CartItem item;

  const DrawerCartItemRow({super.key, required this.item});

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'bg-neutral/40 rounded-2xl p-4 flex items-center justify-between gap-4 border-0',
      [
        div(classes: 'flex items-center gap-3 min-w-0', [
          div(
            classes: 'w-14 h-14 bg-white rounded-xl flex items-center justify-center shrink-0 overflow-hidden shadow-2xs',
            [
              if (item.product.imageUrl case final url? when url.isNotEmpty)
                img(
                  src: url,
                  classes: 'w-full h-full object-cover',
                )
              else
                icon.Store(classes: 'w-6 h-6 text-gray-300'),
            ],
          ),
          div(classes: 'flex flex-col min-w-0', [
            h4(
              classes: 'text-sm font-bold text-slate-900 truncate',
              [.text(item.product.name)],
            ),
            span(
              classes: 'text-xs font-bold text-slate-900',
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
          classes: 'flex items-center gap-2 bg-white rounded-xl p-1 shadow-2xs border-0 shrink-0',
          [
            button(
              classes: 'w-7 h-7 rounded-lg bg-slate-100 hover:bg-slate-200 text-slate-700 cursor-pointer border-0',
              onClick: () => removeFromCart(item.product),
              [Minus(classes: 'w-3.5 h-3.5')],
            ),
            span(
              classes: 'font-bold text-xs min-w-4 text-center text-slate-900',
              [.text('${item.quantity}')],
            ),
            button(
              classes: 'w-7 h-7 rounded-lg bg-slate-100 hover:bg-[#0B132B] hover:text-white text-slate-800 flex items-center justify-center cursor-pointer transition-all active:scale-95 shadow-2xs border-0',
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
