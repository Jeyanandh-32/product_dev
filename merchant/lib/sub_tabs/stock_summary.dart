import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/reports/stock_summary_cards.dart';
import 'package:merchant/components/reports/stock_summary_table_header.dart';
import 'package:merchant/components/reports/stock_summary_table_view.dart';
import 'package:merchant/components/reports/stock_summary_toolbar.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:merchant/components/table_pagination.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/stock_summary_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:web/web.dart' as web;

/// Stock summary sub-tab displaying daily movement, restock, wastage, adjustments, and closing balance.
class StockSummary extends SignalComponent {
  const StockSummary({super.key});

  @override
  SignalState<StockSummary> createState() => _StockSummaryState();
}

class _StockSummaryState extends SignalState<StockSummary> {
  String? _loadedStoreId;
  SortState<StockSummarySortKey> _sortState =
      const SortState<StockSummarySortKey>();

  void _onSort(StockSummarySortKey key) {
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
    refreshStockSummarySignal();
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
    stockSummaryPageSignal.value = 1;
    refreshStockSummarySignal();
    _closeDropdowns();
  }

  @override
  Component buildSignal(BuildContext context) {
    final store = storeSignal.value;
    if (store != null && _loadedStoreId != store.id) {
      _loadedStoreId = store.id;
      Future.microtask(() {
        refreshStockSummarySignal();
      });
    }
    final entries = entriesSignal.value;
    final reportState = stockSummarySignal.value;
    final currentPage = stockSummaryPageSignal.value;
    final totalPages = reportState.value?.totalPages ?? 1;
    final totalItems = reportState.value?.totalItems ?? 0;

    return div(
      classes: 'flex flex-col flex-1 min-h-0 m-4 bg-white rounded-2xl border border-border-medium shadow-xs overflow-hidden',
      [
        StockSummaryToolbar(
          entries: entries,
          currentPage: currentPage,
          totalItems: totalItems,
          onEntryChanged: _changeEntry,
          onSearch: (val) {
            stockSummarySearchSignal.value = val;
            stockSummaryPageSignal.value = 1;
            refreshStockSummarySignal();
          },
        ),

        if (showReportsStatsSignal.value)
          if (reportState.value case final reportSummary?)
            StockSummaryCards(
              totalIn: reportSummary.totalIn,
              totalOut: reportSummary.totalOut,
              totalWastage: reportSummary.totalWastage,
              totalAdjustment: reportSummary.totalAdjustment,
            ),

        if (storesSignal.value.isLoading || reportState.isLoading)
          Loading(text: 'Loading stock summary...', fullScreen: false)
        else if (store == null)
          CenteredMessage(message: 'Create Store to view stock summary.')
        else if (reportState.hasError)
          CenteredMessage(
            message: reportState.error is ApiException
                ? (reportState.error as ApiException).message
                : 'Failed to load stock summary. Please try again.',
          )
        else if (reportState.value?.items.isEmpty ?? true)
          CenteredMessage(message: 'No Stock Summary data found.')
        else
          StockSummaryTableView(
            items: reportState.value?.items ?? [],
            sortState: _sortState,
            onSort: _onSort,
          ),

        TablePagination(
          currentPage: currentPage,
          totalPages: totalPages,
          onPageChanged: (page) {
            stockSummaryPageSignal.value = page;
            refreshStockSummarySignal();
          },
        ),
      ],
    );
  }
}
