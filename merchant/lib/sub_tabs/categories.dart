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
    setState(() => _sortState = _sortState.toggle(key));
  }

  @override
  void initState() {
    super.initState();
    final store = storeSignal.value;
    if (store != null) _loadedStoreId = store.id;
    refreshCategoriesSignal();
    fetchAllStoreProductsSignal();
  }

  void _closeDropdowns() {
    final activeElement = web.document.activeElement;
    if (activeElement != null) {
      final element = activeElement as web.HTMLElement;
      element.blur();
      element.closest('details')?.removeAttribute('open');
    }
  }

  void _changeEntry(int entry) {
    entriesSignal.value = entry;
    categoriesPageSignal.value = 1;
    refreshCategoriesSignal();
    _closeDropdowns();
  }

  int _getAssociatedCount(Category category, [List<Product>? products]) {
    final prods = products ?? allStoreProductsSignal.value.value;
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

    final isModalActive =
        activeModalSignal.value == ActiveModal.addCategory ||
        activeModalSignal.value == ActiveModal.editCategory;

    final categoriesAsync = categoriesSignal.value;
    final allProductsAsync = allStoreProductsSignal.value;

    return div(
      classes: 'flex flex-col flex-1 min-h-0 m-4 bg-white rounded-2xl border border-border-medium shadow-xs overflow-hidden',
      [
        if (isModalActive)
          AddEditCategoryModal(category: editingCategorySignal.value),
        CategoriesFilterBar(
          store: store,
          statusFilter: _statusFilter,
          onStatusChanged: (val) => setState(() => _statusFilter = val),
          onSearch: (val) {
            categorySearchSignal.value = val;
            categoriesPageSignal.value = 1;
            refreshCategoriesSignal();
          },
        ),
        if (storesSignal.value.isLoading || categoriesAsync.isLoading)
          const Loading(text: 'Loading categories...', fullScreen: false)
        else if (store == null)
          const CenteredMessage(message: 'Create Store to view categories.')
        else if (categoriesAsync.hasError)
          CenteredMessage(
            message: (categoriesAsync.error is ApiException)
                ? (categoriesAsync.error as ApiException).message
                : 'Error loading categories. Something went wrong.',
          )
        else if (categoriesAsync.value?.isEmpty ?? true)
          const CenteredMessage(
            message: 'No Categories found. Add some categories to your store.',
          )
        else
          CategoriesTableView(
            categories: _statusFilter == null
                ? (categoriesAsync.value ?? [])
                : (categoriesAsync.value ?? [])
                      .where((c) => c.isActive == _statusFilter)
                      .toList(),
            sortState: _sortState,
            onSort: _onSort,
            getAssociatedCount: (c) =>
                _getAssociatedCount(c, allProductsAsync.value),
          ),
        TablePagination(
          currentPage: categoriesPageSignal.value,
          totalPages: categoriesTotalPagesSignal.value,
          entries: entriesSignal.value,
          totalCount: categoriesTotalSignal.value,
          onEntryChanged: _changeEntry,
          onPageChanged: (page) {
            categoriesPageSignal.value = page;
            refreshCategoriesSignal();
          },
        ),
      ],
    );
  }
}
