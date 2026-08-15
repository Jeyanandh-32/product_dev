import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class KpiMetricCard extends StatelessComponent {
  final String title;
  final String value;
  final String trend;
  final bool trendUp;
  final String iconBg;
  final Component iconWidget;
  final String subtitle;

  const KpiMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.trend,
    required this.trendUp,
    required this.iconBg,
    required this.iconWidget,
    required this.subtitle,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'bg-white p-4.5 rounded-2xl border border-border-medium shadow-2xs flex flex-col justify-between hover:border-gray-300 transition-all',
      [
        div(classes: 'flex items-start justify-between mb-2.5', [
          div(
            classes:
                'w-9 h-9 rounded-xl flex items-center justify-center border $iconBg',
            [iconWidget],
          ),
          span(
            classes:
                'inline-flex items-center px-2 py-0.5 rounded-full text-xs font-semibold ${trendUp ? 'bg-emerald-50 text-emerald-700' : 'bg-amber-50 text-amber-700'}',
            [.text(trend)],
          ),
        ]),
        div([
          p(classes: 'text-xs font-semibold text-gray-500 mb-0.5', [
            .text(title),
          ]),
          h2(classes: 'text-xl font-extrabold text-gray-900 tracking-tight', [
            .text(value),
          ]),
          p(classes: 'text-xs text-gray-400 font-medium mt-0.5', [
            .text(subtitle),
          ]),
        ]),
      ],
    );
  }
}
