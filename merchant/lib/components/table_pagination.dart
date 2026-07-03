import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';

class TablePagination extends StatelessComponent {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const TablePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  List<dynamic> _getPageNumbers() {
    final List<dynamic> pages = [];
    if (totalPages <= 5) {
      for (int i = 1; i <= totalPages; i++) {
        pages.add(i);
      }
    } else {
      pages.add(1);
      if (currentPage > 3) {
        pages.add('...');
      }
      final int start = (currentPage - 1).clamp(2, totalPages - 1);
      final int end = (currentPage + 1).clamp(2, totalPages - 1);
      int finalStart = start;
      int finalEnd = end;
      if (currentPage <= 3) {
        finalEnd = 4;
      } else if (currentPage >= totalPages - 2) {
        finalStart = totalPages - 3;
      }
      for (int i = finalStart; i <= finalEnd; i++) {
        pages.add(i);
      }
      if (currentPage < totalPages - 2) {
        pages.add('...');
      }
      pages.add(totalPages);
    }
    return pages;
  }

  @override
  Component build(BuildContext context) {
    if (totalPages <= 1) return Component.text('');

    return div(
      classes:
          'border-t border-border-medium flex justify-center items-center gap-2 font-medium text-gray-500 p-4',
      [
        button(
          classes:
              'btn border-none bg-white shadow-none hover:bg-neutral h-8 hover:text-black ${currentPage == 1 ? 'btn-disabled opacity-50' : ''}',
          onClick: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          [
            .text('Previous'),
          ],
        ),
        // Desktop Page Number Buttons (Hidden on mobile)
        div(
          classes: 'hidden sm:flex items-center gap-2',
          [
            for (final page in _getPageNumbers())
              if (page == '...')
                span(classes: 'px-2 text-gray-400 select-none', [.text('...')])
              else
                button(
                  classes:
                      'btn w-8 h-8 rounded-lg ${page == currentPage ? 'bg-accent text-white hover:bg-accent' : 'bg-neutral hover:bg-base-300'}',
                  onClick: page == currentPage ? null : () => onPageChanged(page as int),
                  [
                    .text('$page'),
                  ],
                ),
          ],
        ),
        // Mobile Page Info Indicator (Hidden on desktop)
        span(
          classes: 'block sm:hidden text-sm text-gray-500 px-2',
          [
            .text('Page $currentPage of $totalPages'),
          ],
        ),
        button(
          classes:
              'btn border-none bg-white shadow-none hover:bg-neutral h-8 hover:text-black ${currentPage == totalPages ? 'btn-disabled opacity-50' : ''}',
          onClick: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
          [
            .text('Next'),
          ],
        ),
      ],
    );
  }
}
