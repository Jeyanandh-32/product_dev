import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/signals/navigation_signal.dart';
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

  try {
    final result = await OrderRepository.getAll(
      storeId: selectedStore.id,
      page: page,
      size: size,
    );

    ordersTotalSignal.value = result.totalItems;
    ordersTotalPagesSignal.value = result.totalPages;
    ordersSignal.value = AsyncData(result.items);
  } catch (e, stack) {
    ordersSignal.value = AsyncError(e, stack);
  }
}
