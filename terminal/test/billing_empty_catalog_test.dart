import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/billing/billing_catalog_view.dart';
import 'package:terminal/components/billing/billing_empty_catalog.dart';
import 'package:terminal/components/product/category_filter_list.dart';
import 'package:terminal/components/product/product_search_bar.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/navigation_signal.dart';
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

  setUp(() {
    initDio(Dio(BaseOptions(baseUrl: 'http://localhost:8080')));
    CartController.clear();
    categoriesSignal.value = const AsyncData(<Category>[]);
    productsSignal.value = const AsyncData(<Product>[]);
    activeTerminalPageSignal.value = TerminalNavPage.billing;
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

  testWidgets('BillingCatalogView renders BillingEmptyCatalog when products list is empty', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrapTestWidget(const BillingCatalogView()));
    await tester.pumpAndSettle();

    expect(find.byType(BillingEmptyCatalog), findsOneWidget);
    expect(find.text('No Products in Catalog'), findsOneWidget);
    expect(find.byType(ProductSearchBar), findsNothing);
    expect(find.byType(CategoryFilterList), findsNothing);
  });

  testWidgets('Tapping Go to Inventory navigates to inventory products page', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrapTestWidget(const BillingCatalogView()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Go to Inventory'));
    await tester.pumpAndSettle();

    expect(activeTerminalPageSignal.value, TerminalNavPage.inventoryProducts);
  });
}
