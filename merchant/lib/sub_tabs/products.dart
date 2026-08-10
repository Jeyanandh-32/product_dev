import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/add_edit_product_modal.dart';
import 'package:merchant/components/modals/update_stock_modal.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:merchant/components/table_pagination.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/products_signal.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:web/web.dart' as web;

enum ProductSortKey {
  name,
  sku,
  barcode,
  status,
  stock,
  lowStock,
  basePrice,
  sellingPrice,
  taxRate,
  category,
  counter,
}

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
    final activeModal = activeModalSignal.value;
    final editingProduct = editingProductSignal.value;

    return div(
      classes:
          'min-h-0 flex-1 bg-white rounded-2xl flex flex-col m-4 shadow-xs border border-border-medium overflow-hidden',
      [
        if (activeModal == ActiveModal.addProduct) const AddEditProductModal(),
        if (activeModal == ActiveModal.editProduct)
          AddEditProductModal(product: editingProduct),
        if (activeModal == ActiveModal.updateStock)
          UpdateStockModal(product: editingProduct!),
        div(
          classes:
              'flex flex-col md:items-center md:flex-row md:justify-between w-full border-b border-border-medium p-4 gap-4',
          [
            div(
              classes:
                  'flex flex-col sm:flex-row sm:items-center justify-between w-full gap-3',
              [
                div(
                  classes:
                      'flex flex-wrap items-center gap-2 text-sm font-medium',
                  [
                    span(
                      classes:
                          'flex gap-2 items-center text-sm font-medium whitespace-nowrap',
                      [
                        .text('Show'),
                        details(
                          classes: 'dropdown dropdown-bottom dropdown-center',
                          [
                            summary(
                              classes:
                                  'btn rounded-full border border-border-medium bg-white hover:bg-base-200 text-sm h-8 min-h-0 list-none',
                              [
                                .text('$entries'),
                                ChevronDown(classes: 'w-4 h-4'),
                              ],
                            ),
                            ul(
                              classes:
                                  'dropdown-content menu bg-base-100 rounded-box z-10 mt-2.5 p-2 shadow-sm border border-border-light',
                              [
                                dropdownButton(
                                  name: '10',
                                  onClick: () => _changeEntry(10),
                                ),
                                dropdownButton(
                                  name: '25',
                                  onClick: () => _changeEntry(25),
                                ),
                                dropdownButton(
                                  name: '50',
                                  onClick: () => _changeEntry(50),
                                ),
                                dropdownButton(
                                  name: '100',
                                  onClick: () => _changeEntry(100),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (productsTotalSignal.value > 0)
                          .text(
                            'Showing ${((currentPage - 1) * entries) + 1}–${(currentPage * entries).clamp(0, productsTotalSignal.value)} of ${productsTotalSignal.value}',
                          ),
                      ],
                    ),
                    _buildStatusFilter(),
                    _buildStockMonitorFilter(),
                  ],
                ),
                div(
                  classes: 'flex items-center gap-2 w-full sm:w-auto',
                  [
                    Searchbar(
                      placeholder: 'Search Products...',
                      classes: 'flex-1 sm:w-64 min-w-0',
                      onInput: (val) {
                        productSearchSignal.value = val;
                        productsPageSignal.value = 1;
                        refreshProductsSignal();
                      },
                    ),
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
          div(classes: 'flex-1 min-h-0 overflow-auto', [
            table(
              classes: 'table table-zebra table-pin-rows table-pin-cols',
              [
                tableHead(),

                tbody([
                  for (final product in sortItems<Product, ProductSortKey>(
                    items: (products.value ?? []).where((prod) {
                      if (_statusFilter != null &&
                          prod.isActive != _statusFilter) {
                        return false;
                      }
                      if (_stockMonitorFilter != null &&
                          prod.stock?.stockMonitor != _stockMonitorFilter) {
                        return false;
                      }
                      return true;
                    }).toList(),
                    sortState: _sortState,
                    getSortValue: (item, k) => switch (k) {
                      .name => item.name.toLowerCase(),
                      .sku => (item.sku ?? '').toLowerCase(),
                      .barcode => (item.barcode ?? '').toLowerCase(),
                      .status => item.isActive ? 1 : 0,
                      .stock => item.stock?.quantity ?? 0,
                      .lowStock => item.stock?.lowStockThreshold ?? 0,
                      .basePrice => item.basePrice,
                      .sellingPrice => item.sellingPrice,
                      .taxRate => item.taxRate,
                      .category => (item.category?.name ?? '').toLowerCase(),
                      .counter => (item.counter?.name ?? '').toLowerCase(),
                    },
                  ))
                    tableRow(
                      name: product.name,
                      image: product.imageUrl,
                      isActive: product.isActive,
                      stock: product.stock!.quantity,
                      lowStock: product.stock!.lowStockThreshold,
                      stockMonitor: product.stock!.stockMonitor,
                      basePrice: product.basePrice,
                      sellingPrice: product.sellingPrice,
                      category: product.category?.name ?? '-',
                      counter: product.counter?.name ?? '-',
                      sku: product.sku,
                      barcode: product.barcode,
                      taxRate: product.taxRate,
                      onEdit: () {
                        editingProductSignal.value = product;
                        activeModalSignal.value = ActiveModal.editProduct;
                      },
                      onUpdateStock: () {
                        editingProductSignal.value = product;
                        activeModalSignal.value = ActiveModal.updateStock;
                      },
                    ),
                ]),
              ],
            ),
          ]),

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

  tr tableRow({
    required String name,
    String? image,
    required bool isActive,
    required int stock,
    required int lowStock,
    required bool stockMonitor,
    required double basePrice,
    required double sellingPrice,
    required String category,
    required String counter,
    String? sku,
    String? barcode,
    required double taxRate,
    VoidCallback? onEdit,
    VoidCallback? onUpdateStock,
  }) {
    return tr([
      th([]),
      td([
        div(classes: 'flex items-center gap-4', [
          button(
            classes:
                'hover:cursor-pointer btn btn-ghost btn-xs h-8 w-8 p-0 rounded-full text-gray-500 hover:text-accent transition-colors',
            events: {
              'click': (e) {
                e.stopPropagation();
                onEdit?.call();
              },
            },
            [
              SquarePen(classes: 'w-5 h-5'),
            ],
          ),
          button(
            classes:
                'hover:cursor-pointer btn btn-ghost btn-xs h-8 w-8 p-0 rounded-full text-gray-500 hover:text-accent transition-colors',
            events: {
              'click': (e) {
                e.stopPropagation();
                onUpdateStock?.call();
              },
            },
            [
              Boxes(classes: 'w-5 h-5'),
            ],
          ),
        ]),
      ]),
      td([
        if (image != null && image.isNotEmpty)
          div(
            classes:
                'h-12 w-12 overflow-hidden rounded-2xl bg-gray-100 shrink-0',
            [
              img(
                src: image,
                alt: name,
                classes: 'block h-full w-full object-cover',
              ),
            ],
          )
        else
          .text('-'),
      ]),
      th(classes: 'whitespace-nowrap', [
        .text(name),
      ]),
      td([.text(sku ?? '-')]),
      td([.text(barcode ?? '-')]),
      td([
        div(
          classes:
              '${isActive ? 'bg-soft-green text-soft-green-content' : 'bg-soft-red text-soft-red-content'} rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
          [
            .text(isActive ? 'ACTIVE' : 'INACTIVE'),
          ],
        ),
      ]),
      td([.text('$stock')]),
      td([.text('$lowStock')]),
      td([
        div(
          classes:
              '${stockMonitor ? 'bg-soft-green text-soft-green-content' : 'bg-soft-red text-soft-red-content'} rounded-full px-3 py-1 text-center text-xs font-semibold',
          [
            .text(stockMonitor ? 'ON' : 'OFF'),
          ],
        ),
      ]),
      td([.text(basePrice.toStringAsFixed(2))]),
      td([.text(sellingPrice.toStringAsFixed(2))]),
      td([.text('${taxRate.toStringAsFixed(2)}%')]),
      td(classes: 'whitespace-nowrap', [.text(category)]),
      td(classes: 'whitespace-nowrap', [.text(counter)]),
      th([]),
    ]);
  }

  thead tableHead() {
    return thead([
      tr([
        th([]),
        td([.text('Action')]),
        td([.text('Image')]),
        SortableHeader<ProductSortKey>(
          title: 'Product Name',
          sortKey: .name,
          currentSort: _sortState,
          onSort: _onSort,
          isTh: true,
        ),
        SortableHeader<ProductSortKey>(
          title: 'SKU',
          sortKey: .sku,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<ProductSortKey>(
          title: 'Barcode',
          sortKey: .barcode,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        td([.text('Status')]),
        SortableHeader<ProductSortKey>(
          title: 'Stock',
          sortKey: .stock,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<ProductSortKey>(
          title: 'Low Stock',
          sortKey: .lowStock,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        td([.text('Stock Monitor')]),
        SortableHeader<ProductSortKey>(
          title: 'Base Price (₹)',
          sortKey: .basePrice,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<ProductSortKey>(
          title: 'Selling Price (₹)',
          sortKey: .sellingPrice,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<ProductSortKey>(
          title: 'Tax Rate (%)',
          sortKey: .taxRate,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<ProductSortKey>(
          title: 'Category',
          sortKey: .category,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<ProductSortKey>(
          title: 'Counter',
          sortKey: .counter,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        th([]),
      ]),
    ]);
  }

  Component _buildStatusFilter() {
    final label = switch (_statusFilter) {
      true => 'Status: Active',
      false => 'Status: Inactive',
      null => 'Status: All',
    };

    return details(
      classes: 'dropdown dropdown-bottom dropdown-start inline-block',
      [
        summary(
          classes:
              'btn btn-sm rounded-full border border-border-medium bg-base-100 hover:bg-base-200 text-xs px-3 font-medium flex items-center gap-1.5 shadow-2xs cursor-pointer list-none select-none',
          [
            span(classes: 'text-xs text-base-content font-medium', [
              .text(label),
            ]),
            ChevronDown(classes: 'w-3.5 h-3.5 opacity-60'),
          ],
        ),
        ul(
          classes:
              'dropdown-content menu bg-base-100 rounded-2xl z-30 mt-2 p-2 shadow-xl border border-border-medium w-36 flex flex-col gap-1',
          [
            dropdownButton(
              name: 'All Statuses',
              onClick: () {
                setState(() => _statusFilter = null);
                _closeDropdowns();
              },
            ),
            dropdownButton(
              name: 'Active',
              onClick: () {
                setState(() => _statusFilter = true);
                _closeDropdowns();
              },
            ),
            dropdownButton(
              name: 'Inactive',
              onClick: () {
                setState(() => _statusFilter = false);
                _closeDropdowns();
              },
            ),
          ],
        ),
      ],
    );
  }

  Component _buildStockMonitorFilter() {
    final label = switch (_stockMonitorFilter) {
      true => 'Stock Monitor: On',
      false => 'Stock Monitor: Off',
      null => 'Stock Monitor: All',
    };

    return details(
      classes: 'dropdown dropdown-bottom dropdown-start inline-block',
      [
        summary(
          classes:
              'btn btn-sm rounded-full border border-border-medium bg-base-100 hover:bg-base-200 text-xs px-3 font-medium flex items-center gap-1.5 shadow-2xs cursor-pointer list-none select-none',
          [
            span(classes: 'text-xs text-base-content font-medium', [
              .text(label),
            ]),
            ChevronDown(classes: 'w-3.5 h-3.5 opacity-60'),
          ],
        ),
        ul(
          classes:
              'dropdown-content menu bg-base-100 rounded-2xl z-30 mt-2 p-2 shadow-xl border border-border-medium w-40 flex flex-col gap-1',
          [
            dropdownButton(
              name: 'All Monitors',
              onClick: () {
                setState(() => _stockMonitorFilter = null);
                _closeDropdowns();
              },
            ),
            dropdownButton(
              name: 'Monitor On',
              onClick: () {
                setState(() => _stockMonitorFilter = true);
                _closeDropdowns();
              },
            ),
            dropdownButton(
              name: 'Monitor Off',
              onClick: () {
                setState(() => _stockMonitorFilter = false);
                _closeDropdowns();
              },
            ),
          ],
        ),
      ],
    );
  }

  li dropdownButton({
    required String name,
    VoidCallback? onClick,
  }) {
    return li([
      a(
        href: '#',
        classes: 'rounded-md hover:bg-neutral text-xs',
        onClick: onClick,
        [
          .text(name),
        ],
      ),
    ]);
  }
}
