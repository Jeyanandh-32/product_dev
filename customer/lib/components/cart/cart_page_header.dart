import 'package:customer/signals/cart_signal.dart';
import 'package:customer/utils/customer_navigation.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;
import 'package:models/models.dart';

/// Top header banner for cart page displaying store name and clear cart action.
class CartPageHeader extends StatelessComponent {
  final Store? currentStore;
  final bool hasItems;

  const CartPageHeader({
    super.key,
    required this.currentStore,
    required this.hasItems,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'flex items-center justify-between border-b border-gray-100 pb-6',
      [
        div(classes: 'flex items-center gap-4', [
          button(
            classes:
                'w-10 h-10 rounded-full bg-gray-100 hover:bg-black hover:text-white text-black transition-all flex items-center justify-center cursor-pointer border-0',
            onClick: () => navigateToRecentStoreOrAll(context),
            [
              ArrowLeft(classes: 'w-5 h-5'),
            ],
          ),
          div(classes: 'flex flex-col', [
            h1(
              classes:
                  'text-xl md:text-3xl font-extrabold text-black tracking-tight',
              [
                .text('Your Shopping Cart'),
              ],
            ),
            if (currentStore != null)
              span(classes: 'text-xs font-bold text-gray-400', [
                .text('Ordering from ${currentStore!.name}'),
              ]),
          ]),
        ]),

        if (hasItems)
          button(
            classes:
                'px-3.5 py-1.5 rounded-full bg-red-50 hover:bg-red-600 text-red-600 hover:text-white font-extrabold text-xs flex items-center gap-1.5 transition-all cursor-pointer border border-red-200/80 shadow-2xs active:scale-95 shrink-0',
            onClick: clearCart,
            [
              Trash2(classes: 'w-3.5 h-3.5'),
              .text('Clear Cart'),
            ],
          ),
      ],
    );
  }
}
