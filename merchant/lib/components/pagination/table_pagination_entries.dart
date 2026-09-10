import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';

/// Entries selector dropdown and range indicator for table pagination.
class TablePaginationEntries extends StatelessComponent {
  const TablePaginationEntries({
    super.key,
    required this.entries,
    required this.currentPage,
    required this.totalCount,
    required this.onEntryChanged,
    this.entryOptions = const [10, 25, 50, 100],
  });

  final int entries;
  final int currentPage;
  final int totalCount;
  final ValueChanged<int> onEntryChanged;
  final List<int> entryOptions;

  @override
  Component build(BuildContext context) {
    final start = totalCount == 0 ? 0 : ((currentPage - 1) * entries) + 1;
    final end = (currentPage * entries).clamp(0, totalCount);

    return div(
      classes: 'flex items-center gap-3 text-sm font-medium text-slate-600',
      [
        div(classes: 'dropdown dropdown-top dropdown-start', [
          div(
            classes: 'btn btn-sm h-8 min-h-0 bg-slate-50 hover:bg-slate-100 text-slate-800 border border-border-medium rounded-lg px-2.5 font-bold flex items-center gap-1.5 cursor-pointer shadow-xs',
            attributes: {'tabindex': '0', 'role': 'button'},
            [
              .text('Show $entries'),
              ChevronDown(classes: 'w-3.5 h-3.5 text-slate-500'),
            ],
          ),
          ul(
            attributes: {'tabindex': '-1'},
            classes: 'dropdown-content menu bg-white rounded-xl z-20 mb-2 p-1.5 shadow-lg border border-border-light min-w-28',
            [
              for (final count in entryOptions)
                li([
                  button(
                    classes:
                        'text-sm rounded-lg font-semibold ${entries == count ? 'bg-slate-100 text-slate-900 font-bold' : 'text-slate-600'}',
                    onClick: () => onEntryChanged(count),
                    [.text('$count')],
                  ),
                ]),
            ],
          ),
        ]),
        if (totalCount > 0) ...[
          div(classes: 'h-4 w-px bg-slate-200 hidden sm:block', []),
          span(
            classes: 'text-xs sm:text-sm text-slate-500 whitespace-nowrap',
            [
              span(classes: 'font-normal', [.text('Showing ')]),
              span(classes: 'font-bold text-slate-800', [.text('$start–$end')]),
              span(classes: 'font-normal', [.text(' of ')]),
              span(classes: 'font-bold text-slate-800', [.text('$totalCount')]),
            ],
          ),
        ],
      ],
    );
  }
}
