import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/inventory_dropdown_filter.dart';
import 'package:terminal/components/inventory/inventory_filter_bar.dart';
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
  final category = Category(
    id: 'c1',
    name: 'Beverages',
    merchantId: 'm1',
    storeId: 's1',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );
  final counter = Counter(
    id: 'cnt1',
    name: 'Counter 1',
    merchantId: 'm1',
    storeId: 's1',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  testWidgets(
    'InventoryFilterBar renders filters in a horizontal Wrap and does not stretch buttons full-width',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _wrapTestWidget(
          InventoryFilterBar(
            categories: [category],
            counters: [counter],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final wrapFinder = find.byType(Wrap);
      expect(wrapFinder, findsOneWidget);

      final wrapWidget = tester.widget<Wrap>(wrapFinder);
      expect(wrapWidget.direction, Axis.horizontal);
      expect(wrapWidget.spacing, 8);
      expect(wrapWidget.runSpacing, 8);

      final filterFinders = find.byType(InventoryDropdownFilter<bool>);
      expect(filterFinders, findsNWidgets(2));

      // Each filter button should be compact (< 200px), not stretched full width (390px)
      final statusSize = tester.getSize(filterFinders.first);
      expect(statusSize.width, lessThan(200));

      final monitorSize = tester.getSize(filterFinders.at(1));
      expect(monitorSize.width, lessThan(200));
    },
  );
}
