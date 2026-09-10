import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/reports/profit_loss_summary_cards.dart';
import 'package:merchant/components/reports/profit_loss_table_header.dart';
import 'package:merchant/components/reports/profit_loss_table_view.dart';
import 'package:merchant/components/reports/profit_loss_toolbar.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:merchant/components/table_pagination.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/profit_loss_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:web/web.dart' as web;

/// Profit & Loss report sub-tab displaying cost prices, collected totals, margins, and wastage loss.
class ProfitLoss extends SignalComponent {
  const ProfitLoss({super.key});

  @override
  SignalState<ProfitLoss> createState() => _ProfitLossState();
}

class _ProfitLossState extends SignalState<ProfitLoss> {
  String? _loadedStoreId;
  SortState<ProfitLossSortKey> _sortState =
      const SortState<ProfitLossSortKey>();

  void _onSort(ProfitLossSortKey key) {
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
    refreshProfitLossSignal();
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
    profitLossEntriesSignal.value = entry;
    profitLossPageSignal.value = 1;
    refreshProfitLossSignal();
    _closeDropdowns();
  }

  @override
  Component buildSignal(BuildContext context) {
    final store = storeSignal.value;
    if (store != null && _loadedStoreId != store.id) {
      _loadedStoreId = store.id;
      Future.microtask(() {
        refreshProfitLossSignal();
      });
    }
    final entries = profitLossEntriesSignal.value;
    final reportState = profitLossSignal.value;
    final currentPage = profitLossPageSignal.value;
    final totalPages = reportState.value?.totalPages ?? 1;
    final totalItems = reportState.value?.totalItems ?? 0;

    return div(
      classes: 'flex flex-col flex-1 min-h-0 m-4 bg-white rounded-2xl border border-border-medium shadow-xs overflow-hidden',
      [
        ProfitLossToolbar(
          onSearch: (val) {
            profitLossSearchSignal.value = val;
            profitLossPageSignal.value = 1;
            refreshProfitLossSignal();
          },
        ),

        if (showReportsStatsSignal.value)
          if (reportState.value case final reportSummary?)
            ProfitLossSummaryCards(
              totalCostPrice: reportSummary.totalCostPrice,
              totalCollectedPrice: reportSummary.totalCollectedPrice,
              totalProfit: reportSummary.totalProfit,
              totalMarginPercentage: reportSummary.totalMarginPercentage,
            ),

        if (storesSignal.value.isLoading || reportState.isLoading)
          Loading(text: 'Loading profit & loss report...', fullScreen: false)
        else if (store == null)
          CenteredMessage(message: 'Create Store to view profit & loss report.')
        else if (reportState.hasError)
          CenteredMessage(
            message: reportState.error is ApiException
                ? (reportState.error as ApiException).message
                : 'Failed to load report. Please try again.',
          )
        else if (reportState.value?.items.isEmpty ?? true)
          CenteredMessage(message: 'No Profit & Loss data found.')
        else
          ProfitLossTableView(
            items: reportState.value?.items ?? [],
            sortState: _sortState,
            onSort: _onSort,
          ),

        TablePagination(
          currentPage: currentPage,
          totalPages: totalPages,
          entries: entries,
          totalCount: totalItems,
          onEntryChanged: _changeEntry,
          onPageChanged: (page) {
            profitLossPageSignal.value = page;
            refreshProfitLossSignal();
          },
        ),
      ],
    );
  }
}
