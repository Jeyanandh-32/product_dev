import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Router, Store;
import 'package:models/models.dart';

class DashboardHeaderBar extends StatelessComponent {
  final DashboardRange selectedRange;
  final ValueChanged<DashboardRange> onRangeChanged;
  final VoidCallback onRefresh;

  const DashboardHeaderBar({
    super.key,
    required this.selectedRange,
    required this.onRangeChanged,
    required this.onRefresh,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'flex flex-col lg:flex-row lg:items-center justify-between gap-3 bg-white p-4 rounded-2xl border border-border-medium shadow-2xs',
      [
        div(classes: 'space-y-0.5', [
          div(classes: 'flex items-center gap-2', [
            span(
              classes: 'inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200/60',
              [
                span(
                  classes:
                      'w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse',
                  [],
                ),
                .text('Live Analytics'),
              ],
            ),
          ]),
          p(classes: 'text-sm text-gray-500 font-medium', [
            .text(
              'Real-time metrics, revenue performance, and inventory health overview',
            ),
          ]),
        ]),

        div(classes: 'flex items-center gap-2.5 self-start lg:self-auto', [
          div(
            classes: 'inline-flex p-1 bg-slate-100 rounded-xl border border-border-medium text-xs font-semibold',
            [
              _rangeTab('Today', .today),
              _rangeTab('7 Days', .days7),
              _rangeTab('30 Days', .days30),
              _rangeTab('This Year', .year1),
            ],
          ),
          button(
            type: .button,
            classes: 'p-2 bg-white border border-border-medium hover:bg-slate-50 rounded-xl text-slate-600 transition-all hover:scale-105 active:scale-95 shadow-2xs hover:cursor-pointer',
            attributes: {'title': 'Refresh Analytics'},
            events: {
              'click': (e) => onRefresh(),
            },
            [
              RefreshCw(classes: 'w-4 h-4'),
            ],
          ),
        ]),
      ],
    );
  }

  Component _rangeTab(String label, DashboardRange range) {
    final isSelected = selectedRange == range;
    return button(
      type: .button,
      classes:
          'px-3 py-1.5 rounded-lg transition-all hover:cursor-pointer ${isSelected ? 'bg-white text-slate-900 shadow-2xs font-bold' : 'text-slate-500 hover:text-slate-800 font-medium'}',
      events: {
        'click': (e) => onRangeChanged(range),
      },
      [.text(label)],
    );
  }
}
