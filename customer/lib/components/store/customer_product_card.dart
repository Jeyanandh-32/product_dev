import 'package:customer/signals/cart_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/store.dart' as icon;
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;
import 'package:models/models.dart';

/// Product catalog card component displaying image, pricing, and add-to-cart actions for customers.
class CustomerProductCard extends StatelessComponent {
  final Store store;
  final Product product;
  final int cartQty;

  const CustomerProductCard({
    super.key,
    required this.store,
    required this.product,
    required this.cartQty,
  });

  @override
  Component build(BuildContext context) {
    final formattedPrice = '₹${product.sellingPrice.toStringAsFixed(2)}';
    final isOutOfStock = product.stock != null && product.stock!.quantity <= 0;

    return div(
      classes: 'bg-white rounded-2xl p-3.5 border border-border-medium hover:border-slate-400 transition-all flex flex-col justify-between gap-3 group relative shadow-2xs hover:shadow-md',
      [
        // Top Compact Image Container
        div(
          classes: 'w-full h-28 bg-slate-50 rounded-xl flex items-center justify-center relative overflow-hidden group-hover:scale-[1.02] transition-transform',
          [
            if (product.imageUrl case final url? when url.isNotEmpty)
              img(
                src: url,
                classes: 'w-full h-full object-cover',
              )
            else
              icon.Store(classes: 'w-8 h-8 text-slate-300 opacity-60'),

            if (isOutOfStock)
              span(
                classes: 'absolute top-2 left-2 bg-red-600 text-white font-bold text-[9px] uppercase px-2 py-0.5 rounded-full shadow-2xs',
                [
                  .text('Out of Stock'),
                ],
              ),
          ],
        ),

        // Product Information Body
        div(classes: 'flex flex-col gap-0.5', [
          h3(
            classes: 'text-sm font-extrabold text-slate-900 group-hover:text-[#0B132B] transition-colors line-clamp-1',
            [
              .text(product.name),
            ],
          ),
          if (product.description case final desc? when desc.isNotEmpty)
            p(classes: 'text-xs text-slate-400 line-clamp-1', [
              .text(desc),
            ]),
        ]),

        // Price & Actions Column
        div(
          classes:
              'flex flex-col gap-2 pt-2 border-t border-border-medium mt-auto',
          [
            span(classes: 'text-sm font-extrabold text-slate-900', [
              .text(formattedPrice),
            ]),
            if (cartQty == 0)
              button(
                classes: isOutOfStock
                    ? 'w-full py-2.5 rounded-xl bg-slate-100 text-slate-400 font-extrabold text-xs sm:text-sm flex items-center justify-center gap-1.5 border border-border-medium cursor-not-allowed opacity-60'
                    : 'w-full py-2.5 rounded-xl bg-slate-100 hover:bg-[#0B132B] text-slate-800 hover:text-white font-bold text-xs sm:text-sm flex items-center justify-center gap-1.5 transition-all border border-border-medium shadow-2xs cursor-pointer active:scale-98',
                disabled: isOutOfStock,
                onClick: isOutOfStock
                    ? null
                    : () => addToCart(store.id, product, store: store),
                [
                  Plus(classes: 'w-4 h-4'),
                  .text('Add'),
                ],
              )
            else
              div(
                classes: 'w-full bg-slate-100 p-1 rounded-full flex items-center justify-between border border-border-medium shadow-2xs',
                [
                  button(
                    classes: 'w-7 h-7 rounded-full bg-white hover:bg-[#0B132B] hover:text-white text-slate-800 font-bold flex items-center justify-center cursor-pointer border-0 transition-colors shadow-2xs active:scale-95',
                    onClick: () => removeFromCart(product, storeId: store.id),
                    [
                      Minus(classes: 'w-3.5 h-3.5'),
                    ],
                  ),
                  span(
                    classes: 'font-black text-sm sm:text-base text-slate-900 min-w-6 text-center select-none',
                    [
                      .text('$cartQty'),
                    ],
                  ),
                  button(
                    classes: isOutOfStock
                        ? 'w-7 h-7 rounded-full bg-slate-200 text-slate-400 font-bold flex items-center justify-center border-0 cursor-not-allowed opacity-50'
                        : 'w-7 h-7 rounded-full bg-white hover:bg-[#0B132B] hover:text-white text-slate-800 font-bold flex items-center justify-center cursor-pointer border-0 transition-colors shadow-2xs active:scale-95',
                    disabled: isOutOfStock,
                    onClick: isOutOfStock
                        ? null
                        : () => addToCart(store.id, product, store: store),
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
