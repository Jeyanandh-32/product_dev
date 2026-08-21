import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/categories/modals/add_edit_category_dialog.dart';
import 'package:terminal/components/inventory/inventory_empty_products.dart';
import 'package:terminal/pages/inventory_products_page.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/products_signal.dart';
import 'package:terminal/theme.dart';

Widget _wrapTestWidget(Widget child) {
  return MaterialApp(
    theme: TerminalTheme.light().toApproximateMaterialTheme(),
    home: FTheme(
      data: TerminalTheme.light(),
      child: FToaster(
        child: Material(type: MaterialType.transparency, child: child),
      ),
    ),
  );
}

void main() {
  final now = DateTime.now();

  setUp(() {
    initDio(Dio(BaseOptions(baseUrl: 'http://localhost:8080')));
    categoriesSignal.value = const AsyncData(<Category>[]);
    productsSignal.value = const AsyncData(<Product>[]);
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

  testWidgets(
    'InventoryProductsPage displays category guide when 0 categories exist',
    (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapTestWidget(const InventoryProductsPage()));
      await tester.pumpAndSettle();

      expect(find.byType(InventoryEmptyProducts), findsOneWidget);
      expect(find.text('Create your first category'), findsOneWidget);
      expect(find.text('Create First Category'), findsOneWidget);

      await tester.tap(find.text('Create First Category'));
      await tester.pumpAndSettle();

      expect(find.byType(AddEditCategoryDialog), findsOneWidget);
    },
  );

  testWidgets(
    'InventoryProductsPage displays standard empty state when categories exist',
    (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      categoriesSignal.value = AsyncData([
        Category(
          id: 'cat-1',
          merchantId: 'm-1',
          storeId: 'store-1',
          name: 'Beverages',
          isActive: true,
          createdAt: now,
          updatedAt: now,
        ),
      ]);

      await tester.pumpWidget(_wrapTestWidget(const InventoryProductsPage()));
      await tester.pumpAndSettle();

      expect(find.byType(InventoryEmptyProducts), findsOneWidget);
      expect(find.text('No Products in Inventory'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(InventoryEmptyProducts),
          matching: find.text('Add Product'),
        ),
        findsOneWidget,
      );
    },
  );
}
