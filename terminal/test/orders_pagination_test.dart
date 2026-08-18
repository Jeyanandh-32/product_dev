import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/orders/orders_entries_dropdown.dart';
import 'package:terminal/components/orders/orders_pagination.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/theme.dart';

Widget _wrapTestWidget(Widget child) => MaterialApp(
      theme: TerminalTheme.light().toApproximateMaterialTheme(),
      home: FTheme(
        data: TerminalTheme.light(),
        child: FToaster(child: Material(type: MaterialType.transparency, child: child)),
      ),
    );

void main() {
  final now = DateTime.now();

  Order makeOrder(int billNo) => Order(
        id: 'ord-$billNo',
        merchantId: 'm-1',
        storeId: 'store-1',
        orderReference: 'ORD-$billNo',
        billNo: billNo,
        source: OrderSource.terminal,
        type: OrderType.takeaway,
        status: OrderStatus.completed,
        paymentStatus: PaymentStatus.completed,
        paymentMethod: PaymentMethod.cash,
        subtotal: 100.0,
        taxTotal: 5.0,
        grandTotal: 105.0,
        items: const [],
        createdAt: now,
        updatedAt: now,
      );

  setUp(() {
    initDio(Dio(BaseOptions(baseUrl: 'http://localhost:8080')));
    final list = List.generate(120, (i) => makeOrder(i + 1));
    ordersSignal.value = AsyncData(list);
    orderTotalItemsSignal.value = 120;
    orderTotalPagesSignal.value = 3;
    orderPageSizeSignal.value = 50;
    orderCurrentPageSignal.value = 1;
  });

  testWidgets('OrdersPagination renders floating card toolbar with range on desktop', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(_wrapTestWidget(const OrdersPagination()));
    await tester.pumpAndSettle();

    expect(find.byType(OrdersEntriesDropdown), findsOneWidget);
    expect(find.text('50 / page'), findsOneWidget);
    expect(find.text('1–50'), findsOneWidget);
    expect(find.text('120 orders'), findsOneWidget);
    expect(find.text('1'), findsWidgets);
    expect(find.text('2'), findsWidgets);
    expect(find.text('3'), findsWidgets);

    await tester.tap(find.text('2'));
    await tester.pumpAndSettle();

    expect(orderCurrentPageSignal.value, 2);
  });

  testWidgets('OrdersPagination collapses cleanly on mobile', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(_wrapTestWidget(const OrdersPagination()));
    await tester.pumpAndSettle();

    expect(find.text('50'), findsOneWidget);
    expect(find.text('1–50'), findsOneWidget);
    expect(find.text('120'), findsOneWidget);
    expect(find.text('1 / 3'), findsOneWidget);
  });
}
