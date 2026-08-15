import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Router, Store;
import 'package:models/models.dart';

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
    return div(
      classes:
          'p-16 text-center bg-gray-50/50 rounded-3xl text-gray-400 font-medium border border-dashed border-gray-200 flex flex-col items-center justify-center gap-4',
      [
        div(
          classes:
              'w-16 h-16 rounded-full bg-gray-100 flex items-center justify-center text-black',
          [
            ShoppingBag(classes: 'w-8 h-8'),
          ],
        ),
        h3(classes: 'text-lg font-bold text-black', [
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
              currentStore != null
                  ? 'Back to ${currentStore!.name}'
                  : 'Explore Stores',
            ),
          ],
        ),
      ],
    );
  }
}
