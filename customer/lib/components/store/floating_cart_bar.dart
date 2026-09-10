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
      classes: 'fixed bottom-6 inset-x-4 max-w-xl mx-auto z-50 bg-[#0B132B] text-white p-3.5 px-5 rounded-2xl shadow-[0_8px_30px_rgba(11,19,43,0.35)] flex items-center justify-between gap-4 border border-[#1C2541] animate-in fade-in slide-in-from-bottom-4 duration-200',
      [
        div(classes: 'flex items-center gap-3', [
          div(
            classes: 'bg-blue-600/30 text-blue-300 border border-blue-400/30 font-extrabold text-xs px-2.5 py-1 rounded-full shadow-2xs',
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
          classes: 'bg-white hover:bg-slate-100 text-[#0B132B] font-extrabold text-xs sm:text-sm px-4 py-2 rounded-xl flex items-center gap-2 transition-all cursor-pointer border-0 shadow-2xs active:scale-95',
          onClick: () => Router.of(context).push('/cart'),
          [
            ShoppingBag(classes: 'w-4 h-4 text-[#0B132B]'),
            .text('View Cart'),
            ArrowRight(classes: 'w-4 h-4 text-[#0B132B]'),
          ],
        ),
      ],
    );
  }
}
