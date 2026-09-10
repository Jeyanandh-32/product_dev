import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/reports/report_status_filter.dart';
import 'package:merchant/signals/categories_signal.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:models/models.dart';

/// Filter, search bar, and add category action bar.
class CategoriesFilterBar extends StatelessComponent {
  final Store? store;
  final bool? statusFilter;
  final ValueChanged<bool?> onStatusChanged;
  final ValueChanged<String> onSearch;

  const CategoriesFilterBar({
    super.key,
    this.store,
    required this.statusFilter,
    required this.onStatusChanged,
    required this.onSearch,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'flex flex-col md:items-center md:flex-row md:justify-between w-full border-b border-border-medium p-4 gap-4',
      [
        div(
          classes: 'flex flex-wrap items-center gap-3 text-sm font-medium',
          [
            ReportStatusFilter(
              status: statusFilter,
              onStatusChanged: onStatusChanged,
            ),
          ],
        ),
        div(
          classes: 'flex justify-between gap-2 items-center w-full sm:w-auto',
          [
            Searchbar(
              placeholder: 'Search Categories...',
              classes: 'flex-1 sm:flex-none sm:w-64',
              onInput: onSearch,
            ),
            if (store != null)
              AddButton(
                name: 'Add Category',
                onClick: () {
                  editingCategorySignal.value = null;
                  activeModalSignal.value = ActiveModal.addCategory;
                },
              ),
          ],
        ),
      ],
    );
  }
}
