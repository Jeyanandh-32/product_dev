import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/signals/reports_date_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:signals/signals.dart';

final profitLossPageSignal = signal<int>(1);
final profitLossEntriesSignal = signal<int>(10);
final profitLossSearchSignal = signal<String>('');

final profitLossSignal = asyncSignal<ProfitLossReportResponse>(
  const AsyncLoading(),
);

/// Resets all profit & loss report signals to their initial default states.
void resetProfitLossSignal() {
  profitLossPageSignal.value = 1;
  profitLossSearchSignal.value = '';
  profitLossSignal.value = const AsyncData((
    items: [],
    currentPage: 1,
    pageSize: 10,
    totalItems: 0,
    totalPages: 1,
    totalCostPrice: 0.0,
    totalCollectedPrice: 0.0,
    totalProfit: 0.0,
    totalMarginPercentage: 0.0,
  ));
}

/// Fetches and updates profit & loss analytics signals for the active store and date filters.
Future<void> refreshProfitLossSignal() async {
  final currentStore = storeSignal.value;
  if (currentStore == null) {
    profitLossSignal.value = const AsyncData((
      items: [],
      currentPage: 1,
      pageSize: 10,
      totalItems: 0,
      totalPages: 1,
      totalCostPrice: 0.0,
      totalCollectedPrice: 0.0,
      totalProfit: 0.0,
      totalMarginPercentage: 0.0,
    ));
    return;
  }

  profitLossSignal.value = const AsyncLoading();

  try {
    final search = profitLossSearchSignal.value.trim();

    final rawFrom = reportsFromDateSignal.value;
    final fromDate = (rawFrom != null && rawFrom.isNotEmpty)
        ? DateTime.tryParse(rawFrom)
        : null;

    final rawTo = reportsToDateSignal.value;
    final toDate = (rawTo != null && rawTo.isNotEmpty)
        ? DateTime.tryParse(rawTo)
        : null;

    final result = await ReportsRepository.getProfitLoss(
      storeId: currentStore.id,
      page: profitLossPageSignal.value,
      size: profitLossEntriesSignal.value,
      fromDate: fromDate,
      toDate: toDate,
      search: search.isNotEmpty ? search : null,
    );

    profitLossSignal.value = AsyncData(result);
  } catch (e, stack) {
    profitLossSignal.value = AsyncError(e, stack);
  }
}
