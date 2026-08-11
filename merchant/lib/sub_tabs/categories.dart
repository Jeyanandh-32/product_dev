import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:jaspr_lucide/generated_icons/square_pen.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/add_edit_category_modal.dart';
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

enum CategorySortKey { name, status, productsCount, description }

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
    refreshProductsSignal(customSize: 1000);
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
    final products = productsSignal.value.value ?? [];
    return products.where((prod) => prod.category?.id == category.id).length;
  }

  @override
  Component buildSignal(BuildContext context) {
    final store = storeSignal.value;
    if (store != null && _loadedStoreId != store.id) {
      _loadedStoreId = store.id;
      Future.microtask(() {
        refreshCategoriesSignal();
        refreshProductsSignal(customSize: 1000);
      });
    }
    final entries = entriesSignal.value;

    final categories = categoriesSignal.value;
    final currentPage = categoriesPageSignal.value;
    final totalPages = categoriesTotalPagesSignal.value;
    final activeModal = activeModalSignal.value;
    final editingCategory = editingCategorySignal.value;

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
                              attributes: {
                                'role': 'button',
                              },
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
                        if (categoriesTotalSignal.value > 0)
                          .text(
                            'Showing ${((currentPage - 1) * entries) + 1}–${(currentPage * entries).clamp(0, categoriesTotalSignal.value)} of ${categoriesTotalSignal.value}',
                          ),
                      ],
                    ),
                    _buildStatusFilter(),
                  ],
                ),
                div(
                  classes: 'flex items-center gap-2 w-full sm:w-auto',
                  [
                    Searchbar(
                      placeholder: 'Search Categories...',
                      classes: 'flex-1 sm:w-64 min-w-0',
                      onInput: (val) {
                        categorySearchSignal.value = val;
                        categoriesPageSignal.value = 1;
                        refreshCategoriesSignal();
                      },
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
            ),
          ],
        ),

        if (storesSignal.value.isLoading || categories.isLoading)
          Loading(text: 'Loading categories...', fullScreen: false)
        else if (store == null)
          CenteredMessage(message: 'Create Store to add categories.')
        else if (categories.hasError)
          CenteredMessage(
            message: categories.error is ApiException
                ? (categories.error as ApiException).message
                : 'Failed to load categories. Please try again.',
          )
        else if (categories.hasValue && categories.value!.isEmpty)
          CenteredMessage(message: 'No Categories were added.')
        else
          div(classes: 'flex-1 min-h-0 overflow-auto', [
            table(
              classes: 'table table-zebra table-pin-rows table-pin-cols',
              [
                tableHead(),
                tbody([
                  for (final category in sortItems<Category, CategorySortKey>(
                    items: (categories.value ?? []).where((c) {
                      if (_statusFilter != null &&
                          c.isActive != _statusFilter) {
                        return false;
                      }
                      return true;
                    }).toList(),
                    sortState: _sortState,
                    getSortValue: (item, k) => switch (k) {
                      .name => item.name.toLowerCase(),
                      .status => item.isActive ? 1 : 0,
                      .productsCount => _getAssociatedCount(item),
                      .description => (item.description ?? '').toLowerCase(),
                    },
                  ))
                    tableRow(
                      name: category.name,
                      image: category.imageUrl,
                      isActive: category.isActive,
                      productsCount: _getAssociatedCount(category),
                      description: category.description ?? 'N/A',
                      onEdit: () {
                        editingCategorySignal.value = category;
                        activeModalSignal.value = ActiveModal.editCategory;
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
            categoriesPageSignal.value = page;
            refreshCategoriesSignal();
          },
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
        SortableHeader<CategorySortKey>(
          title: 'Category Name',
          sortKey: .name,
          currentSort: _sortState,
          onSort: _onSort,
          isTh: true,
        ),
        td([.text('Status')]),
        SortableHeader<CategorySortKey>(
          title: 'Products Associated',
          sortKey: .productsCount,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<CategorySortKey>(
          title: 'Description',
          sortKey: .description,
          currentSort: _sortState,
          onSort: _onSort,
        ),
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
