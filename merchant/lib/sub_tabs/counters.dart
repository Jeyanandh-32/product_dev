import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/add_edit_counter_modal.dart';
import 'package:merchant/components/reports/counters_table_header.dart';
import 'package:merchant/components/reports/counters_table_view.dart';
import 'package:merchant/components/reports/report_status_filter.dart';
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

/// Counters management sub-tab displaying counter stations, creation, edit modals, and pagination.
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
    final prods = productsSignal.value.value;
    if (prods == null) return 0;
    return prods.where((prod) => prod.counter?.id == counter.id).length;
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

    return div(
      classes:
          'flex flex-col flex-1 min-h-0 m-4 bg-white rounded-2xl border border-border-medium shadow-xs overflow-hidden',
      [
        if (activeModalSignal.value == ActiveModal.addCounter ||
            activeModalSignal.value == ActiveModal.editCounter)
          const AddEditCounterModal(),

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
                    if (countersTotalSignal.value > 0)
                      .text(
                        'Showing ${((currentPage - 1) * entries) + 1}–${(currentPage * entries).clamp(0, countersTotalSignal.value)} of ${countersTotalSignal.value}',
                      ),
                  ],
                ),
                ReportStatusFilter(
                  status: _statusFilter,
                  onStatusChanged: (val) {
                    setState(() {
                      _statusFilter = val;
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
                  placeholder: 'Search Counters...',
                  classes: 'flex-1 sm:flex-none sm:w-64',
                  onInput: (val) {
                    counterSearchSignal.value = val;
                    countersPageSignal.value = 1;
                    refreshCountersSignal();
                  },
                ),
                div(
                  classes: 'flex items-center gap-2',
                  [
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
          CountersTableView(
            counters: counters.value ?? [],
            sortState: _sortState,
            onSort: _onSort,
            statusFilter: _statusFilter,
            getAssociatedCount: _getAssociatedCount,
          ),

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
