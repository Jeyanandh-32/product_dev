import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/inventory_data_table.dart';
import 'package:terminal/pages/inventory_products_page.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/counters_signal.dart';
import 'package:terminal/signals/inventory_products_signal.dart';
import 'package:terminal/signals/products_signal.dart';
import 'package:terminal/theme.dart';

Widget _wrapTestWidget(Widget child) {
  return FTheme(
    data: TerminalTheme.light(false),
    child: MaterialApp(
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  final now = DateTime.now();
  final category = Category(id: 'c1', name: 'Hot Drinks', merchantId: 'm1', storeId: 's1', isActive: true, createdAt: now, updatedAt: now);
  final product = Product(
    id: 'p1',
    merchantId: 'm1',
    name: 'Espresso Single',
    category: category,
    taxRate: 5.0,
    basePrice: 60.0,
    sellingPrice: 100.0,
    sku: 'ESP-1',
    barcode: '12345678',
    isActive: true,
    stock: Stock(id: 's1', productId: 'p1', storeId: 's1', quantity: 15, lowStockThreshold: 5, stockMonitor: true, createdAt: now, updatedAt: now),
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    initDio(Dio(BaseOptions(baseUrl: 'http://localhost:8080')));
    productsSignal.value = AsyncData([product]);
    categoriesSignal.value = AsyncData([category]);
    countersSignal.value = const AsyncData(<Counter>[]);
    authSignal.value = AsyncData(Terminal(code: 'T1', merchantId: 'm1', name: 'Main', storeId: 's1', isActive: true, createdAt: now, updatedAt: now));
    inventorySearchSignal.value = '';
    inventoryPageSignal.value = 1;
  });

  testWidgets('InventoryProductsPage renders table, headers, and rows on desktop', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrapTestWidget(const InventoryProductsPage()));
    await tester.pumpAndSettle();

    expect(find.text('Add Product'), findsOneWidget);
    expect(find.byType(InventoryDataTable), findsOneWidget);
    expect(find.text('Espresso Single'), findsOneWidget);
    expect(find.text('ESP-1'), findsOneWidget);
    expect(find.text('ACTIVE'), findsOneWidget);
    expect(find.text('100.00'), findsOneWidget);
  });

  testWidgets('Tapping Add Product button opens AddEditProductDialog', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrapTestWidget(const InventoryProductsPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Product'));
    await tester.pumpAndSettle();

    expect(find.text('Add New Product'), findsOneWidget);
    expect(find.text('Product Name*'), findsOneWidget);
  });

  testWidgets('InventoryProductsPage renders mobile card layout on mobile viewport', (tester) async {
    tester.view.physicalSize = const Size(500, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrapTestWidget(const InventoryProductsPage()));
    await tester.pumpAndSettle();

    expect(find.text('Espresso Single'), findsOneWidget);
    expect(find.textContaining('ESP-1'), findsOneWidget);
    expect(find.text('ACTIVE'), findsOneWidget);
  });
}
