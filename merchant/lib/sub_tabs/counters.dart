import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:jaspr_lucide/generated_icons/square_pen.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/add_edit_counter_modal.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:merchant/components/table_pagination.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/counters_signal.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/products_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:web/web.dart' as web;

enum CounterSortKey { name, status, productsCount, description }

class Counters extends SignalComponent {
  const Counters({super.key});

  @override
  SignalState<Counters> createState() => _CountersState();
}

class _CountersState extends SignalState<Counters> {
  String? _loadedStoreId;
  SortState<CounterSortKey> _sortState = const SortState<CounterSortKey>();
  bool? _statusFilter;

  void _onSort(CounterSortKey key) {
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
    refreshCountersSignal();
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
    countersPageSignal.value = 1;
    refreshCountersSignal();
    _closeDropdowns();
  }

  int _getAssociatedCount(Counter counter) {
    final products = productsSignal.value.value ?? [];
    return products.where((prod) => prod.counter?.id == counter.id).length;
  }

  @override
  Component buildSignal(BuildContext context) {
    final store = storeSignal.value;
    if (store != null && _loadedStoreId != store.id) {
      _loadedStoreId = store.id;
      Future.microtask(() {
        refreshCountersSignal();
        refreshProductsSignal(customSize: 1000);
      });
    }
    final entries = entriesSignal.value;

    final counters = countersSignal.value;
    final currentPage = countersPageSignal.value;
    final totalPages = countersTotalPagesSignal.value;
    final activeModal = activeModalSignal.value;
    final editingCounter = editingCounterSignal.value;

    return div(
      classes:
          'flex flex-col flex-1 min-h-0 m-4 bg-white rounded-2xl border border-border-medium shadow-xs overflow-hidden',
      [
        if (activeModal == ActiveModal.addCounter) const AddEditCounterModal(),
        if (activeModal == ActiveModal.editCounter)
          AddEditCounterModal(counter: editingCounter),

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
                          ],
                        ),
                        if (countersTotalSignal.value > 0)
                          .text(
                            'Showing ${((currentPage - 1) * entries) + 1}–${(currentPage * entries).clamp(0, countersTotalSignal.value)} of ${countersTotalSignal.value}',
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
                      placeholder: 'Search Counters...',
                      classes: 'flex-1 sm:w-64 min-w-0',
                      onInput: (val) {
                        counterSearchSignal.value = val;
                        countersPageSignal.value = 1;
                        refreshCountersSignal();
                      },
                    ),
                    if (store != null)
                      AddButton(
                        name: 'Add Counter',
                        onClick: () {
                          editingCounterSignal.value = null;
                          activeModalSignal.value = ActiveModal.addCounter;
                        },
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),

        if (storesSignal.value.isLoading || counters.isLoading)
          Loading(text: 'Loading counters...', fullScreen: false)
        else if (store == null)
          CenteredMessage(message: 'Create Store to add counters.')
        else if (counters.hasError)
          CenteredMessage(
            message: counters.error is ApiException
                ? (counters.error as ApiException).message
                : 'Failed to load counters. Please try again.',
          )
        else if (counters.hasValue && counters.value!.isEmpty)
          CenteredMessage(message: 'No Counters were added.')
        else
          div(classes: 'flex-1 min-h-0 overflow-auto', [
            table(
              classes: 'table table-zebra table-pin-rows table-pin-cols',
              [
                tableHead(),
                tbody([
                  for (final counter in sortItems<Counter, CounterSortKey>(
                    items: (counters.value ?? []).where((c) {
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
                      name: counter.name,
                      image: counter.imageUrl,
                      isActive: counter.isActive,
                      productsCount: _getAssociatedCount(counter),
                      description: counter.description ?? 'N/A',
                      onEdit: () {
                        editingCounterSignal.value = counter;
                        activeModalSignal.value = ActiveModal.editCounter;
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
            countersPageSignal.value = page;
            refreshCountersSignal();
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
        SortableHeader<CounterSortKey>(
          title: 'Counter Name',
          sortKey: .name,
          currentSort: _sortState,
          onSort: _onSort,
          isTh: true,
        ),
        td([.text('Status')]),
        SortableHeader<CounterSortKey>(
          title: 'Products Associated',
          sortKey: .productsCount,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<CounterSortKey>(
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
              isSelected: _statusFilter == null,
              onClick: () {
                setState(() => _statusFilter = null);
                _closeDropdowns();
              },
            ),
            dropdownButton(
              name: 'Active',
              isSelected: _statusFilter == true,
              onClick: () {
                setState(() => _statusFilter = true);
                _closeDropdowns();
              },
            ),
            dropdownButton(
              name: 'Inactive',
              isSelected: _statusFilter == false,
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
    bool isSelected = false,
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
