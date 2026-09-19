import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/orders/orders_qr_scan_button.dart';
import 'package:terminal/pages/orders_page.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/theme.dart';

void main() {
  final now = DateTime.now();

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
    ordersSignal.value = const AsyncData([]);
  });

  Widget buildTestWidget({double size = 44}) {
    return FTheme(
      data: TerminalTheme.light(false),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: OrdersQrScanButton(size: size),
      ),
    );
  }

  testWidgets('OrdersQrScanButton renders scan icon', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.byType(OrdersQrScanButton), findsOneWidget);
    expect(find.byIcon(FLucideIcons.scanQrCode), findsOneWidget);
  });

  testWidgets(
    'OrdersPage renders OrdersQrScanButton across mobile and desktop viewports',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(MaterialApp(
        theme: TerminalTheme.light().toApproximateMaterialTheme(),
        home: FTheme(
          data: TerminalTheme.light(),
          child: const Material(child: OrdersPage()),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(OrdersQrScanButton), findsOneWidget);

      tester.view.physicalSize = const Size(1280, 800);
      await tester.pumpAndSettle();
      expect(find.byType(OrdersQrScanButton), findsOneWidget);
    },
  );
}
