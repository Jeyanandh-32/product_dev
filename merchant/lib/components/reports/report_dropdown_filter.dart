import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List;
import 'package:web/web.dart' as web;

/// Generic dropdown filter pill item for report filter bars.
class DropdownFilterItem<T> {
  final String label;
  final T? value;

  const DropdownFilterItem({required this.label, required this.value});
}

/// Generic dropdown pill component for filtering report data.
class ReportDropdownFilter<T> extends StatelessComponent {
  final String title;
  final T? currentValue;
  final List<DropdownFilterItem<T>> items;
  final ValueChanged<T?> onSelected;
  final bool alignEnd;

  const ReportDropdownFilter({
    super.key,
    required this.title,
    required this.currentValue,
    required this.items,
    required this.onSelected,
    this.alignEnd = false,
  });

  void _closeDropdown() {
    final activeElement = web.document.activeElement;
    if (activeElement != null) {
      final element = activeElement as web.HTMLElement;
      element.blur();
      final details = element.closest('details');
      if (details != null) {
        details.removeAttribute('open');
      }
    }
  }

  @override
  Component build(BuildContext context) {
    final selectedItem = items.firstWhere(
      (item) => item.value == currentValue,
      orElse: () => items.first,
    );

    final displayLabel = currentValue == null
        ? '$title: All'
        : '$title: ${selectedItem.label}';

    final dropdownAlign = alignEnd
        ? 'dropdown-end sm:dropdown-start'
        : 'dropdown-start';

    return details(
      classes:
          'dropdown dropdown-bottom $dropdownAlign w-full sm:w-auto inline-block',
      [
        summary(
          classes: 'btn btn-sm rounded-xl sm:rounded-full border border-border-medium bg-base-100 hover:bg-base-200 text-xs px-3 font-medium flex items-center justify-between sm:justify-start gap-1.5 shadow-2xs cursor-pointer list-none select-none w-full sm:w-auto h-9',
          [
            span(classes: 'text-xs text-base-content font-medium truncate', [
              .text(displayLabel),
            ]),
            ChevronDown(classes: 'w-3.5 h-3.5 opacity-60 shrink-0'),
          ],
        ),
        ul(
          classes: 'dropdown-content menu bg-base-100 rounded-2xl z-30 mt-2 p-2 shadow-xl border border-border-medium w-48 max-w-[calc(100vw-2rem)] flex flex-col gap-1',
          [
            for (final item in items)
              li([
                a(
                  href: '#',
                  classes:
                      'rounded-md text-xs hover:bg-neutral ${item.value == currentValue ? 'bg-neutral font-bold text-primary' : ''}',
                  onClick: () {
                    onSelected(item.value);
                    _closeDropdown();
                  },
                  [.text(item.label)],
                ),
              ]),
          ],
        ),
      ],
    );
  }
}
