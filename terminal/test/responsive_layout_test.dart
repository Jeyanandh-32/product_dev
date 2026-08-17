import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/components.dart';
import 'package:terminal/pages/cart_page.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/products_signal.dart';
import 'package:terminal/theme.dart';

Widget _wrapTestWidget(Widget child) {
  return MaterialApp(
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
}

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
    selectedCategorySignal.value = category;
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
    productsSignal.value = AsyncData([testProduct]);
  });

  testWidgets('MobileCartFloatingButton renders and CartPage displays full order breakdown',
      (tester) async {
    CartController.addItem(testProduct);

    await tester.pumpWidget(
      _wrapTestWidget(
        const Stack(
          children: [
            MobileCartFloatingButton(),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('View Order'), findsOneWidget);
    expect(find.text('1 item'), findsOneWidget);

    await tester.pumpWidget(_wrapTestWidget(const CartPage()));
    await tester.pump();

    expect(find.text('Order Items'), findsOneWidget);
    expect(find.text('Iced Latte'), findsOneWidget);
    expect(find.text('Total No of Items'), findsOneWidget);
    expect(find.text('Place Order (CASH)'), findsOneWidget);
  });

  testWidgets('Cart component renders cleanly in standalone/drawer mode',
      (tester) async {
    CartController.addItem(testProduct);

    await tester.pumpWidget(_wrapTestWidget(const Cart()));
    await tester.pump();

    expect(find.text('Clear All'), findsOneWidget);
    expect(find.text('Iced Latte'), findsOneWidget);
    expect(find.text('Order Summary'), findsOneWidget);
  });
}
