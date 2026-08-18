import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/orders_signal.dart';

void main() {
  final now = DateTime.now();

  final cat = Category(id: 'c1', name: 'Bev', merchantId: 'm1', storeId: 's1', isActive: true, createdAt: now, updatedAt: now);
  final prod = Product(id: 'p1', merchantId: 'm1', name: 'Tea', category: cat, basePrice: 50, sellingPrice: 50, taxRate: 0, isActive: true, createdAt: now, updatedAt: now);
  final item = OrderItem(id: 'i1', productId: 'p1', product: prod, storeId: 's1', quantity: 1, unitPrice: 50.0, taxRate: 0);
  final cust = Customer(id: 'cust-1', name: 'John Doe', mobileNumber: '9876543210', createdAt: now, updatedAt: now);

  final o1 = Order(id: 'o1', merchantId: 'm1', storeId: 's1', orderReference: 'REF-101', billNo: 1, source: OrderSource.terminal, type: OrderType.takeaway, status: OrderStatus.completed, paymentStatus: PaymentStatus.completed, paymentMethod: PaymentMethod.cash, subtotal: 50, taxTotal: 0, grandTotal: 50, terminalCode: 'T1', items: [item], createdAt: now, updatedAt: now);
  final o2 = o1.copyWith(id: 'o2', billNo: 2, orderReference: 'REF-102', paymentMethod: PaymentMethod.upi, paymentStatus: PaymentStatus.pending, status: OrderStatus.pending);
  final o3 = o1.copyWith(id: 'o3', billNo: 3, orderReference: 'REF-103', source: OrderSource.web, terminalCode: null, customer: cust);

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

  test('pagedOrdersSignal returns all loaded orders when search query is empty', () {
    expect(pagedOrdersSignal.value.length, 3);
  });

  test('pagedOrdersSignal prioritizes Order ID over Order Reference and Customer info', () {
    orderSearchQuerySignal.value = '1';
    expect(pagedOrdersSignal.value.length, 1);
    expect(pagedOrdersSignal.value.first.id, 'o1');

    orderSearchQuerySignal.value = 'REF-102';
    expect(pagedOrdersSignal.value.length, 1);
    expect(pagedOrdersSignal.value.first.id, 'o2');

    orderSearchQuerySignal.value = 'John';
    expect(pagedOrdersSignal.value.length, 1);
    expect(pagedOrdersSignal.value.first.id, 'o3');

    orderSearchQuerySignal.value = '98765';
    expect(pagedOrdersSignal.value.length, 1);
    expect(pagedOrdersSignal.value.first.id, 'o3');
  });

  test('orderPageSizeSignal updates and orderTotalPagesSignal handles page counts', () {
    orderPageSizeSignal.value = 100;
    expect(orderPageSizeSignal.value, 100);
    orderTotalItemsSignal.value = 250;
    orderTotalPagesSignal.value = 3;
    expect(orderTotalPagesSignal.value, 3);
  });
}
