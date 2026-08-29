import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Router, Store;
import 'package:models/models.dart';

/// Empty state view presented when no items have been added to the customer shopping cart.
class EmptyCartState extends StatelessComponent {
  final Store? currentStore;
  final VoidCallback onExplore;

  const EmptyCartState({
    super.key,
    required this.currentStore,
    required this.onExplore,
  });

  @override
  Component build(BuildContext context) {
    final store = currentStore;

    return div(
      classes:
          'flex flex-col items-center justify-center py-16 px-4 text-center gap-3 bg-white rounded-3xl border border-dashed border-gray-200',
      [
        div(
          classes:
              'w-16 h-16 rounded-full bg-gray-100 flex items-center justify-center text-gray-400 mb-1',
          [ShoppingBag(classes: 'w-7 h-7 text-gray-400')],
        ),
        h2(classes: 'text-xl font-extrabold text-black', [
          .text('Your cart is empty'),
        ]),
        p(classes: 'text-sm text-gray-500 max-w-sm', [
          .text('Browse store catalog menus to add items to your cart.'),
        ]),
        button(
          classes:
              'mt-2 px-6 py-3 rounded-full bg-black text-white font-bold text-xs hover:bg-gray-800 transition-all cursor-pointer border-0',
          onClick: onExplore,
          [
            .text(
              store != null
                  ? 'Back to ${store.name}'
                  : 'Explore Stores',
            ),
          ],
        ),
      ],
    );
  }
}
