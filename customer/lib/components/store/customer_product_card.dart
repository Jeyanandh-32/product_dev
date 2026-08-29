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
      classes:
          'bg-white rounded-2xl p-3.5 border border-gray-200 hover:border-black transition-all flex flex-col justify-between gap-3 group relative shadow-2xs hover:shadow-md',
      [
        // Top Compact Image Container
        div(
          classes:
              'w-full h-28 bg-gray-100 rounded-xl flex items-center justify-center relative overflow-hidden group-hover:scale-[1.02] transition-transform',
          [
            if (product.imageUrl case final url? when url.isNotEmpty)
              img(
                src: url,
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
            classes:
                'text-sm font-extrabold text-black group-hover:opacity-80 transition-opacity line-clamp-1',
            [
              .text(product.name),
            ],
          ),
          if (product.description case final desc? when desc.isNotEmpty)
            p(classes: 'text-xs text-gray-400 line-clamp-1', [
              .text(desc),
            ]),
        ]),

        // Price & Actions Column
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
                onClick: isOutOfStock
                    ? null
                    : () => addToCart(store.id, product, store: store),
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
                    onClick: () => removeFromCart(product, storeId: store.id),
                    [
                      Minus(classes: 'w-3.5 h-3.5'),
                    ],
                  ),
                  span(
                    classes:
                        'font-black text-sm sm:text-base text-black min-w-6 text-center select-none',
                    [
                      .text('$cartQty'),
                    ],
                  ),
                  button(
                    classes: isOutOfStock
                        ? 'w-7 h-7 rounded-full bg-gray-200 text-gray-400 font-bold flex items-center justify-center border-0 cursor-not-allowed opacity-50'
                        : 'w-7 h-7 rounded-full bg-white hover:bg-black hover:text-white text-black font-bold flex items-center justify-center cursor-pointer border-0 transition-colors shadow-2xs active:scale-95',
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
