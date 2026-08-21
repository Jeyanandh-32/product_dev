import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/inventory_data_table.dart';
import 'package:terminal/components/inventory/products/inventory_product_pinned_row.dart';
import 'package:terminal/components/inventory/products/inventory_product_scrollable_row.dart';
import 'package:terminal/components/inventory/products/inventory_products_pinned_header.dart';
import 'package:terminal/components/inventory/products/inventory_products_scrollable_header.dart';

Product _mockProd(
  String id,
  String name,
  String sku,
  String barcode,
  double price,
  bool active,
  DateTime now,
) {
  return Product(
    id: id,
    merchantId: 'm1',
    name: name,
    sku: sku,
    barcode: barcode,
    basePrice: 100.0,
    sellingPrice: price,
    taxRate: 5.0,
    isActive: active,
    stock: Stock(
      id: 's_$id',
      productId: id,
      storeId: 's1',
      quantity: 50,
      lowStockThreshold: 10,
      stockMonitor: true,
      createdAt: now,
      updatedAt: now,
    ),
    category: Category(
      id: 'c1',
      merchantId: 'm1',
      storeId: 's1',
      name: 'Coffee',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    ),
    counter: Counter(
      id: 'cnt1',
      merchantId: 'm1',
      storeId: 's1',
      name: 'Main Bar',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    ),
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final now = DateTime.now();
  final testProducts = [
    _mockProd(
      'p1',
      'Espresso Roast',
      'SKU-001',
      '8901234567890',
      150.0,
      true,
      now,
    ),
    _mockProd(
      'p2',
      'Caramel Macchiato',
      'SKU-002',
      '8901234567891',
      220.0,
      false,
      now,
    ),
  ];

  Widget buildTestWidget() => MaterialApp(
    builder: (context, child) => FTheme(
      data: FTheme.neutral.light.desktop,
      child: child ?? const SizedBox(),
    ),
    home: Scaffold(
      body: SizedBox(
        width: 1000,
        height: 600,
        child: InventoryDataTable(
          products: testProducts,
          onEdit: (_) {},
          onUpdateStock: (_) {},
        ),
      ),
    ),
  );

  group('InventoryDataTable Pinned Column Layout Tests', () {
    testWidgets('renders both pinned left pane and scrollable right pane', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(InventoryProductsPinnedHeader), findsOneWidget);
      expect(find.byType(InventoryProductsScrollableHeader), findsOneWidget);
      expect(find.text('PRODUCT NAME'), findsOneWidget);
      expect(find.text('Espresso Roast'), findsOneWidget);
      expect(find.text('Caramel Macchiato'), findsOneWidget);
      expect(find.text('SKU-001'), findsOneWidget);
      expect(find.text('SKU-002'), findsOneWidget);
      expect(find.text('8901234567890'), findsOneWidget);
      expect(find.byType(InventoryProductPinnedRow), findsNWidgets(2));
      expect(find.byType(InventoryProductScrollableRow), findsNWidgets(2));
    });

    testWidgets(
      'horizontal scroll scrolls right pane while pinned pane remains fixed',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        final scrollableFinder = find.byKey(
          const ValueKey('inventory_products_scrollable_pane'),
        );
        expect(scrollableFinder, findsOneWidget);

        await tester.drag(scrollableFinder, const Offset(-300, 0));
        await tester.pumpAndSettle();

        expect(find.text('Espresso Roast'), findsOneWidget);
        expect(find.text('Caramel Macchiato'), findsOneWidget);
      },
    );
  });
}
