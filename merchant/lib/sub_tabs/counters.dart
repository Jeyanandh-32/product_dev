import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/add_edit_counter_modal.dart';
import 'package:merchant/components/reports/counters_filter_bar.dart';
import 'package:merchant/components/reports/counters_table_header.dart';
import 'package:merchant/components/reports/counters_table_view.dart';
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

        CountersFilterBar(
          entries: entries,
          currentPage: currentPage,
          totalCount: countersTotalSignal.value,
          statusFilter: _statusFilter,
          onEntryChanged: _changeEntry,
          onStatusChanged: (val) => setState(() => _statusFilter = val),
          onSearch: (val) {
            counterSearchSignal.value = val;
            countersPageSignal.value = 1;
            refreshCountersSignal();
          },
        ),

        div(
          classes: 'flex-1 overflow-auto min-h-0',
          [
            counters.map(
              data: (data) {
                if (data.isEmpty) {
                  return const CenteredMessage(
                    message: 'No Counters found. Add some counters to your store.',
                  );
                }

                var filteredList = data;
                if (_statusFilter != null) {
                  filteredList = filteredList
                      .where((c) => c.isActive == _statusFilter)
                      .toList();
                }

                return CountersTableView(
                  counters: filteredList,
                  sortState: _sortState,
                  onSort: _onSort,
                  getAssociatedCount: _getAssociatedCount,
                );
              },
              error: (error, _) => CenteredMessage(
                message: (error is ApiException)
                    ? error.message
                    : 'Error loading counters. Something went wrong.',
              ),
              loading: () => const Loading(),
            ),
          ],
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
}
