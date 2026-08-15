import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/add_edit_product_modal.dart';
import 'package:merchant/components/modals/update_stock_modal.dart';
import 'package:merchant/components/reports/products_table_header.dart';
import 'package:merchant/components/reports/products_table_view.dart';
import 'package:merchant/components/reports/products_toolbar.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:merchant/components/table_pagination.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/products_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:web/web.dart' as web;

/// Products management sub-tab displaying product catalog, stock updates, edit modals, and pagination.
class Products extends SignalComponent {
  const Products({super.key});

  @override
  SignalState<Products> createState() => _ProductsState();
}

class _ProductsState extends SignalState<Products> {
  String? _loadedStoreId;
  SortState<ProductSortKey> _sortState = const SortState<ProductSortKey>();
  bool? _statusFilter;
  bool? _stockMonitorFilter;

  void _onSort(ProductSortKey key) {
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
    refreshProductsSignal();
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
    productsPageSignal.value = 1;
    refreshProductsSignal();
    _closeDropdowns();
  }

  @override
  Component buildSignal(BuildContext context) {
    final store = storeSignal.value;
    if (store != null && _loadedStoreId != store.id) {
      _loadedStoreId = store.id;
      Future.microtask(() {
        refreshProductsSignal();
      });
    }
    final entries = entriesSignal.value;
    final products = productsSignal.value;
    final currentPage = productsPageSignal.value;
    final totalPages = productsTotalPagesSignal.value;

    return div(
      classes:
          'flex flex-col flex-1 min-h-0 m-4 bg-white rounded-2xl border border-border-medium shadow-xs overflow-hidden',
      [
        if (activeModalSignal.value == ActiveModal.addProduct ||
            activeModalSignal.value == ActiveModal.editProduct)
          const AddEditProductModal(),
        if (activeModalSignal.value == ActiveModal.updateStock &&
            editingProductSignal.value != null)
          UpdateStockModal(product: editingProductSignal.value!),

        ProductsToolbar(
          entries: entries,
          currentPage: currentPage,
          totalCount: productsTotalSignal.value,
          store: store,
          statusFilter: _statusFilter,
          stockMonitorFilter: _stockMonitorFilter,
          onEntryChanged: _changeEntry,
          onStatusFilterChanged: (val) => setState(() => _statusFilter = val),
          onStockMonitorFilterChanged:
              (val) => setState(() => _stockMonitorFilter = val),
          onSearch: (val) {
            productSearchSignal.value = val;
            productsPageSignal.value = 1;
            refreshProductsSignal();
          },
        ),

        if (storesSignal.value.isLoading || products.isLoading)
          Loading(text: 'Loading products...', fullScreen: false)
        else if (store == null)
          CenteredMessage(message: 'Create Store to add products.')
        else if (products.hasError)
          CenteredMessage(
            message: products.error is ApiException
                ? (products.error as ApiException).message
                : 'Failed to load products. Please try again.',
          )
        else if (products.hasValue && products.value!.isEmpty)
          CenteredMessage(message: 'No Products were added.')
        else
          ProductsTableView(
            products: products.value ?? [],
            sortState: _sortState,
            onSort: _onSort,
            statusFilter: _statusFilter,
            stockMonitorFilter: _stockMonitorFilter,
          ),

        TablePagination(
          currentPage: currentPage,
          totalPages: totalPages,
          onPageChanged: (page) {
            productsPageSignal.value = page;
            refreshProductsSignal();
          },
        ),
      ],
    );
  }
}
