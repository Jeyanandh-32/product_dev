import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/categories/inventory_categories_data_table.dart';
import 'package:terminal/components/inventory/categories/inventory_categories_pinned_header.dart';
import 'package:terminal/components/inventory/categories/inventory_categories_scrollable_header.dart';
import 'package:terminal/components/inventory/categories/inventory_category_pinned_row.dart';
import 'package:terminal/components/inventory/categories/inventory_category_scrollable_row.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final now = DateTime.now();
  final testCategories = [
    Category(
      id: 'c1',
      merchantId: 'm1',
      storeId: 's1',
      name: 'Beverages',
      description: 'Hot & Cold Drinks',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    ),
    Category(
      id: 'c2',
      merchantId: 'm1',
      storeId: 's1',
      name: 'Snacks',
      description: 'Quick bites',
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
        child: InventoryCategoriesDataTable(
          categories: testCategories,
          allProducts: const [],
          onEdit: (_) {},
        ),
      ),
    ),
  );

  group('InventoryCategoriesDataTable Pinned Column Layout Tests', () {
    testWidgets('renders pinned left pane and scrollable right pane', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(width: 1200));
      await tester.pumpAndSettle();

      expect(find.byType(InventoryCategoriesPinnedHeader), findsOneWidget);
      expect(find.byType(InventoryCategoriesScrollableHeader), findsOneWidget);
      expect(find.text('NAME'), findsOneWidget);
      expect(find.text('Beverages'), findsOneWidget);
      expect(find.text('Snacks'), findsOneWidget);
      expect(find.text('Hot & Cold Drinks'), findsOneWidget);
      expect(find.byType(InventoryCategoryPinnedRow), findsNWidgets(2));
      expect(find.byType(InventoryCategoryScrollableRow), findsNWidgets(2));
    });

    testWidgets('horizontal scroll maintains pinned category name', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(width: 600));
      await tester.pumpAndSettle();

      final scrollableFinder = find.byKey(
        const ValueKey('inventory_categories_scrollable_pane'),
      );
      expect(scrollableFinder, findsOneWidget);

      await tester.drag(scrollableFinder, const Offset(-200, 0));
      await tester.pumpAndSettle();

      expect(find.text('Beverages'), findsOneWidget);
      expect(find.text('Snacks'), findsOneWidget);
    });
  });
}
