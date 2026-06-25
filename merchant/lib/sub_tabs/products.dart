import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:jaspr_lucide/generated_icons/square_pen.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/providers/products_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:web/web.dart';

class Products extends StatelessComponent {
  const Products({super.key});

  void _changeEntry(BuildContext context, int entry) {
    context.read(entriesProvider.notifier).state = entry;

    final activeElement = document.activeElement;

    if (activeElement != null) {
      (activeElement as HTMLElement).blur();
    }
  }

  @override
  Component build(BuildContext context) {
    final entries = context.watch(entriesProvider);
    final products = context.watch(productsProvider);

    return div(
      classes:
          'min-h-0 flex-1 bg-white rounded-2xl flex flex-col m-4 shadow-xs border border-border-medium',
      [
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
                      onClick: () => _changeEntry(context, 10),
                    ),
                    dropdownButton(
                      name: '25',
                      onClick: () => _changeEntry(context, 25),
                    ),
                    dropdownButton(
                      name: '50',
                      onClick: () => _changeEntry(context, 50),
                    ),
                    dropdownButton(
                      name: '100',
                      onClick: () => _changeEntry(context, 100),
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
                onClick: () {},
              ),
            ]),
          ],
        ),

        if (products.isLoading)
          Loading(text: 'Loading products...', fullScreen: false)
        else if (products.hasValue &&
            products.value != null &&
            products.value!.isEmpty)
          CenteredMessage(message: 'No Products were added.')
        else
          div(classes: 'h-full overflow-x-auto', [
            table(classes: 'table table-zebra table-pin-rows table-pin-cols', [
              tableHead(),

              tbody([
                for (final product in products.value!)
                  tableRow(
                    name: product.name,
                    image: product.imageUrl,
                    isActive: product.isActive,
                    stock: product.stock!.quantity,
                    lowStock: product.stock!.lowStockThreshold,
                    basePrice: product.basePrice,
                    sellingPrice: product.sellingPrice,
                    category: product.categoryName ?? '-',
                    counter: product.counterName ?? '-',
                    sku: product.sku,
                    barcode: product.barcode,
                    taxRate: product.taxRate,
                  ),
              ]),
            ]),
          ]),

        div(
          classes:
              'border-t border-border-medium flex justify-center items-center gap-2 font-medium text-gray-500 p-4',
          [
            button(
              classes:
                  'btn border-none bg-white shadow-none hover:bg-neutral h-8 hover:text-black',
              [
                .text('Previous'),
              ],
            ),
            button(classes: 'btn w-8 h-8 bg-accent text-white rounded-lg', [
              .text('1'),
            ]),
            button(classes: 'btn w-8 h-8 bg-neutral rounded-lg', [.text('2')]),
            button(classes: 'btn w-8 h-8 bg-neutral rounded-lg', [.text('3')]),
            button(
              classes:
                  'btn border-none bg-white shadow-none hover:bg-neutral h-8 hover:text-black',
              [
                .text('Next'),
              ],
            ),
          ],
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
    required int basePrice,
    required int sellingPrice,
    required String category,
    required String counter,
    String? sku,
    String? barcode,
    required double taxRate,
  }) {
    return tr([
      th([]),
      td([
        button(
          classes: 'hover:cursor-pointer',
          events: {
            'click': (e) {
              e.stopPropagation();
            },
          },
          [
            SquarePen(classes: 'w-5 h-5 text-gray-500'),
          ],
        ),
      ]),
      td([
        div(classes: 'h-12 w-12 overflow-hidden rounded-2xl', [
          img(
            src: image ?? '',
            alt: 'Avatar Tailwind CSS Component',
            classes: 'block h-full w-full object-cover',
          ),
        ]),
      ]),
      th(classes: 'whitespace-nowrap', [.text(name)]),
      td(classes: 'whitespace-nowrap', [.text(sku ?? '-')]),
      td([.text(barcode ?? '-')]),
      td([
        div(
          classes:
              '${isActive ? 'bg-soft-green text-soft-green-content ' : 'bg-soft-red text-soft-red-content'} rounded-full px-3 py-1 text-xs font-semibold',
          [
            .text(isActive ? 'ACTIVE' : 'INACTIVE'),
          ],
        ),
      ]),
      td([.text('$stock')]),
      td([.text('$lowStock')]),
      td([.text('$basePrice')]),
      td([.text('$sellingPrice')]),
      td([.text('${taxRate.toStringAsFixed(2)}%')]),
      td(classes: 'whitespace-nowrap',[.text(category)]),
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
        th([.text('Product')]),
        td([.text('SKU')]),
        td([.text('Barcode')]),
        td([.text('Status')]),
        td([.text('Stock')]),
        td([.text('Low Stock')]),
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
