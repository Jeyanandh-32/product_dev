import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Card component displaying customer hourly transaction volume distribution chart.
class HourlyOrdersChartCard extends StatelessComponent {
  const HourlyOrdersChartCard({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'min-w-0 lg:col-span-6 bg-white p-4 sm:p-4.5 rounded-2xl border border-border-medium shadow-2xs',
      [
        h3(classes: 'text-base font-bold text-gray-900 mb-0.5', [
          .text('Hourly Traffic & Orders'),
        ]),
        p(classes: 'text-xs text-gray-500 font-medium mb-3', [
          .text('Volume of customer transactions throughout the day'),
        ]),
        div(
          classes: 'relative w-full min-w-0 h-52 sm:h-56 bg-neutral/20 rounded-lg border border-border-light flex items-center justify-center p-2',
          [
            Component.element(
              tag: 'canvas',
              id: 'hourlyOrdersChart',
              classes: 'w-full h-full',
              children: [],
            ),
          ],
        ),
      ],
    );
  }
}
