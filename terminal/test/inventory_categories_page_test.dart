import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/categories/inventory_categories.dart';
import 'package:terminal/pages/inventory_categories_page.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/counters_signal.dart';
import 'package:terminal/signals/inventory_categories_signal.dart';
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
  final cat1 = Category(id: 'c1', name: 'Coffee', merchantId: 'm1', storeId: 's1', description: 'Freshly brewed', isActive: true, createdAt: now, updatedAt: now);
  final cat2 = Category(id: 'c2', name: 'Snacks', merchantId: 'm1', storeId: 's1', description: 'Cookies & chips', isActive: false, createdAt: now, updatedAt: now);

  setUp(() async {
    initDio(Dio(BaseOptions(baseUrl: 'http://localhost:8080')));
    authSignal.value = AsyncData(Terminal(code: 'TERM001', merchantId: 'm1', name: 'Counter 1', storeId: 's1', isActive: true, createdAt: now, updatedAt: now));
    await categoriesSignal.future;
    categoriesSignal.value = AsyncData([cat1, cat2]);
    productsSignal.value = const AsyncData(<Product>[]);
    countersSignal.value = const AsyncData(<Counter>[]);
    categorySearchSignal.value = '';
    categoryStatusFilterSignal.value = null;
    categorySortStateSignal.value = const CategorySortState();
    categoryEntriesSignal.value = 10;
    categoryPageSignal.value = 1;
  });

  testWidgets('InventoryCategoriesPage renders table, toolbar, and rows on desktop', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrapTestWidget(const InventoryCategoriesPage()));
    await tester.pumpAndSettle();

    expect(find.byType(InventoryCategoriesToolbar), findsOneWidget);
    expect(find.byType(InventoryCategoriesDataTable), findsOneWidget);
    expect(find.text('Add Category'), findsOneWidget);
    expect(find.text('Coffee'), findsOneWidget);
    expect(find.text('Snacks'), findsOneWidget);
    expect(find.byType(InventoryCategoriesPaginationToolbar), findsOneWidget);
  });

  testWidgets('InventoryCategoriesPage renders mobile cards on small screens', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrapTestWidget(const InventoryCategoriesPage()));
    await tester.pumpAndSettle();

    expect(find.byType(InventoryCategoryCardMobile), findsNWidgets(2));
    expect(find.text('Coffee'), findsOneWidget);
    expect(find.text('Snacks'), findsOneWidget);
  });

  testWidgets('InventoryCategoriesPage displays empty state when no categories exist', (tester) async {
    categoriesSignal.value = const AsyncData(<Category>[]);

    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrapTestWidget(const InventoryCategoriesPage()));
    await tester.pumpAndSettle();

    expect(find.byType(InventoryEmptyCategories), findsOneWidget);
    expect(find.text('No Categories in Inventory'), findsOneWidget);
  });

  testWidgets('Tapping Add Category opens AddEditCategoryDialog', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrapTestWidget(const InventoryCategoriesPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Category'));
    await tester.pumpAndSettle();

    expect(find.byType(AddEditCategoryDialog), findsOneWidget);
    expect(find.text('Add New Category'), findsOneWidget);
  });
}
