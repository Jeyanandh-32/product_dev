import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/components.dart';
import 'package:terminal/pages/account_page.dart';
import 'package:terminal/pages/orders_page.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/theme.dart';

Widget _wrapTestWidget(Widget child) {
  return MaterialApp(
    theme: TerminalTheme.light().toApproximateMaterialTheme(),
    home: FTheme(
      data: TerminalTheme.light(),
      child: FToaster(child: child),
    ),
  );
}

void main() {
  final now = DateTime.now();

  setUp(() {
    initDio(Dio(BaseOptions(baseUrl: 'http://localhost:8080')));
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

  testWidgets('TerminalAppBar renders branding and logout button', (tester) async {
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
    expect(find.text('Log Out'), findsOneWidget);
  });

  testWidgets('AccountPage renders terminal device information', (tester) async {
    await tester.pumpWidget(_wrapTestWidget(const AccountPage()));
    await tester.pump();

    expect(find.text('Device Account'), findsOneWidget);
    expect(find.text('Main Counter'), findsOneWidget);
    expect(find.text('Code: TERM001'), findsOneWidget);
    expect(find.text('Store ID'), findsOneWidget);
  });

  testWidgets('OrdersPage renders empty history placeholder', (tester) async {
    await tester.pumpWidget(_wrapTestWidget(const OrdersPage()));
    await tester.pump();

    expect(find.text('Order History'), findsOneWidget);
    expect(find.text('No orders placed yet'), findsOneWidget);
  });
}
