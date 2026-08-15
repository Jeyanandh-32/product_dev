import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Router;
import 'package:jaspr_router/jaspr_router.dart';

class TopProductsCard extends StatelessComponent {
  final List<
    ({
      String rank,
      String name,
      String category,
      String units,
      String revenue,
    })
  >
  topProducts;

  const TopProductsCard({
    super.key,
    required this.topProducts,
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
              .text('Top Selling Products'),
            ]),
            p(classes: 'text-xs text-gray-500 font-medium', [
              .text('Best performing items by volume'),
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
        if (topProducts.isNotEmpty)
          div(
            classes:
                'divide-y divide-gray-100 flex-1 flex flex-col justify-start',
            [
              for (final item in topProducts.take(5))
                _topProductRow(
                  item.rank,
                  item.name,
                  item.category,
                  item.units,
                  item.revenue,
                ),
            ],
          )
        else
          div(
            classes:
                'py-10 text-center text-xs font-semibold text-gray-400 flex-1 flex flex-col items-center justify-center space-y-1',
            [
              Package(classes: 'w-6 h-6 text-gray-300 mb-1'),
              .text('No top products data found for this store.'),
            ],
          ),
      ],
    );
  }

  Component _topProductRow(
    String rank,
    String name,
    String category,
    String units,
    String revenue,
  ) {
    return div(classes: 'py-2.5 flex items-center justify-between', [
      div(classes: 'flex items-center gap-3', [
        span(
          classes:
              'w-8 h-8 rounded-lg bg-gray-100 text-gray-700 text-xs font-bold flex items-center justify-center shrink-0 border border-gray-200/60',
          [.text(rank)],
        ),
        div([
          p(classes: 'text-sm font-semibold text-gray-900', [.text(name)]),
          p(classes: 'text-xs text-gray-400 font-medium', [.text(category)]),
        ]),
      ]),
      div(classes: 'text-right', [
        p(classes: 'text-sm font-bold text-gray-900', [.text(revenue)]),
        p(classes: 'text-xs text-emerald-600 font-medium', [.text(units)]),
      ]),
    ]);
  }
}
