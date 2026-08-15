import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/add_edit_product_modal.dart';
import 'package:merchant/components/modals/update_stock_modal.dart';
import 'package:merchant/components/reports/products_filter_bar.dart';
import 'package:merchant/components/reports/products_table_header.dart';
import 'package:merchant/components/reports/products_table_view.dart';
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

        div(
          classes:
              'flex flex-col md:items-center md:flex-row md:justify-between w-full border-b border-border-medium p-4 gap-4',
          [
            div(
              classes: 'flex flex-wrap items-center gap-3 text-sm font-medium',
              [
                span(
                  classes:
                      'flex gap-2 items-center text-sm font-medium whitespace-nowrap',
                  [
                    .text('Show'),
                    div(classes: 'dropdown dropdown-bottom dropdown-center', [
                      div(
                        classes:
                            'btn rounded-full border border-border-medium bg-white hover:bg-base-200 text-sm h-8 min-h-0',
                        attributes: {
                          'tabindex': '0',
                          'role': 'button',
                        },
                        [
                          .text('$entries'),
                          ChevronDown(classes: 'w-4 h-4'),
                        ],
                      ),
                      ul(
                        attributes: {'tabindex': '-1'},
                        classes:
                            'dropdown-content menu bg-base-100 rounded-box z-10 mt-2.5 p-2 shadow-sm border border-border-light',
                        [
                          dropdownButton(
                            name: '10',
                            isSelected: entries == 10,
                            onClick: () => _changeEntry(10),
                          ),
                          dropdownButton(
                            name: '25',
                            isSelected: entries == 25,
                            onClick: () => _changeEntry(25),
                          ),
                          dropdownButton(
                            name: '50',
                            isSelected: entries == 50,
                            onClick: () => _changeEntry(50),
                          ),
                          dropdownButton(
                            name: '100',
                            isSelected: entries == 100,
                            onClick: () => _changeEntry(100),
                          ),
                        ],
                      ),
                    ]),
                    if (productsTotalSignal.value > 0)
                      .text(
                        'Showing ${((currentPage - 1) * entries) + 1}–${(currentPage * entries).clamp(0, productsTotalSignal.value)} of ${productsTotalSignal.value}',
                      ),
                  ],
                ),
                ProductsFilterBar(
                  statusFilter: _statusFilter,
                  stockMonitorFilter: _stockMonitorFilter,
                  onStatusFilterChanged: (val) {
                    setState(() {
                      _statusFilter = val;
                    });
                  },
                  onStockMonitorFilterChanged: (val) {
                    setState(() {
                      _stockMonitorFilter = val;
                    });
                  },
                ),
              ],
            ),
            div(
              classes:
                  'flex justify-between gap-2 items-center w-full sm:w-auto',
              [
                Searchbar(
                  placeholder: 'Search Products...',
                  classes: 'flex-1 sm:flex-none sm:w-64',
                  onInput: (val) {
                    productSearchSignal.value = val;
                    productsPageSignal.value = 1;
                    refreshProductsSignal();
                  },
                ),
                div(
                  classes: 'flex items-center gap-2',
                  [
                    if (store != null)
                      AddButton(
                        name: 'Add Product',
                        onClick: () {
                          editingProductSignal.value = null;
                          activeModalSignal.value = ActiveModal.addProduct;
                        },
                      ),
                  ],
                ),
              ],
            ),
          ],
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

  li dropdownButton({
    required String name,
    required bool isSelected,
    VoidCallback? onClick,
  }) {
    return li([
      a(
        href: '#',
        classes:
            'rounded-md text-xs hover:bg-neutral ${isSelected ? 'bg-neutral font-bold text-primary' : ''}',
        onClick: onClick,
        [
          .text(name),
        ],
      ),
    ]);
  }
}
