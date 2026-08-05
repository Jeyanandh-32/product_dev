import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/reports_date_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

final ordersPageSignal = signal<int>(1);
final ordersTotalSignal = signal<int>(0);
final ordersTotalPagesSignal = signal<int>(1);
final ordersSearchSignal = signal<String>('');
final selectedOrderSignal = asyncSignal<Order?>(const AsyncData(null));

final ordersSummarySignal = signal<OrderSummary>((
  totalOrders: 0,
  grossSubtotal: 0.0,
  totalDiscount: 0.0,
  netRevenue: 0.0,
));

final ordersSignal = asyncSignal<List<Order>>(const AsyncLoading());

Future<void> fetchOrderDetails(String orderId) async {
  final selectedStore = storeSignal.value;
  if (selectedStore == null) return;

  activeModalSignal.value = ActiveModal.orderDetails;
  untracked(() {
    selectedOrderSignal.value = const AsyncLoading();
  });

  try {
    final order = await OrderRepository.getById(
      storeId: selectedStore.id,
      id: orderId,
    );
    selectedOrderSignal.value = AsyncData(order);
  } catch (e, stack) {
    selectedOrderSignal.value = AsyncError(e, stack);
  }
}

Future<void> refreshOrdersSignal() async {
  final selectedStore = storeSignal.value;
  if (selectedStore == null) {
    untracked(() {
      ordersSummarySignal.value = (
        totalOrders: 0,
        grossSubtotal: 0.0,
        totalDiscount: 0.0,
        netRevenue: 0.0,
      );
      ordersSignal.value = const AsyncData([]);
    });
    return;
  }

  untracked(() {
    ordersSignal.value = const AsyncLoading();
  });

  final size = entriesSignal.value;
  final page = ordersPageSignal.value;
  final fromDate = reportsFromDateSignal.value;
  final toDate = reportsToDateSignal.value;
  final paymentMethod = reportsPaymentMethodSignal.value;
  final status = reportsOrderStatusSignal.value;
  final paymentStatus = reportsPaymentStatusSignal.value;

  try {
    final result = await OrderRepository.getAll(
      storeId: selectedStore.id,
      page: page,
      size: size,
      fromDate: fromDate,
      toDate: toDate,
      paymentMethod: paymentMethod,
      status: status,
      paymentStatus: paymentStatus,
    );

    final search = ordersSearchSignal.value.trim().toLowerCase();
    var items = result.items;
    if (search.isNotEmpty) {
      items = items.where((o) {
        return '${o.billNo}'.contains(search) ||
            o.orderReference.toLowerCase().contains(search);
      }).toList();
    }

    ordersSummarySignal.value = result.summary;
    ordersTotalSignal.value = result.totalItems;
    ordersTotalPagesSignal.value = result.totalPages;
    ordersSignal.value = AsyncData(items);
  } catch (e, stack) {
    ordersSignal.value = AsyncError(e, stack);
  }
}
