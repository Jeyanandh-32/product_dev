import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/reports_date_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

final paymentsPageSignal = signal<int>(1);
final paymentsTotalSignal = signal<int>(0);
final paymentsTotalPagesSignal = signal<int>(1);
final paymentsSearchSignal = signal<String>('');

final paymentsSummarySignal = signal<PaymentSummary>((
  cashCollected: 0.0,
  upiCollected: 0.0,
  freeTotal: 0.0,
  totalCollected: 0.0,
));

final paymentsSignal = asyncSignal<List<Payment>>(const AsyncLoading());

Future<void> refreshPaymentsSignal() async {
  final selectedStore = storeSignal.value;
  if (selectedStore == null) {
    paymentsSummarySignal.value = (
      cashCollected: 0.0,
      upiCollected: 0.0,
      freeTotal: 0.0,
      totalCollected: 0.0,
    );
    paymentsSignal.value = const AsyncData([]);
    return;
  }

  paymentsSignal.value = const AsyncLoading();

  final size = entriesSignal.value;
  final page = paymentsPageSignal.value;
  final fromDate = reportsFromDateSignal.value;
  final toDate = reportsToDateSignal.value;
  final paymentMethod = reportsPaymentMethodSignal.value;
  final paymentStatus = reportsPaymentStatusSignal.value;

  try {
    final result = await PaymentRepository.getAll(
      storeId: selectedStore.id,
      page: page,
      size: size,
      fromDate: fromDate,
      toDate: toDate,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
    );

    final search = paymentsSearchSignal.value.trim().toLowerCase();
    var items = result.items;
    if (search.isNotEmpty) {
      items = items.where((p) {
        return p.orderReference.toLowerCase().contains(search) ||
            p.id.toLowerCase().contains(search) ||
            p.orderId.toLowerCase().contains(search);
      }).toList();
    }

    paymentsSummarySignal.value = result.summary;
    paymentsTotalSignal.value = result.totalItems;
    paymentsTotalPagesSignal.value = result.totalPages;
    paymentsSignal.value = AsyncData(items);
  } catch (e, stack) {
    paymentsSignal.value = AsyncError(e, stack);
  }
}
