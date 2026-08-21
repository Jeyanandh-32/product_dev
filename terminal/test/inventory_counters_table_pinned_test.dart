import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/counters/inventory_counter_pinned_row.dart';
import 'package:terminal/components/inventory/counters/inventory_counter_scrollable_row.dart';
import 'package:terminal/components/inventory/counters/inventory_counters_data_table.dart';
import 'package:terminal/components/inventory/counters/inventory_counters_pinned_header.dart';
import 'package:terminal/components/inventory/counters/inventory_counters_scrollable_header.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final now = DateTime.now();
  final testCounters = [
    Counter(
      id: 'cnt1',
      merchantId: 'm1',
      storeId: 's1',
      name: 'Main Bar',
      description: 'Main espresso counter',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    ),
    Counter(
      id: 'cnt2',
      merchantId: 'm1',
      storeId: 's1',
      name: 'Drive Thru',
      description: 'Express lane counter',
      isActive: false,
      createdAt: now,
      updatedAt: now,
    ),
  ];

  Widget buildTestWidget({double width = 1000}) => MaterialApp(
    builder: (context, child) => FTheme(
      data: FTheme.neutral.light.desktop,
      child: child ?? const SizedBox(),
    ),
    home: Scaffold(
      body: SizedBox(
        width: width,
        height: 500,
        child: InventoryCountersDataTable(
          counters: testCounters,
          allProducts: const [],
        ),
      ),
    ),
  );

  group('InventoryCountersDataTable Pinned Column Layout Tests', () {
    testWidgets('renders pinned left pane and scrollable right pane', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(width: 1200));
      await tester.pumpAndSettle();

      expect(find.byType(InventoryCountersPinnedHeader), findsOneWidget);
      expect(find.byType(InventoryCountersScrollableHeader), findsOneWidget);
      expect(find.text('NAME'), findsOneWidget);
      expect(find.text('Main Bar'), findsOneWidget);
      expect(find.text('Drive Thru'), findsOneWidget);
      expect(find.text('Main espresso counter'), findsOneWidget);
      expect(find.byType(InventoryCounterPinnedRow), findsNWidgets(2));
      expect(find.byType(InventoryCounterScrollableRow), findsNWidgets(2));
    });

    testWidgets('horizontal scroll maintains pinned counter name', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(width: 600));
      await tester.pumpAndSettle();

      final scrollableFinder = find.byKey(
        const ValueKey('inventory_counters_scrollable_pane'),
      );
      expect(scrollableFinder, findsOneWidget);

      await tester.drag(scrollableFinder, const Offset(-200, 0));
      await tester.pumpAndSettle();

      expect(find.text('Main Bar'), findsOneWidget);
      expect(find.text('Drive Thru'), findsOneWidget);
    });
  });
}
