import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

final paymentsPageSignal = signal<int>(1);
final paymentsTotalSignal = signal<int>(0);
final paymentsTotalPagesSignal = signal<int>(1);

final paymentsSignal = asyncSignal<List<Payment>>(const AsyncLoading());

Future<void> refreshPaymentsSignal() async {
  final selectedStore = storeSignal.value;
  if (selectedStore == null) {
    paymentsSignal.value = const AsyncData([]);
    return;
  }

  paymentsSignal.value = const AsyncLoading();

  final size = entriesSignal.value;
  final page = paymentsPageSignal.value;

  try {
    final result = await PaymentRepository.getAll(
      storeId: selectedStore.id,
      page: page,
      size: size,
    );

    paymentsTotalSignal.value = result.totalItems;
    paymentsTotalPagesSignal.value = result.totalPages;
    paymentsSignal.value = AsyncData(result.items);
  } catch (e, stack) {
    paymentsSignal.value = AsyncError(e, stack);
  }
}
