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
import 'package:merchant/components/table_pagination.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/providers/products_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:web/web.dart';

class Products extends SignalComponent {
  const Products({super.key});

  @override
  SignalState<Products> createState() => _ProductsState();
}

class _ProductsState extends SignalState<Products> {
  @override
  void initState() {
    super.initState();
    refreshProductsSignal();
  }

  void _changeEntry(int entry) {
    entriesSignal.value = entry;
    productsPageSignal.value = 1;
    refreshProductsSignal();

    final activeElement = document.activeElement;
    if (activeElement != null) {
      (activeElement as HTMLElement).blur();
    }
  }

  @override
  Component buildSignal(BuildContext context) {
    final store = storeSignal.value;
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
            span(classes: 'flex gap-2 items-center text-sm font-medium', [
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
              ]),
              .text('entries'),
            ]),
            div(classes: 'flex justify-between gap-2 items-center w-full', [
              Searchbar(
                placeholder: 'Search Products...',
                classes: 'flex-1 sm:flex-none sm:w-64',
              ),
              AddButton(
                name: 'Add Product',
                onClick: () {
                  editingProductSignal.value = null;
                  activeModalSignal.value = ActiveModal.addProduct;
                },
              ),
            ]),
          ],
        ),

        if (products.isLoading)
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
                  for (final product in products.value!)
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
                'hover:cursor-pointer btn btn-ghost btn-xs h-8 w-8 p-0 rounded-full',
            events: {
              'click': (e) {
                e.stopPropagation();
                onEdit?.call();
              },
            },
            [
              SquarePen(classes: 'w-5 h-5 text-gray-500 hover:text-accent'),
            ],
          ),
          button(
            classes:
                'hover:cursor-pointer btn btn-ghost btn-xs h-8 w-8 p-0 rounded-full',
            events: {
              'click': (e) {
                e.stopPropagation();
                onUpdateStock?.call();
              },
            },
            [
              Boxes(classes: 'w-5 h-5 text-gray-500 hover:text-accent'),
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
        th([.text('Product Name')]),
        td([.text('SKU')]),
        td([.text('Barcode')]),
        td([.text('Status')]),
        td([.text('Stock')]),
        td([.text('Low Stock')]),
        td([.text('Stock Monitor')]),
        td([.text('Base Price (₹)')]),
        td([.text('Selling Price (₹)')]),
        td([.text('Tax Rate (%)')]),
        td([.text('Category')]),
        td([.text('Counter')]),
        th([]),
      ]),
    ]);
  }

  li dropdownButton({
    required String name,
    VoidCallback? onClick,
  }) {
    return li([
      a(
        href: '#',
        classes: 'rounded-md hover:bg-neutral',
        onClick: onClick,
        [
          .text(name),
        ],
      ),
    ]);
  }
}
