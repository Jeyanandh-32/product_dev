import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Card component displaying order payment status distribution doughnut chart (Paid vs Free).
class PaymentStatusChartCard extends StatelessComponent {
  final int totalOrdersCount;
  final int paidPercent;
  final int paidCount;
  final int freePercent;
  final int freeCount;

  const PaymentStatusChartCard({
    super.key,
    required this.totalOrdersCount,
    required this.paidPercent,
    required this.paidCount,
    required this.freePercent,
    required this.freeCount,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'min-w-0 bg-white p-4 sm:p-4.5 rounded-2xl border border-border-medium shadow-2xs flex flex-col justify-between',
      [
        div([
          h3(classes: 'text-base font-bold text-gray-900', [
            .text('Order Payment Status'),
          ]),
          p(classes: 'text-xs text-gray-500 font-medium', [
            .text('Paid vs Free & Complimentary'),
          ]),
        ]),

        // Canvas chart container with centered overlay
        div(
          classes: 'relative w-full min-w-0 h-48 my-1 bg-neutral/20 rounded-lg border border-border-light flex items-center justify-center p-3',
          [
            Component.element(
              tag: 'canvas',
              id: 'paidFreeChart',
              classes: 'w-full h-full',
              children: [],
            ),
            div(
              classes: 'absolute inset-0 flex flex-col items-center justify-center pointer-events-none text-center p-2',
              [
                span(
                  id: 'paidFreeCenterLabel',
                  classes: 'text-[10px] uppercase tracking-wider font-extrabold text-black mb-0.5 max-w-27.5 truncate',
                  [.text('ORDERS')],
                ),
                span(
                  id: 'paidFreeCenterValue',
                  classes: 'text-sm sm:text-base font-black text-black',
                  [
                    .text('$totalOrdersCount Total'),
                  ],
                ),
              ],
            ),
          ],
        ),

        // Legend List
        div(classes: 'space-y-2 text-xs font-medium', [
          _paymentLegendRow(
            'Paid Orders',
            '$paidPercent%',
            '$paidCount Orders',
            'bg-purple-600',
          ),
          _paymentLegendRow(
            'Free / Complimentary',
            '$freePercent%',
            '$freeCount Orders',
            'bg-amber-500',
          ),
        ]),
      ],
    );
  }

  Component _paymentLegendRow(
    String label,
    String percent,
    String total,
    String badgeBg,
  ) {
    return div(
      classes: 'flex items-center justify-between p-2 rounded-lg bg-gray-50/60',
      [
        div(classes: 'flex items-center gap-2', [
          span(classes: 'w-2.5 h-2.5 rounded-full $badgeBg', []),
          span(classes: 'text-gray-700 font-medium text-xs', [.text(label)]),
        ]),
        div(classes: 'flex items-center gap-2 text-xs', [
          span(classes: 'text-gray-400 font-medium', [.text(percent)]),
          span(classes: 'font-bold text-gray-900', [.text(total)]),
        ]),
      ],
    );
  }
}
