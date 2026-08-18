import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/components.dart';
import 'package:terminal/pages/account_page.dart';
import 'package:terminal/pages/inventory_categories_page.dart';
import 'package:terminal/pages/inventory_counters_page.dart';
import 'package:terminal/pages/inventory_products_page.dart';
import 'package:terminal/pages/orders_page.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/orders_signal.dart';
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
    ordersSignal.value = const AsyncData([]);
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

  testWidgets('TerminalAppBar renders branding, Billing trigger, and logout button',
      (tester) async {
    await tester.pumpWidget(
      _wrapTestWidget(
        const FScaffold(
          header: TerminalAppBar(),
          child: SizedBox.shrink(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Branding'), findsOneWidget);
    expect(find.text('Billing'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);

    // Tap the dropdown trigger to open the Forui PopoverMenu
    await tester.tap(find.text('Billing'));
    await tester.pumpAndSettle();

    expect(find.text('Billing'), findsWidgets);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Inventory'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
  });

  testWidgets('Dummy pages render unified TerminalAppBar', (tester) async {
    for (final page in const [
      AccountPage(),
      OrdersPage(),
      InventoryProductsPage(),
      InventoryCategoriesPage(),
      InventoryCountersPage(),
    ]) {
      await tester.pumpWidget(_wrapTestWidget(page));
      await tester.pumpAndSettle();
      expect(find.byType(TerminalAppBar), findsOneWidget);
      expect(find.text('Branding'), findsOneWidget);
    }
  });
}
