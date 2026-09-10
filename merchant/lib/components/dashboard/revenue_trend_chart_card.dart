import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Card component displaying sales and order progression trend line chart.
class RevenueTrendChartCard extends StatelessComponent {
  final int totalOrders;
  final bool isStoreActive;

  const RevenueTrendChartCard({
    super.key,
    required this.totalOrders,
    required this.isStoreActive,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'min-w-0 bg-white p-4 sm:p-4.5 rounded-2xl border border-border-medium shadow-2xs flex flex-col justify-between',
      [
        div(
          classes: 'flex flex-col sm:flex-row sm:items-center justify-between gap-2 mb-3',
          [
            div([
              h3(classes: 'text-base font-bold text-gray-900', [
                .text('Revenue & Order Trends'),
              ]),
              p(classes: 'text-xs text-gray-500 font-medium', [
                .text('Sales progression over time'),
              ]),
            ]),
            div(classes: 'flex items-center gap-3 text-xs font-medium', [
              span(classes: 'flex items-center gap-1.5 text-gray-600', [
                span(
                  classes: 'w-2.5 h-2.5 rounded-full bg-emerald-500',
                  [],
                ),
                .text('Revenue (₹)'),
              ]),
              span(classes: 'flex items-center gap-1.5 text-gray-600', [
                span(
                  classes: 'w-2.5 h-2.5 rounded-full bg-blue-500',
                  [],
                ),
                .text('Orders'),
              ]),
            ]),
          ],
        ),

        // Canvas chart container
        div(
          classes: 'relative w-full min-w-0 h-55 bg-neutral/20 rounded-lg border border-border-light flex items-center justify-center p-2',
          [
            Component.element(
              tag: 'canvas',
              id: 'salesTrendChart',
              classes: 'w-full h-full',
              children: [],
            ),
          ],
        ),

        // Bottom Chart Metrics Summary Bar (Horizontal across all screen sizes)
        div(
          classes: 'mt-3 pt-3 border-t border-gray-100 grid grid-cols-3 divide-x divide-gray-100 text-center',
          [
            div(classes: 'px-1 sm:px-2', [
              p(
                classes:
                    'text-[11px] sm:text-xs text-gray-400 font-medium truncate',
                [
                  span(classes: 'sm:hidden', [.text('Peak Hours')]),
                  span(classes: 'hidden sm:inline', [
                    .text('Peak Sales Window'),
                  ]),
                ],
              ),
              p(
                classes: 'text-xs sm:text-sm font-bold text-gray-800 mt-0.5 whitespace-nowrap',
                [
                  span(classes: 'sm:hidden', [
                    .text(totalOrders > 0 ? '12 PM - 2 PM' : '--'),
                  ]),
                  span(classes: 'hidden sm:inline', [
                    .text(totalOrders > 0 ? '12:00 PM - 2:00 PM' : '--'),
                  ]),
                ],
              ),
            ]),
            div(classes: 'px-1 sm:px-2', [
              p(
                classes:
                    'text-[11px] sm:text-xs text-gray-400 font-medium truncate',
                [
                  span(classes: 'sm:hidden', [.text('Orders')]),
                  span(classes: 'hidden sm:inline', [
                    .text('Completed Orders'),
                  ]),
                ],
              ),
              p(
                classes: 'text-xs sm:text-sm font-bold text-gray-800 mt-0.5 whitespace-nowrap',
                [
                  .text('$totalOrders Orders'),
                ],
              ),
            ]),
            div(classes: 'px-1 sm:px-2', [
              p(
                classes:
                    'text-[11px] sm:text-xs text-gray-400 font-medium truncate',
                [
                  .text('Store Status'),
                ],
              ),
              p(
                classes:
                    'text-xs sm:text-sm font-bold ${isStoreActive ? 'text-emerald-600' : 'text-gray-500'} mt-0.5 whitespace-nowrap',
                [
                  span(classes: 'sm:hidden', [
                    .text(isStoreActive ? 'Active' : 'Inactive'),
                  ]),
                  span(classes: 'hidden sm:inline', [
                    .text(isStoreActive ? 'Active Store' : 'Inactive'),
                  ]),
                ],
              ),
            ]),
          ],
        ),
      ],
    );
  }
}
