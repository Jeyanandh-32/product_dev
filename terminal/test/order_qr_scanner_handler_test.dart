import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/scanner/order_qr_scanner_handler.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/theme.dart';

Widget _wrapTestWidget(Widget child) => MaterialApp(
      theme: TerminalTheme.light().toApproximateMaterialTheme(),
      builder: (context, c) => FTheme(
        data: TerminalTheme.light(),
        child: FToaster(
          child: Material(type: MaterialType.transparency, child: c),
        ),
      ),
      home: child,
    );

void main() {
  final now = DateTime.now();

  setUp(() {
    initDio(Dio(BaseOptions(baseUrl: 'http://localhost:8080')));
    authSignal.value = AsyncData(Terminal(
      code: 'TERM001', merchantId: 'm-1', name: 'Main Counter',
      storeId: 'store-1', isActive: true, createdAt: now, updatedAt: now,
    ));
  });

  testWidgets('Invalid QR code triggers error toast and resets isProcessing flag', (tester) async {
    final isProcessing = ValueNotifier<bool>(false);

    await tester.pumpWidget(
      _wrapTestWidget(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => OrderQrScannerHandler.processBarcode(
              context: context,
              rawBarcode: '',
              isProcessingNotifier: isProcessing,
            ),
            child: const Text('Scan'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Scan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Invalid Order QR'), findsOneWidget);
    expect(isProcessing.value, isFalse);
  });

  testWidgets('Not found / network failure triggers error toast and resets isProcessing flag', (tester) async {
    final isProcessing = ValueNotifier<bool>(false);

    await tester.pumpWidget(
      _wrapTestWidget(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => OrderQrScannerHandler.processBarcode(
              context: context,
              rawBarcode: 'ORD-DOES-NOT-EXIST',
              isProcessingNotifier: isProcessing,
            ),
            child: const Text('Scan'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Scan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Order Not Found'), findsOneWidget);
    expect(isProcessing.value, isFalse);
  });

  testWidgets('Resolves order by orderReference from loaded orders and opens modal', (tester) async {
    final isProcessing = ValueNotifier<bool>(false);
    final order = Order(
      id: 'ord-101', merchantId: 'm-1', storeId: 'store-1',
      orderReference: 'ORD-SCAN-REF-99', billNo: 1042,
      source: OrderSource.terminal, type: OrderType.takeaway,
      status: OrderStatus.completed, paymentStatus: PaymentStatus.completed,
      paymentMethod: PaymentMethod.cash, subtotal: 200.0,
      taxTotal: 10.0, grandTotal: 210.0, terminalCode: 'TERM001',
      items: const [], createdAt: now, updatedAt: now,
    );
    ordersSignal.value = AsyncData([order]);

    await tester.pumpWidget(
      _wrapTestWidget(
        Builder(
          builder: (rootContext) => ElevatedButton(
            onPressed: () {
              Navigator.of(rootContext).push(
                MaterialPageRoute<void>(
                  builder: (modalContext) => ElevatedButton(
                    onPressed: () => OrderQrScannerHandler.processBarcode(
                      context: modalContext,
                      rawBarcode: 'ORD-SCAN-REF-99',
                      isProcessingNotifier: isProcessing,
                    ),
                    child: const Text('Process Scan'),
                  ),
                ),
              );
            },
            child: const Text('Open Scanner'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Scanner'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Process Scan'));
    await tester.pumpAndSettle();

    expect(find.text('Bill #1042'), findsOneWidget);
    expect(find.text('ORD-SCAN-REF-99'), findsOneWidget);
    expect(isProcessing.value, isTrue);

    Navigator.of(tester.element(find.text('Bill #1042'))).pop();
    await tester.pumpAndSettle();

    expect(isProcessing.value, isFalse);
  });
}
