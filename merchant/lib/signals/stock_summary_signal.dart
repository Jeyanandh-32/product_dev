import 'package:client_repositories/client_repositories.dart';
import 'package:date_format/date_format.dart' as df;
import 'package:merchant/signals/stores_signal.dart';
import 'package:signals/signals.dart';

final stockSummaryPageSignal = signal<int>(1);
final stockSummaryEntriesSignal = signal<int>(10);
final stockSummarySearchSignal = signal<String>('');

String getTodayDateString() => df.formatDate(DateTime.now().toLocal(), [
  df.yyyy,
  '-',
  df.mm,
  '-',
  df.dd,
]);

final stockSummaryDateSignal = signal<String>(getTodayDateString());

final stockSummarySignal = asyncSignal<StockSummaryReportResponse>(
  const AsyncLoading(),
);

void resetStockSummarySignal() {
  stockSummaryPageSignal.value = 1;
  stockSummarySearchSignal.value = '';
  stockSummaryDateSignal.value = getTodayDateString();
  stockSummarySignal.value = const AsyncData((
    items: [],
    currentPage: 1,
    pageSize: 10,
    totalItems: 0,
    totalPages: 1,
    totalOpeningStock: 0,
    totalIn: 0,
    totalOut: 0,
    totalWastage: 0,
    totalAdjustment: 0,
    totalClosingStock: 0,
  ));
}

Future<void> refreshStockSummarySignal() async {
  final currentStore = storeSignal.value;
  if (currentStore == null) {
    stockSummarySignal.value = const AsyncData((
      items: [],
      currentPage: 1,
      pageSize: 10,
      totalItems: 0,
      totalPages: 1,
      totalOpeningStock: 0,
      totalIn: 0,
      totalOut: 0,
      totalWastage: 0,
      totalAdjustment: 0,
      totalClosingStock: 0,
    ));
    return;
  }

  stockSummarySignal.value = const AsyncLoading();

  try {
    final search = stockSummarySearchSignal.value.trim();
    final dateStr = stockSummaryDateSignal.value.trim();
    final selectedDate = dateStr.isNotEmpty
        ? DateTime.tryParse(dateStr)
        : DateTime.now();

    final result = await ReportsRepository.getStockSummary(
      storeId: currentStore.id,
      page: stockSummaryPageSignal.value,
      size: stockSummaryEntriesSignal.value,
      fromDate: selectedDate,
      toDate: selectedDate,
      search: search.isNotEmpty ? search : null,
    );

    stockSummarySignal.value = AsyncData(result);
  } catch (e, stack) {
    stockSummarySignal.value = AsyncError(e, stack);
  }
}
