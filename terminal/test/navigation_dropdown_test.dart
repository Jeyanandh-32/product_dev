import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/components.dart';
import 'package:terminal/pages/home.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/navigation_signal.dart';
import 'package:terminal/signals/orders_signal.dart';
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
    ordersSignal.value = const AsyncData([]);
    categoriesSignal.value = const AsyncData([]);
    productsSignal.value = const AsyncData([]);
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

  testWidgets('TerminalAppBar renders branding, Billing trigger, and logout button on desktop', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

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

    await tester.tap(find.text('Billing'));
    await tester.pumpAndSettle();

    expect(find.text('Billing'), findsWidgets);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Inventory'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);

    await tester.tap(find.text('Orders'));
    await tester.pumpAndSettle();

    expect(activeTerminalPageSignal.value, TerminalNavPage.orders);
  });

  testWidgets('TerminalAppBar renders icon-only logout button on mobile', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      _wrapTestWidget(
        const FScaffold(
          header: TerminalAppBar(),
          child: SizedBox.shrink(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Log Out'), findsNothing);
    expect(find.byType(TerminalLogoutButton), findsOneWidget);

    await tester.tap(find.text('Billing'));
    await tester.pumpAndSettle();

    expect(find.text('Inventory'), findsOneWidget);
    expect(find.text('Products'), findsNothing);

    await tester.tap(find.text('Inventory'));
    await tester.pumpAndSettle();

    expect(find.text('Products'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Counters'), findsOneWidget);

    await tester.tap(find.text('Products'));
    await tester.pumpAndSettle();

    expect(activeTerminalPageSignal.value, TerminalNavPage.inventoryProducts);
  });

  testWidgets('Home shell renders TerminalAppBar and active index page', (tester) async {
    await tester.pumpWidget(_wrapTestWidget(const Home()));
    await tester.pumpAndSettle();

    expect(find.byType(TerminalAppBar), findsOneWidget);
    expect(find.text('Branding'), findsOneWidget);

    activeTerminalPageSignal.value = TerminalNavPage.orders;
    await tester.pumpAndSettle();

    expect(find.text('This Terminal'), findsOneWidget);
  });
}
