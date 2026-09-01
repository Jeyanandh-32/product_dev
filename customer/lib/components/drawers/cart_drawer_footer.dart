import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;

/// Footer action and itemized total breakdown for the cart slide-over drawer.
class CartDrawerFooter extends StatelessComponent {
  final double subtotal;
  final double totalTax;
  final double platformFee;
  final double grandTotal;
  final bool isSubmitting;
  final VoidCallback onCheckout;

  const CartDrawerFooter({
    super.key,
    required this.subtotal,
    required this.totalTax,
    required this.platformFee,
    required this.grandTotal,
    required this.isSubmitting,
    required this.onCheckout,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'p-6 border-t border-gray-100 bg-white flex flex-col gap-4',
      [
        div(classes: 'flex flex-col gap-1.5', [
          div(
            classes: 'flex justify-between items-center text-xs text-gray-500',
            [
              span([.text('Subtotal')]),
              span(classes: 'font-semibold text-gray-800', [
                .text('₹${subtotal.toStringAsFixed(2)}'),
              ]),
            ],
          ),
          if (platformFee > 0)
            div(
              classes:
                  'flex justify-between items-center text-xs text-gray-500',
              [
                span([.text('Platform Fee (1.99%)')]),
                span(classes: 'font-semibold text-gray-800', [
                  .text('₹${platformFee.toStringAsFixed(2)}'),
                ]),
              ],
            ),
          if (totalTax > 0)
            div(
              classes:
                  'flex justify-between items-center text-xs text-gray-500',
              [
                span([.text('Taxes')]),
                span(classes: 'font-semibold text-gray-800', [
                  .text('₹${totalTax.toStringAsFixed(2)}'),
                ]),
              ],
            ),
          div(
            classes: 'flex justify-between items-center pt-1 border-t border-dashed border-gray-200',
            [
              span(classes: 'text-sm font-bold text-gray-700', [
                .text('Total'),
              ]),
              span(classes: 'text-base font-extrabold text-gray-900', [
                .text('₹${grandTotal.toStringAsFixed(2)}'),
              ]),
            ],
          ),
        ]),
        button(
          classes: 'w-full py-4 rounded-2xl bg-emerald-50 hover:bg-emerald-600 text-emerald-700 hover:text-white border border-emerald-200/60 hover:border-emerald-600 font-bold text-base flex items-center justify-center gap-2 cursor-pointer transition-all shadow-xs active:scale-98',
          onClick: onCheckout,
          [
            if (isSubmitting)
              span(classes: 'loading loading-spinner loading-sm', [])
            else ...[
              .text('Place Order Now'),
              ArrowRight(classes: 'w-5 h-5'),
            ],
          ],
        ),
      ],
    );
  }
}
