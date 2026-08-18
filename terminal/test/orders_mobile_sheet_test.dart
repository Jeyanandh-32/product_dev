import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/orders/order_details_sidebar.dart';
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

  final testOrder = Order(
    id: 'ord-101',
    merchantId: 'm-1',
    storeId: 'store-1',
    orderReference: 'ORD-101',
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
    items: const [],
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
    selectedOrderSignal.value = null;
  });

  testWidgets('Tapping order on mobile opens bottom sheet with top radius and close button dismisses it', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(_wrapTestWidget(const OrdersPage()));
    await tester.pumpAndSettle();

    expect(find.text('#1042'), findsOneWidget);
    expect(find.byType(OrderDetailsSidebar), findsNothing);

    await tester.tap(find.text('#1042'));
    await tester.pumpAndSettle();

    expect(find.byType(OrderDetailsSidebar), findsOneWidget);
    expect(selectedOrderSignal.value?.id, 'ord-101');

    await tester.tap(find.byIcon(FLucideIcons.x));
    await tester.pumpAndSettle();

    expect(find.byType(OrderDetailsSidebar), findsNothing);
    expect(selectedOrderSignal.value, isNull);
  });
}
