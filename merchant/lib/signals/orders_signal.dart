import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/reports_date_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

final ordersPageSignal = signal<int>(1);
final ordersTotalSignal = signal<int>(0);
final ordersTotalPagesSignal = signal<int>(1);

final ordersSignal = asyncSignal<List<Order>>(const AsyncLoading());

Future<void> refreshOrdersSignal() async {
  final selectedStore = storeSignal.value;
  if (selectedStore == null) {
    ordersSignal.value = const AsyncData([]);
    return;
  }

  ordersSignal.value = const AsyncLoading();

  final size = entriesSignal.value;
  final page = ordersPageSignal.value;
  final fromDate = reportsFromDateSignal.value;
  final toDate = reportsToDateSignal.value;

  try {
    final result = await OrderRepository.getAll(
      storeId: selectedStore.id,
      page: page,
      size: size,
      fromDate: fromDate,
      toDate: toDate,
    );

    ordersTotalSignal.value = result.totalItems;
    ordersTotalPagesSignal.value = result.totalPages;
    ordersSignal.value = AsyncData(result.items);
  } catch (e, stack) {
    ordersSignal.value = AsyncError(e, stack);
  }
}
