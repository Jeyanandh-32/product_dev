import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Router;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:models/models.dart';

class LowStockCard extends StatelessComponent {
  final List<Product> lowStockProducts;

  const LowStockCard({
    super.key,
    required this.lowStockProducts,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'lg:col-span-6 bg-white p-4.5 rounded-2xl border border-border-medium shadow-2xs flex flex-col justify-between',
      [
        div(classes: 'flex items-center justify-between mb-3', [
          div([
            h3(classes: 'text-base font-bold text-gray-900', [
              .text('Low Stock Products'),
            ]),
            p(classes: 'text-xs text-gray-500 font-medium', [
              .text('Items requiring inventory replenishment'),
            ]),
          ]),
          button(
            type: .button,
            classes:
                'text-xs font-semibold text-primary cursor-pointer hover:underline border-0 bg-transparent p-0',
            events: {
              'click': (e) => Router.of(context).push('/inventory/products'),
            },
            [
              .text('View All Products'),
            ],
          ),
        ]),
        if (lowStockProducts.isNotEmpty)
          div(
            classes:
                'divide-y divide-gray-100 flex-1 flex flex-col justify-between',
            [
              for (final product in lowStockProducts.take(5))
                _lowStockProductRow(
                  product.name,
                  product.category?.name ?? 'General',
                  '${product.stock?.quantity ?? 0} left',
                  'Threshold: ${product.stock?.lowStockThreshold ?? 5}',
                ),
            ],
          )
        else
          div(
            classes:
                'py-10 text-center text-xs font-semibold text-emerald-600 flex-1 flex flex-col items-center justify-center space-y-1',
            [
              Check(classes: 'w-6 h-6 text-emerald-500 mb-1'),
              .text('All product stock levels are optimal.'),
            ],
          ),
      ],
    );
  }

  Component _lowStockProductRow(
    String name,
    String category,
    String quantityText,
    String thresholdText,
  ) {
    return div(classes: 'py-2.5 flex items-center justify-between', [
      div(classes: 'flex items-center gap-3', [
        div(
          classes:
              'w-8 h-8 rounded-lg bg-amber-50 text-amber-600 border border-amber-200/60 flex items-center justify-center',
          [
            TriangleAlert(classes: 'w-4 h-4'),
          ],
        ),
        div([
          p(classes: 'text-sm font-semibold text-gray-900', [.text(name)]),
          p(classes: 'text-xs text-gray-400 font-medium', [.text(category)]),
        ]),
      ]),
      div(classes: 'text-right', [
        span(
          classes:
              'px-2 py-0.5 rounded text-xs font-semibold bg-amber-50 text-amber-700 border border-amber-200/60 inline-block mb-0.5',
          [.text(quantityText)],
        ),
        p(
          classes: 'text-[11px] text-gray-400 font-medium',
          [.text(thresholdText)],
        ),
      ]),
    ]);
  }
}
