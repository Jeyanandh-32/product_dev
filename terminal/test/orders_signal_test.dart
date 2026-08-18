import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/orders_signal.dart';

void main() {
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  final daysAgo4 = now.subtract(const Duration(days: 4));

  final cat = Category(id: 'c1', name: 'Bev', merchantId: 'm1', storeId: 's1', isActive: true, createdAt: now, updatedAt: now);
  final prod = Product(id: 'p1', merchantId: 'm1', name: 'Tea', category: cat, basePrice: 50, sellingPrice: 50, taxRate: 0, isActive: true, createdAt: now, updatedAt: now);
  final item = OrderItem(id: 'i1', productId: 'p1', product: prod, storeId: 's1', quantity: 1, unitPrice: 50.0, taxRate: 0);
  final cust = Customer(id: 'cust-1', name: 'John Doe', mobileNumber: '9876543210', createdAt: now, updatedAt: now);

  final o1 = Order(id: 'o1', merchantId: 'm1', storeId: 's1', orderReference: 'REF-101', billNo: 1, source: OrderSource.terminal, type: OrderType.takeaway, status: OrderStatus.completed, paymentStatus: PaymentStatus.completed, paymentMethod: PaymentMethod.cash, subtotal: 50, taxTotal: 0, grandTotal: 50, terminalCode: 'T1', items: [item], createdAt: now, updatedAt: now);
  final o2 = o1.copyWith(id: 'o2', billNo: 2, orderReference: 'REF-102', paymentMethod: PaymentMethod.upi, paymentStatus: PaymentStatus.pending, status: OrderStatus.pending, createdAt: yesterday);
  final o3 = o1.copyWith(id: 'o3', billNo: 3, orderReference: 'REF-103', source: OrderSource.web, terminalCode: null, customer: cust, createdAt: daysAgo4);

  setUp(() {
    initDio(Dio(BaseOptions(baseUrl: 'http://localhost:8080')));
    authSignal.value = AsyncData(Terminal(code: 'T1', merchantId: 'm1', name: 'Main', storeId: 's1', isActive: true, createdAt: now, updatedAt: now));
    ordersSignal.value = AsyncData([o1, o2, o3]);
    orderSourceTabSignal.value = OrderSourceTab.thisTerminal;
    orderDatePresetSignal.value = OrderDatePreset.today;
    customDateRangeSignal.value = null;
    orderSearchQuerySignal.value = '';
    orderPaymentMethodFilterSignal.value = null;
    orderPaymentStatusFilterSignal.value = null;
    orderStatusFilterSignal.value = null;
    selectedOrderSignal.value = null;
  });

  test('filteredOrdersSignal filters by date presets and ranges', () {
    orderDatePresetSignal.value = OrderDatePreset.today;
    expect(filteredOrdersSignal.value.length, 1);
    orderDatePresetSignal.value = OrderDatePreset.yesterday;
    expect(filteredOrdersSignal.value.first.id, 'o2');
    orderDatePresetSignal.value = OrderDatePreset.days7;
    expect(filteredOrdersSignal.value.length, 2);

    customDateRangeSignal.value = DateTimeRange(start: yesterday.subtract(const Duration(days: 1)), end: yesterday);
    expect(filteredOrdersSignal.value.length, 1);
  });

  test('filteredOrdersSignal filters by payment method, payment status, and order status', () {
    orderDatePresetSignal.value = OrderDatePreset.days7;
    orderPaymentMethodFilterSignal.value = PaymentMethod.cash;
    expect(filteredOrdersSignal.value.length, 1);
    expect(filteredOrdersSignal.value.first.id, 'o1');

    orderPaymentMethodFilterSignal.value = PaymentMethod.upi;
    expect(filteredOrdersSignal.value.first.id, 'o2');

    orderPaymentMethodFilterSignal.value = null;
    orderPaymentStatusFilterSignal.value = PaymentStatus.pending;
    expect(filteredOrdersSignal.value.first.id, 'o2');

    orderStatusFilterSignal.value = OrderStatus.completed;
    expect(filteredOrdersSignal.value, isEmpty);
  });

  test('filteredOrdersSignal prioritizes Order ID over Order Reference and Customer info', () {
    orderDatePresetSignal.value = OrderDatePreset.days7;
    orderSearchQuerySignal.value = '1';
    expect(filteredOrdersSignal.value.length, 1);
    expect(filteredOrdersSignal.value.first.id, 'o1');

    orderSearchQuerySignal.value = 'REF-102';
    expect(filteredOrdersSignal.value.length, 1);
    expect(filteredOrdersSignal.value.first.id, 'o2');

    orderSourceTabSignal.value = OrderSourceTab.online;
    orderSearchQuerySignal.value = 'John';
    expect(filteredOrdersSignal.value.length, 1);
    expect(filteredOrdersSignal.value.first.id, 'o3');

    orderSearchQuerySignal.value = '98765';
    expect(filteredOrdersSignal.value.length, 1);
    expect(filteredOrdersSignal.value.first.id, 'o3');
  });

  test('refreshOrdersSignal resets selectedOrderSignal to null', () async {
    selectedOrderSignal.value = o1;
    expect(selectedOrderSignal.value, isNotNull);
    await refreshOrdersSignal();
    expect(selectedOrderSignal.value, isNull);
  });
}
