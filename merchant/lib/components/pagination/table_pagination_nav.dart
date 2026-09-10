import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/chevron_left.dart';
import 'package:jaspr_lucide/generated_icons/chevron_right.dart';

/// Tactile compact page navigation buttons (< 1 / 5 >) matching Terminal.
class TablePaginationNav extends StatelessComponent {
  const TablePaginationNav({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  @override
  Component build(BuildContext context) {
    if (totalPages <= 1) return Component.text('');

    return div(classes: 'flex items-center gap-1.5', [
      _navChevron(
        isLeft: true,
        isEnabled: currentPage > 1,
        onTap: () => onPageChanged(currentPage - 1),
      ),
      span(
        classes: 'text-xs sm:text-sm font-bold text-slate-800 px-2 select-none',
        [.text('$currentPage / $totalPages')],
      ),
      _navChevron(
        isLeft: false,
        isEnabled: currentPage < totalPages,
        onTap: () => onPageChanged(currentPage + 1),
      ),
    ]);
  }

  Component _navChevron({
    required bool isLeft,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return button(
      classes:
          'btn btn-sm w-8 h-8 min-h-0 p-0 rounded-lg flex items-center justify-center border border-border-medium bg-slate-50 hover:bg-slate-100 text-slate-700 shadow-xs ${isEnabled ? 'cursor-pointer' : 'btn-disabled opacity-40 cursor-not-allowed pointer-events-none'}',
      onClick: isEnabled ? onTap : null,
      [
        if (isLeft)
          ChevronLeft(classes: 'w-4 h-4')
        else
          ChevronRight(classes: 'w-4 h-4'),
      ],
    );
  }
}
