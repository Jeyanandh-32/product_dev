import 'package:client_repositories/client_repositories.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/auth_signal.dart';

/// Tab selection for filtering orders on the terminal device.
enum OrderSourceTab { thisTerminal, online }

/// Date range presets for filtering POS orders.
enum OrderDatePreset {
  today('Today'),
  yesterday('Yesterday'),
  days7('7 Days'),
  days30('30 Days');

  const OrderDatePreset(this.label);
  final String label;
}

/// Available options for entries per page starting from 50.
const List<int> orderEntriesOptions = [50, 100, 150, 200];

/// Number of orders displayed per page (defaults to 50).
final orderPageSizeSignal = signal<int>(50);
final orderSourceTabSignal = signal<OrderSourceTab>(OrderSourceTab.thisTerminal);
final orderSearchQuerySignal = signal<String>('');
final orderDatePresetSignal = signal<OrderDatePreset?>(OrderDatePreset.today);
final customDateRangeSignal = signal<DateTimeRange?>(null);
final orderPaymentMethodFilterSignal = signal<PaymentMethod?>(null);
final orderPaymentStatusFilterSignal = signal<PaymentStatus?>(null);
final orderStatusFilterSignal = signal<OrderStatus?>(null);
final orderCurrentPageSignal = signal<int>(1);
final selectedOrderSignal = signal<Order?>(null);

/// Master async signal fetching orders for the store.
final ordersSignal = asyncSignal<List<Order>>(const AsyncLoading());

/// Refreshes the orders signal from the server and resets the selected order state.
Future<void> refreshOrdersSignal() async {
  selectedOrderSignal.value = null;
  final terminal = authSignal.value.value;
  final storeId = terminal?.storeId;
  if (storeId == null) {
    ordersSignal.value = const AsyncData([]);
    return;
  }

  try {
    final response = await OrderRepository.getAll(storeId: storeId, size: 200);
    ordersSignal.value = AsyncData(response.items);
  } catch (e, stack) {
    ordersSignal.value = AsyncError(e, stack);
  }
}

/// Computed signal filtering orders: prioritizes Bill ID, then checks Reference, Customer Name, and Mobile.
final filteredOrdersSignal = computed<List<Order>>(() {
  final orders = ordersSignal.value.value ?? [];
  final currentTab = orderSourceTabSignal.value;
  final datePreset = orderDatePresetSignal.value;
  final customRange = customDateRangeSignal.value;
  final query = orderSearchQuerySignal.value.trim().toLowerCase();
  final payMethod = orderPaymentMethodFilterSignal.value;
  final payStatus = orderPaymentStatusFilterSignal.value;
  final orderStatus = orderStatusFilterSignal.value;
  final terminal = authSignal.value.value;
  final terminalCode = terminal?.code;
  final now = DateTime.now();

  final base = orders.where((order) {
    if (currentTab == OrderSourceTab.thisTerminal) {
      final isThisTerminal = order.terminalCode != null
          ? (terminalCode != null && order.terminalCode == terminalCode)
          : order.source == OrderSource.terminal;
      if (!isThisTerminal) return false;
    } else {
      final isOnline = order.source == OrderSource.web || order.source == OrderSource.mobileApp;
      if (!isOnline) return false;
    }

    if (customRange != null) {
      final start = DateTime(customRange.start.year, customRange.start.month, customRange.start.day);
      final end = DateTime(customRange.end.year, customRange.end.month, customRange.end.day, 23, 59, 59);
      if (order.createdAt.isBefore(start) || order.createdAt.isAfter(end)) return false;
    } else if (datePreset != null && !_matchesDatePreset(order.createdAt, datePreset, now)) {
      return false;
    }

    if (payMethod != null && order.paymentMethod != payMethod) return false;
    if (payStatus != null && order.paymentStatus != payStatus) return false;
    if (orderStatus != null && order.status != orderStatus) return false;

    return true;
  }).toList();

  if (query.isEmpty) return base;

  final billMatches = base.where((o) => o.billNo.toString().contains(query)).toList();
  if (billMatches.isNotEmpty) return billMatches;

  return base.where((o) {
    if (o.orderReference.toLowerCase().contains(query)) return true;
    final c = o.customer;
    if (c != null) {
      if (c.name.toLowerCase().contains(query)) return true;
      if (c.mobileNumber.contains(query)) return true;
    }
    return false;
  }).toList();
});

/// Total number of pages based on filtered orders count and [orderPageSizeSignal].
final orderTotalPagesSignal = computed<int>(() {
  final total = filteredOrdersSignal.value.length;
  final size = orderPageSizeSignal.value;
  if (total == 0) return 1;
  return (total / size).ceil();
});

/// Orders sliced for the current active page.
final pagedOrdersSignal = computed<List<Order>>(() {
  final list = filteredOrdersSignal.value;
  final page = orderCurrentPageSignal.value;
  final size = orderPageSizeSignal.value;
  final startIndex = (page - 1) * size;
  if (startIndex >= list.length) return [];
  final endIndex = (startIndex + size).clamp(0, list.length);
  return list.sublist(startIndex, endIndex);
});

bool _matchesDatePreset(DateTime dt, OrderDatePreset preset, DateTime now) {
  final todayStart = DateTime(now.year, now.month, now.day);
  final orderDate = DateTime(dt.year, dt.month, dt.day);

  return switch (preset) {
    OrderDatePreset.today => orderDate.isAtSameMomentAs(todayStart),
    OrderDatePreset.yesterday =>
      orderDate.isAtSameMomentAs(todayStart.subtract(const Duration(days: 1))),
    OrderDatePreset.days7 => dt.isAfter(now.subtract(const Duration(days: 7))),
    OrderDatePreset.days30 => dt.isAfter(now.subtract(const Duration(days: 30))),
  };
}
