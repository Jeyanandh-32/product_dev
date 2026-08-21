import 'package:client_repositories/client_repositories.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/auth_signal.dart';

const orderEntriesOptions = [50, 100, 150, 200];
enum OrderSourceTab { thisTerminal, online }

enum OrderDatePreset {
  today('Today'),
  yesterday('Yesterday'),
  past7Days('7 Days'),
  past30Days('30 Days');

  const OrderDatePreset(this.label);
  final String label;
}

final orderSourceTabSignal = signal<OrderSourceTab>(OrderSourceTab.thisTerminal);
final orderDatePresetSignal = signal<OrderDatePreset?>(OrderDatePreset.today);
final customDateRangeSignal = signal<DateTimeRange<DateTime>?>(null);
final orderSearchQuerySignal = signal<String>('');
final orderPageSizeSignal = signal<int>(50);
final orderPaymentMethodFilterSignal = signal<PaymentMethod?>(null);
final orderPaymentStatusFilterSignal = signal<PaymentStatus?>(null);
final orderStatusFilterSignal = signal<OrderStatus?>(null);
final orderCurrentPageSignal = signal<int>(1);
final selectedOrderSignal = signal<Order?>(null);
final orderTotalItemsSignal = signal<int>(0);
final orderTotalPagesSignal = signal<int>(1);
final terminalTabCountSignal = signal<int>(0);
final onlineTabCountSignal = signal<int>(0);
final ordersSignal = asyncSignal<List<Order>>(const AsyncLoading());

Future<void>? _ordersInFlight;

/// Refreshes the orders signal with in-flight deduplication.
Future<void> refreshOrdersSignal() async {
  if (_ordersInFlight != null) return _ordersInFlight!;
  final future = _fetchOrders();
  _ordersInFlight = future;
  try {
    await future;
  } finally {
    _ordersInFlight = null;
  }
}

Future<void> _fetchOrders() async {
  selectedOrderSignal.value = null;
  ordersSignal.value = const AsyncLoading();
  final terminal = authSignal.value.value;
  final storeId = terminal?.storeId;
  if (storeId == null) {
    ordersSignal.value = const AsyncData([]);
    orderTotalItemsSignal.value = 0;
    orderTotalPagesSignal.value = 1;
    terminalTabCountSignal.value = 0;
    onlineTabCountSignal.value = 0;
    return;
  }

  final tab = orderSourceTabSignal.value;
  final source = tab == OrderSourceTab.thisTerminal ? 'terminal' : 'online';
  final terminalCode = tab == OrderSourceTab.thisTerminal ? terminal?.code : null;
  final (fromDate, toDate) = _computeDateRange(orderDatePresetSignal.value, customDateRangeSignal.value);

  try {
    final response = await OrderRepository.getAll(
      storeId: storeId,
      page: orderCurrentPageSignal.value,
      size: orderPageSizeSignal.value,
      source: source,
      terminalCode: terminalCode,
      fromDate: fromDate?.toIso8601String(),
      toDate: toDate?.toIso8601String(),
      paymentMethod: orderPaymentMethodFilterSignal.value?.name,
      paymentStatus: orderPaymentStatusFilterSignal.value?.name,
      status: orderStatusFilterSignal.value?.name,
    );
    ordersSignal.value = AsyncData(response.items);
    orderTotalItemsSignal.value = response.totalItems;
    orderTotalPagesSignal.value = response.totalPages;
    if (tab == OrderSourceTab.thisTerminal) {
      terminalTabCountSignal.value = response.totalItems;
    } else {
      onlineTabCountSignal.value = response.totalItems;
    }
  } catch (e, stack) {
    ordersSignal.value = AsyncError(e, stack);
  }
}

final pagedOrdersSignal = computed<List<Order>>(() {
  final orders = ordersSignal.value.value ?? [];
  final query = orderSearchQuerySignal.value.trim().toLowerCase();
  if (query.isEmpty) return orders;

  final billMatches = orders.where((o) => o.billNo.toString().contains(query)).toList();
  if (billMatches.isNotEmpty) return billMatches;

  return orders.where((o) {
    if (o.orderReference.toLowerCase().contains(query)) return true;
    final c = o.customer;
    return c != null && (c.name.toLowerCase().contains(query) || c.mobileNumber.contains(query));
  }).toList();
});

(DateTime?, DateTime?) _computeDateRange(OrderDatePreset? preset, DateTimeRange<DateTime>? customRange) {
  if (customRange != null) return (customRange.start, customRange.end);
  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day);
  final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

  return switch (preset) {
    OrderDatePreset.today => (startOfToday, endOfToday),
    OrderDatePreset.yesterday => (startOfToday.subtract(const Duration(days: 1)), DateTime(now.year, now.month, now.day - 1, 23, 59, 59, 999)),
    OrderDatePreset.past7Days => (startOfToday.subtract(const Duration(days: 6)), endOfToday),
    OrderDatePreset.past30Days => (startOfToday.subtract(const Duration(days: 29)), endOfToday),
    null => (startOfToday, endOfToday),
  };
}

final filteredOrdersSignal = computed<List<Order>>(() => pagedOrdersSignal.value);

void resetOrdersSignal() {
  orderSourceTabSignal.value = OrderSourceTab.thisTerminal;
  orderDatePresetSignal.value = OrderDatePreset.today;
  customDateRangeSignal.value = null;
  orderSearchQuerySignal.value = '';
  orderPageSizeSignal.value = 50;
  orderPaymentMethodFilterSignal.value = null;
  orderPaymentStatusFilterSignal.value = null;
  orderStatusFilterSignal.value = null;
  orderCurrentPageSignal.value = 1;
  selectedOrderSignal.value = null;
  orderTotalItemsSignal.value = 0;
  orderTotalPagesSignal.value = 1;
  terminalTabCountSignal.value = 0;
  onlineTabCountSignal.value = 0;
  ordersSignal.value = const AsyncLoading();
}
