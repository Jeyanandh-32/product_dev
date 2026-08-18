import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/cart/cart.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/theme.dart';

Widget _wrapTestWidget(Widget child) => MaterialApp(
      theme: TerminalTheme.light().toApproximateMaterialTheme(),
      home: FTheme(
        data: TerminalTheme.light(),
        child: FToaster(
          child: Material(
            type: MaterialType.transparency,
            child: child,
          ),
        ),
      ),
    );

void main() {
  final now = DateTime.now();
  final category = Category(
    id: 'cat-1',
    name: 'Drinks',
    merchantId: 'm-1',
    storeId: 'store-1',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  final testProduct = Product(
    id: 'prod-1',
    merchantId: 'm-1',
    name: 'Iced Latte',
    category: category,
    taxRate: 5.0,
    basePrice: 100.0,
    sellingPrice: 150.0,
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    initDio(Dio(BaseOptions(baseUrl: 'http://localhost:8080')));
    CartController.clear();
    authSignal.value = AsyncData(
      Terminal(
        code: 'TERM001',
        merchantId: 'm-1',
        name: 'Main Counter',
        storeId: 'store-1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
    );
  });

  testWidgets('Discount field is visible in billing summary and applies discount to grand total', (tester) async {
    CartController.addItem(testProduct);

    await tester.pumpWidget(_wrapTestWidget(const Cart()));
    await tester.pump();

    expect(find.text('Discount'), findsOneWidget);
    expect(find.text('Payment Mode'), findsOneWidget);
    expect(find.text('Grand Total'), findsOneWidget);

    final discountField = find.byType(TextField);
    expect(discountField, findsOneWidget);

    await tester.enterText(discountField, '20');
    await tester.pump();

    expect(cartSignal.value.discountTotal, 20.0);
    expect(find.text('₹137.50'), findsWidgets);
  });

  testWidgets('Selecting complimentary payment mode hides discount field', (tester) async {
    CartController.addItem(testProduct);

    await tester.pumpWidget(_wrapTestWidget(const Cart()));
    await tester.pump();

    expect(find.text('Discount'), findsOneWidget);

    await tester.tap(find.text('Free'));
    await tester.pump();

    expect(find.text('Discount'), findsNothing);
  });
}
