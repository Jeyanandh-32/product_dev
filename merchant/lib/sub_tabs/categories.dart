import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/add_edit_category_modal.dart';
import 'package:merchant/components/reports/categories_filter_bar.dart';
import 'package:merchant/components/reports/categories_table_header.dart';
import 'package:merchant/components/reports/categories_table_view.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:merchant/components/table_pagination.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/categories_signal.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/products_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:web/web.dart' as web;

/// Categories management sub-tab displaying category listing, creation, edit modals, and pagination.
class Categories extends SignalComponent {
  const Categories({super.key});

  @override
  SignalState<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends SignalState<Categories> {
  String? _loadedStoreId;
  SortState<CategorySortKey> _sortState = const SortState<CategorySortKey>();
  bool? _statusFilter;

  void _onSort(CategorySortKey key) {
    setState(() {
      _sortState = _sortState.toggle(key);
    });
  }

  @override
  void initState() {
    super.initState();
    final store = storeSignal.value;
    if (store != null) {
      _loadedStoreId = store.id;
    }
    refreshCategoriesSignal();
    fetchAllStoreProductsSignal();
  }

  void _closeDropdowns() {
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

  void _changeEntry(int entry) {
    entriesSignal.value = entry;
    categoriesPageSignal.value = 1;
    refreshCategoriesSignal();
    _closeDropdowns();
  }

  int _getAssociatedCount(Category category) {
    final prods = allStoreProductsSignal.value.value;
    if (prods == null) return 0;
    return prods.where((prod) => prod.category?.id == category.id).length;
  }

  @override
  Component buildSignal(BuildContext context) {
    final store = storeSignal.value;
    if (store != null && _loadedStoreId != store.id) {
      _loadedStoreId = store.id;
      Future.microtask(() {
        refreshCategoriesSignal();
        fetchAllStoreProductsSignal();
      });
    }
    final entries = entriesSignal.value;
    final categories = categoriesSignal.value;
    final currentPage = categoriesPageSignal.value;
    final totalPages = categoriesTotalPagesSignal.value;

    return div(
      classes:
          'flex flex-col flex-1 min-h-0 m-4 bg-white rounded-2xl border border-border-medium shadow-xs overflow-hidden',
      [
        if (activeModalSignal.value == ActiveModal.addCategory ||
            activeModalSignal.value == ActiveModal.editCategory)
          const AddEditCategoryModal(),

        CategoriesFilterBar(
          entries: entries,
          currentPage: currentPage,
          totalCount: categoriesTotalSignal.value,
          statusFilter: _statusFilter,
          onEntryChanged: _changeEntry,
          onStatusChanged: (val) => setState(() => _statusFilter = val),
          onSearch: (val) {
            categorySearchSignal.value = val;
            categoriesPageSignal.value = 1;
            refreshCategoriesSignal();
          },
        ),

        div(
          classes: 'flex-1 overflow-auto min-h-0',
          [
            categories.map(
              data: (data) {
                if (data.isEmpty) {
                  return const CenteredMessage(
                    message: 'No Categories found. Add some categories to your store.',
                  );
                }

                var filteredList = data;
                if (_statusFilter != null) {
                  filteredList = filteredList
                      .where((c) => c.isActive == _statusFilter)
                      .toList();
                }

                return CategoriesTableView(
                  categories: filteredList,
                  sortState: _sortState,
                  onSort: _onSort,
                  getAssociatedCount: _getAssociatedCount,
                );
              },
              error: (error, _) => CenteredMessage(
                message: (error is ApiException)
                    ? error.message
                    : 'Error loading categories. Something went wrong.',
              ),
              loading: () => const Loading(),
            ),
          ],
        ),

        TablePagination(
          currentPage: currentPage,
          totalPages: totalPages,
          onPageChanged: (page) {
            categoriesPageSignal.value = page;
            refreshCategoriesSignal();
          },
        ),
      ],
    );
  }
}
