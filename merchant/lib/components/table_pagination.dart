import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/pagination/table_pagination_entries.dart';
import 'package:merchant/components/pagination/table_pagination_nav.dart';

/// Full-width docked pagination toolbar combining entries selector and tactile page controls.
class TablePagination extends StatelessComponent {
  const TablePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.entries,
    required this.totalCount,
    required this.onPageChanged,
    required this.onEntryChanged,
    this.entryOptions = const [10, 25, 50, 100],
  });

  final int currentPage;
  final int totalPages;
  final int entries;
  final int totalCount;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onEntryChanged;
  final List<int> entryOptions;

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'border-t border-border-medium px-4 py-3 bg-white flex flex-wrap justify-between items-center gap-3',
      [
        TablePaginationEntries(
          entries: entries,
          currentPage: currentPage,
          totalCount: totalCount,
          onEntryChanged: onEntryChanged,
          entryOptions: entryOptions,
        ),
        TablePaginationNav(
          currentPage: currentPage,
          totalPages: totalPages,
          onPageChanged: onPageChanged,
        ),
      ],
    );
  }
}
