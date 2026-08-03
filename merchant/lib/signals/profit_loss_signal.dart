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

    final fromDate =
        reportsFromDateSignal.value != null &&
            reportsFromDateSignal.value!.isNotEmpty
        ? DateTime.tryParse(reportsFromDateSignal.value!)
        : null;
    final toDate =
        reportsToDateSignal.value != null &&
            reportsToDateSignal.value!.isNotEmpty
        ? DateTime.tryParse(reportsToDateSignal.value!)
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
