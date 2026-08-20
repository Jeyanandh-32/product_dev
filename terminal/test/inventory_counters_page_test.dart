import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/counters/inventory_counters.dart';
import 'package:terminal/pages/inventory_counters_page.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/counters_signal.dart';
import 'package:terminal/signals/inventory_counters_signal.dart';
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
  final cnt1 = Counter(id: 'cnt1', name: 'Main Counter', merchantId: 'm1', storeId: 's1', description: 'Front counter', isActive: true, createdAt: now, updatedAt: now);
  final cnt2 = Counter(id: 'cnt2', name: 'Drive Thru', merchantId: 'm1', storeId: 's1', description: 'Drive-thru window', isActive: false, createdAt: now, updatedAt: now);

  setUp(() async {
    initDio(Dio(BaseOptions(baseUrl: 'http://localhost:8080')));
    authSignal.value = AsyncData(Terminal(code: 'TERM001', merchantId: 'm1', name: 'Counter 1', storeId: 's1', isActive: true, createdAt: now, updatedAt: now));
    await countersSignal.future;
    countersSignal.value = AsyncData([cnt1, cnt2]);
    productsSignal.value = const AsyncData(<Product>[]);
    categoriesSignal.value = const AsyncData(<Category>[]);
    counterSearchSignal.value = '';
    counterStatusFilterSignal.value = null;
    counterSortStateSignal.value = const CounterSortState();
    counterEntriesSignal.value = 10;
    counterPageSignal.value = 1;
  });

  testWidgets('InventoryCountersPage renders table, toolbar, and rows on desktop without edit actions', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrapTestWidget(const InventoryCountersPage()));
    await tester.pumpAndSettle();

    expect(find.byType(InventoryCountersToolbar), findsOneWidget);
    expect(find.byType(InventoryCountersDataTable), findsOneWidget);
    expect(find.text('Add Counter'), findsNothing);
    expect(find.text('Main Counter'), findsOneWidget);
    expect(find.text('Drive Thru'), findsOneWidget);
    expect(find.byType(InventoryCountersPaginationToolbar), findsOneWidget);
  });

  testWidgets('InventoryCountersPage renders mobile cards on small screens', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrapTestWidget(const InventoryCountersPage()));
    await tester.pumpAndSettle();

    expect(find.byType(InventoryCounterCardMobile), findsNWidgets(2));
    expect(find.text('Main Counter'), findsOneWidget);
    expect(find.text('Drive Thru'), findsOneWidget);
  });
}
