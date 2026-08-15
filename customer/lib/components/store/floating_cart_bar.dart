import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router;
import 'package:jaspr_router/jaspr_router.dart';

class FloatingCartBar extends StatelessComponent {
  final int totalCartCount;
  final double totalCartPrice;

  const FloatingCartBar({
    super.key,
    required this.totalCartCount,
    required this.totalCartPrice,
  });

  @override
  Component build(BuildContext context) {
    if (totalCartCount <= 0) return div([]);

    return div(
      classes:
          'fixed bottom-6 inset-x-4 max-w-xl mx-auto z-50 bg-black text-white p-3.5 px-5 rounded-2xl shadow-2xl flex items-center justify-between gap-4 border border-gray-800 animate-in fade-in slide-in-from-bottom-4 duration-200',
      [
        div(classes: 'flex items-center gap-3', [
          div(
            classes:
                'bg-white text-black font-extrabold text-xs px-2.5 py-1 rounded-full shadow-2xs',
            [
              .text(
                '$totalCartCount ${totalCartCount == 1 ? 'item' : 'items'}',
              ),
            ],
          ),
          span(classes: 'text-base font-extrabold text-white', [
            .text('₹${totalCartPrice.toStringAsFixed(2)}'),
          ]),
        ]),
        button(
          classes:
              'bg-white hover:bg-gray-100 text-black font-extrabold text-xs sm:text-sm px-4 py-2 rounded-xl flex items-center gap-2 transition-all cursor-pointer border-0 shadow-2xs active:scale-95',
          onClick: () => Router.of(context).push('/cart'),
          [
            ShoppingBag(classes: 'w-4 h-4 text-black'),
            .text('View Cart'),
            ArrowRight(classes: 'w-4 h-4 text-black'),
          ],
        ),
      ],
    );
  }
}
