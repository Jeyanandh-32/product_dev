import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/pages/orders_page.dart';
import 'package:terminal/signals/auth_signal.dart';
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
  final category = Category(
    id: 'cat-1',
    name: 'Beverages',
    merchantId: 'm-1',
    storeId: 'store-1',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  final testProduct = Product(
    id: 'prod-1',
    merchantId: 'm-1',
    name: 'Espresso',
    category: category,
    taxRate: 5.0,
    basePrice: 100.0,
    sellingPrice: 100.0,
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  final orderItem = OrderItem(
    id: 'item-1',
    productId: 'prod-1',
    product: testProduct,
    storeId: 'store-1',
    quantity: 2,
    unitPrice: 100.0,
    taxRate: 5.0,
  );

  final testOrder = Order(
    id: 'ord-1',
    merchantId: 'm-1',
    storeId: 'store-1',
    orderReference: 'ORD-9901',
    billNo: 1042,
    source: OrderSource.terminal,
    type: OrderType.takeaway,
    status: OrderStatus.completed,
    paymentStatus: PaymentStatus.completed,
    paymentMethod: PaymentMethod.cash,
    subtotal: 200.0,
    taxTotal: 10.0,
    grandTotal: 210.0,
    terminalCode: 'TERM001',
    items: [orderItem],
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    initDio(Dio(BaseOptions(baseUrl: 'http://localhost:8080')));
    authSignal.value = AsyncData(Terminal(
      code: 'TERM001',
      merchantId: 'm-1',
      name: 'Main Counter',
      storeId: 'store-1',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    ));
    ordersSignal.value = AsyncData([testOrder]);
    orderSourceTabSignal.value = OrderSourceTab.thisTerminal;
    orderDatePresetSignal.value = OrderDatePreset.today;
    selectedOrderSignal.value = testOrder;
  });

  testWidgets('OrdersPage renders pills, cards, and sidebar', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(_wrapTestWidget(const OrdersPage()));
    await tester.pumpAndSettle();

    expect(find.text('This Terminal'), findsOneWidget);
    expect(find.text('#1042'), findsWidgets);
    expect(find.text('₹210.00'), findsWidgets);
    expect(find.text('Espresso'), findsOneWidget);
    expect(find.text('Reprint Receipt'), findsOneWidget);
  });

  testWidgets('Pending order shows Print & Complete Order and completes on tap', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final pendingOrder = testOrder.copyWith(status: OrderStatus.pending);
    ordersSignal.value = AsyncData([pendingOrder]);
    selectedOrderSignal.value = pendingOrder;

    await tester.pumpWidget(_wrapTestWidget(const OrdersPage()));
    await tester.pumpAndSettle();

    expect(find.text('Print & Complete Order'), findsOneWidget);
    await tester.tap(find.text('Print & Complete Order'));
    await tester.pumpAndSettle();

    expect(selectedOrderSignal.value?.status, OrderStatus.completed);
    expect(find.text('Reprint Receipt'), findsOneWidget);
  });

  testWidgets('Cancelled or unpaid order hides print button', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    selectedOrderSignal.value = testOrder.copyWith(status: OrderStatus.cancelled);
    await tester.pumpWidget(_wrapTestWidget(const OrdersPage()));
    await tester.pumpAndSettle();
    expect(find.text('Reprint Receipt'), findsNothing);

    selectedOrderSignal.value = testOrder.copyWith(paymentStatus: PaymentStatus.pending);
    await tester.pumpWidget(_wrapTestWidget(const OrdersPage()));
    await tester.pumpAndSettle();
    expect(find.text('Reprint Receipt'), findsNothing);
  });
}
