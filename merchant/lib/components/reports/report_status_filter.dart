import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:web/web.dart' as web;

class ReportStatusFilter extends StatelessComponent {
  final bool? status;
  final ValueChanged<bool?> onStatusChanged;
  final bool alignEnd;

  const ReportStatusFilter({
    super.key,
    required this.status,
    required this.onStatusChanged,
    this.alignEnd = false,
  });

  void _closeDropdowns() {
    final activeElement = web.document.activeElement;
    if (activeElement != null) {
      final element = activeElement as web.HTMLElement;
      element.blur();
      final details = element.closest('details');
      details?.removeAttribute('open');
    }
  }

  @override
  Component build(BuildContext context) {
    final label = switch (status) {
      true => 'Status: Active',
      false => 'Status: Inactive',
      null => 'Status: All',
    };

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
              .text(label),
            ]),
            ChevronDown(classes: 'w-3.5 h-3.5 opacity-60 shrink-0'),
          ],
        ),
        ul(
          classes: 'dropdown-content menu bg-base-100 rounded-2xl z-30 mt-2 p-2 shadow-xl border border-border-medium w-36 max-w-[calc(100vw-2rem)] flex flex-col gap-1',
          [
            _item(
              name: 'All Statuses',
              isSelected: status == null,
              onClick: () {
                onStatusChanged(null);
                _closeDropdowns();
              },
            ),
            _item(
              name: 'Active',
              isSelected: status == true,
              onClick: () {
                onStatusChanged(true);
                _closeDropdowns();
              },
            ),
            _item(
              name: 'Inactive',
              isSelected: status == false,
              onClick: () {
                onStatusChanged(false);
                _closeDropdowns();
              },
            ),
          ],
        ),
      ],
    );
  }

  li _item({
    required String name,
    required bool isSelected,
    required VoidCallback onClick,
  }) {
    return li([
      a(
        href: '#',
        classes:
            'rounded-md text-xs hover:bg-neutral ${isSelected ? 'bg-neutral font-bold text-primary' : ''}',
        onClick: onClick,
        [.text(name)],
      ),
    ]);
  }
}
