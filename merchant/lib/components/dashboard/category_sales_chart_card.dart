import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class CategorySalesChartCard extends StatelessComponent {
  const CategorySalesChartCard({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'lg:col-span-6 bg-white p-4.5 rounded-2xl border border-border-medium shadow-2xs',
      [
        h3(classes: 'text-base font-bold text-gray-900 mb-0.5', [
          .text('Category Sales Breakdown'),
        ]),
        p(classes: 'text-xs text-gray-500 font-medium mb-3', [
          .text('Revenue contribution by product category'),
        ]),
        div(
          classes:
              'relative w-full h-47.5 bg-neutral/20 rounded-lg border border-border-light flex items-center justify-center p-2',
          [
            Component.element(
              tag: 'canvas',
              id: 'topCategoriesChart',
              classes: 'w-full h-full',
              children: [],
            ),
          ],
        ),
      ],
    );
  }
}
