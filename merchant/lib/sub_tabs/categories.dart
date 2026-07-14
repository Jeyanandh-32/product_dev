import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:jaspr_lucide/generated_icons/square_pen.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/add_edit_category_modal.dart';
import 'package:merchant/components/table_pagination.dart';
import 'package:merchant/providers/categories_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:models/models.dart';
import 'package:web/web.dart';

class Categories extends StatelessComponent {
  const Categories({super.key});

  void _changeEntry(BuildContext context, int entry) {
    context.read(entriesProvider.notifier).state = entry;
    context.read(categoriesPageProvider.notifier).state = 1;

    final activeElement = document.activeElement;
    if (activeElement != null) {
      (activeElement as HTMLElement).blur();
    }
  }

  int _getAssociatedCount(Category category) {
    return (category.name.hashCode.abs() % 900) + 100;
  }

  @override
  Component build(BuildContext context) {
    final entries = context.watch(entriesProvider);
    final categories = context.watch(categoriesProvider);
    final currentPage = context.watch(categoriesPageProvider);
    final totalPages = context.watch(categoriesTotalPagesProvider);
    final activeModal = context.watch(activeModalProvider);
    final editingCategory = context.watch(editingCategoryProvider);
    final store = context.watch(storeProvider);

    return div(
      classes:
          'flex flex-col flex-1 min-h-0 m-4 bg-white rounded-2xl border border-border-medium shadow-xs overflow-hidden',
      [
        if (activeModal == ActiveModal.addCategory)
          const AddEditCategoryModal(),
        if (activeModal == ActiveModal.editCategory)
          AddEditCategoryModal(category: editingCategory),

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
                placeholder: 'Search Categories...',
                classes: 'flex-1 sm:flex-none sm:w-64',
              ),
              AddButton(
                name: 'Add Category',
                onClick: () {
                  context.read(editingCategoryProvider.notifier).state = null;
                  context.read(activeModalProvider.notifier).state =
                      ActiveModal.addCategory;
                },
              ),
            ]),
          ],
        ),

        if (categories.isLoading)
          Loading(text: 'Loading categories...', fullScreen: false)
        else if (store == null)
          CenteredMessage(message: 'Create Store to add categories.')
        else if (categories.hasValue &&
            categories.value != null &&
            categories.value!.isEmpty)
          CenteredMessage(message: 'No Categories were added.')
        else
          div(classes: 'flex-1 min-h-0 overflow-auto', [
            table(
              classes: 'table table-zebra table-pin-rows table-pin-cols',
              [
                tableHead(),
                tbody([
                  for (final category in categories.value!)
                    tableRow(
                      name: category.name,
                      image: category.imageUrl,
                      isActive: category.isActive,
                      productsCount: _getAssociatedCount(category),
                      description: category.description ?? 'N/A',
                      onEdit: () {
                        context.read(editingCategoryProvider.notifier).state =
                            category;
                        context.read(activeModalProvider.notifier).state =
                            ActiveModal.editCategory;
                      },
                    ),
                ]),
              ],
            ),
          ]),

        TablePagination(
          currentPage: currentPage,
          totalPages: totalPages,
          onPageChanged: (page) =>
              context.read(categoriesPageProvider.notifier).state = page,
        ),
      ],
    );
  }

  thead tableHead() {
    return thead([
      tr([
        th([]),
        td([.text('Action')]),
        td([.text('Image')]),
        th([.text('Category Name')]),
        td([.text('Status')]),
        td([.text('Products Associated')]),
        td([.text('Description')]),
        th([]),
      ]),
    ]);
  }

  tr tableRow({
    required String name,
    String? image,
    required bool isActive,
    required int productsCount,
    required String description,
    VoidCallback? onEdit,
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
      td([
        div(
          classes:
              '${isActive ? 'bg-soft-green text-soft-green-content' : 'bg-soft-red text-soft-red-content'} rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
          [
            .text(isActive ? 'ACTIVE' : 'INACTIVE'),
          ],
        ),
      ]),
      td([.text('$productsCount')]),
      td([.text(description)]),
      th([]),
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
