import 'package:merchant/components/reports/products_table_header.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:merchant/signals/products_signal.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

/// Helper function to compute tax amount in Rupees for a given product price and tax rate.
double calculateProductTaxAmount({
  required double sellingPrice,
  required double taxRate,
}) =>
    sellingPrice * (taxRate / 100.0);

/// Helper function to compute price inclusive of taxes in Rupees.
double calculateProductPriceWithTax({
  required double sellingPrice,
  required double taxRate,
}) =>
    sellingPrice + calculateProductTaxAmount(
      sellingPrice: sellingPrice,
      taxRate: taxRate,
    );

/// Helper function to calculate gross margin in Rupees.
double calculateProductMargin({
  required double sellingPrice,
  required double basePrice,
}) =>
    sellingPrice - basePrice;

/// Helper function implementing ProductsTableView filtering logic.
List<Product> filterProducts({
  required List<Product> products,
  bool? statusFilter,
  bool? stockMonitorFilter,
  String search = '',
}) {
  final query = search.trim().toLowerCase();
  return products.where((prod) {
    if (statusFilter != null && prod.isActive != statusFilter) {
      return false;
    }
    if (stockMonitorFilter != null &&
        prod.stock?.stockMonitor != stockMonitorFilter) {
      return false;
    }
    if (query.isNotEmpty) {
      final matchesName = prod.name.toLowerCase().contains(query);
      final matchesSku = prod.sku?.toLowerCase().contains(query) ?? false;
      final matchesBarcode =
          prod.barcode?.toLowerCase().contains(query) ?? false;
      if (!matchesName && !matchesSku && !matchesBarcode) {
        return false;
      }
    }
    return true;
  }).toList();
}

/// Helper function implementing ProductsTableView sorting logic.
List<Product> sortProducts({
  required List<Product> products,
  required SortState<ProductSortKey> sortState,
}) =>
    sortItems<Product, ProductSortKey>(
      items: products,
      sortState: sortState,
      getSortValue: (item, k) => switch (k) {
        ProductSortKey.name => item.name.toLowerCase(),
        ProductSortKey.sku => (item.sku ?? '').toLowerCase(),
        ProductSortKey.barcode => (item.barcode ?? '').toLowerCase(),
        ProductSortKey.status => item.isActive ? 1 : 0,
        ProductSortKey.stock => item.stock?.quantity ?? 0,
        ProductSortKey.lowStock => item.stock?.lowStockThreshold ?? 0,
        ProductSortKey.basePrice => item.basePrice,
        ProductSortKey.sellingPrice => item.sellingPrice,
        ProductSortKey.taxRate => item.taxRate,
        ProductSortKey.category => (item.category?.name ?? '').toLowerCase(),
        ProductSortKey.counter => (item.counter?.name ?? '').toLowerCase(),
      },
    );

void main() {
  group('Merchant Product Pricing, Signals & Table Sorting Tests', () {
    final now = DateTime.now();

    final beverageCategory = Category(
      id: 'cat-1',
      merchantId: 'm-1',
      storeId: 'store-1',
      name: 'Beverages',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    final snacksCategory = Category(
      id: 'cat-2',
      merchantId: 'm-1',
      storeId: 'store-1',
      name: 'Snacks',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    final bakeryCategory = Category(
      id: 'cat-3',
      merchantId: 'm-1',
      storeId: 'store-1',
      name: 'Bakery',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    final counter1 = Counter(
      id: 'cnt-1',
      name: 'Counter A',
      merchantId: 'm-1',
      storeId: 'store-1',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    final counter2 = Counter(
      id: 'cnt-2',
      name: 'Counter B',
      merchantId: 'm-1',
      storeId: 'store-1',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    final espresso = Product(
      id: 'p-espresso',
      merchantId: 'm-1',
      name: 'Espresso',
      sku: 'SKU-ESP',
      barcode: '8901001',
      basePrice: 40.0, // ₹40.00
      sellingPrice: 100.0, // ₹100.00
      taxRate: 5.0, // 5% GST
      isActive: true,
      category: beverageCategory,
      counter: counter1,
      stock: Stock(
        id: 'stk-1',
        productId: 'p-espresso',
        storeId: 'store-1',
        quantity: 50,
        lowStockThreshold: 10,
        stockMonitor: true,
        createdAt: now,
        updatedAt: now,
      ),
      createdAt: now,
      updatedAt: now,
    );

    final croissant = Product(
      id: 'p-croissant',
      merchantId: 'm-1',
      name: 'Butter Croissant',
      sku: 'SKU-CRO',
      barcode: '8901002',
      basePrice: 50.0, // ₹50.00
      sellingPrice: 120.0, // ₹120.00
      taxRate: 12.0, // 12% GST
      isActive: true,
      category: bakeryCategory,
      counter: counter2,
      stock: Stock(
        id: 'stk-2',
        productId: 'p-croissant',
        storeId: 'store-1',
        quantity: 15,
        lowStockThreshold: 5,
        stockMonitor: true,
        createdAt: now,
        updatedAt: now,
      ),
      createdAt: now,
      updatedAt: now,
    );

    final samosa = Product(
      id: 'p-samosa',
      merchantId: 'm-1',
      name: 'Aloo Samosa',
      sku: 'SKU-SAM',
      barcode: '8901003',
      basePrice: 10.0, // ₹10.00
      sellingPrice: 30.0, // ₹30.00
      taxRate: 5.0, // 5% GST
      isActive: false, // Inactive
      category: snacksCategory,
      counter: counter1,
      stock: Stock(
        id: 'stk-3',
        productId: 'p-samosa',
        storeId: 'store-1',
        quantity: 5,
        lowStockThreshold: 20,
        stockMonitor: false, // No monitor
        createdAt: now,
        updatedAt: now,
      ),
      createdAt: now,
      updatedAt: now,
    );

    final brownie = Product(
      id: 'p-brownie',
      merchantId: 'm-1',
      name: 'Walnut Brownie',
      sku: 'SKU-BRW',
      barcode: '8901004',
      basePrice: 60.0, // ₹60.00
      sellingPrice: 150.0, // ₹150.00
      taxRate: 18.0, // 18% GST
      isActive: true,
      category: bakeryCategory,
      counter: counter2,
      stock: Stock(
        id: 'stk-4',
        productId: 'p-brownie',
        storeId: 'store-1',
        quantity: 80,
        lowStockThreshold: 15,
        stockMonitor: true,
        createdAt: now,
        updatedAt: now,
      ),
      createdAt: now,
      updatedAt: now,
    );

    final testProducts = [espresso, croissant, samosa, brownie];

    setUp(() {
      resetProductsSignal();
    });

    test('Product pricing calculations in Rupees with taxes and profit margins', () {
      // 1. Espresso: Base ₹40, Selling ₹100, Tax 5%
      final espTaxAmount = calculateProductTaxAmount(
        sellingPrice: espresso.sellingPrice,
        taxRate: espresso.taxRate,
      );
      final espTotalWithTax = calculateProductPriceWithTax(
        sellingPrice: espresso.sellingPrice,
        taxRate: espresso.taxRate,
      );
      final espMargin = calculateProductMargin(
        sellingPrice: espresso.sellingPrice,
        basePrice: espresso.basePrice,
      );
      expect(espTaxAmount, 5.0); // ₹5.00
      expect(espTotalWithTax, 105.0); // ₹105.00
      expect(espMargin, 60.0); // ₹60.00 profit margin

      // 2. Croissant: Base ₹50, Selling ₹120, Tax 12%
      final croTaxAmount = calculateProductTaxAmount(
        sellingPrice: croissant.sellingPrice,
        taxRate: croissant.taxRate,
      );
      final croTotalWithTax = calculateProductPriceWithTax(
        sellingPrice: croissant.sellingPrice,
        taxRate: croissant.taxRate,
      );
      final croMargin = calculateProductMargin(
        sellingPrice: croissant.sellingPrice,
        basePrice: croissant.basePrice,
      );
      expect(croTaxAmount, closeTo(14.4, 0.001)); // ₹14.40
      expect(croTotalWithTax, closeTo(134.4, 0.001)); // ₹134.40
      expect(croMargin, 70.0); // ₹70.00 profit margin

      // 3. Brownie: Base ₹60, Selling ₹150, Tax 18%
      final brwTaxAmount = calculateProductTaxAmount(
        sellingPrice: brownie.sellingPrice,
        taxRate: brownie.taxRate,
      );
      final brwTotalWithTax = calculateProductPriceWithTax(
        sellingPrice: brownie.sellingPrice,
        taxRate: brownie.taxRate,
      );
      final brwMargin = calculateProductMargin(
        sellingPrice: brownie.sellingPrice,
        basePrice: brownie.basePrice,
      );
      expect(brwTaxAmount, 27.0); // ₹27.00
      expect(brwTotalWithTax, 177.0); // ₹177.00
      expect(brwMargin, 90.0); // ₹90.00 profit margin
    });

    test('Products signal state management and resetProductsSignal', () {
      expect(productsPageSignal.value, 1);
      expect(productsTotalSignal.value, 0);
      expect(productsTotalPagesSignal.value, 1);
      expect(productSearchSignal.value, '');
      expect(editingProductSignal.value, isNull);

      // Mutate state
      productsPageSignal.value = 3;
      productsTotalSignal.value = 50;
      productsTotalPagesSignal.value = 5;
      productSearchSignal.value = 'espresso';
      editingProductSignal.value = espresso;

      expect(productsPageSignal.value, 3);
      expect(editingProductSignal.value?.name, 'Espresso');

      // Reset
      resetProductsSignal();
      expect(productsPageSignal.value, 1);
      expect(productsTotalSignal.value, 0);
      expect(productsTotalPagesSignal.value, 1);
      expect(productSearchSignal.value, '');
      expect(editingProductSignal.value, isNull);
    });

    test('SortState toggle cycle: none -> asc -> desc -> none', () {
      var sortState = const SortState<ProductSortKey>();
      expect(sortState.key, isNull);
      expect(sortState.direction, SortDirection.none);

      sortState = sortState.toggle(ProductSortKey.sellingPrice);
      expect(sortState.key, ProductSortKey.sellingPrice);
      expect(sortState.direction, SortDirection.asc);

      sortState = sortState.toggle(ProductSortKey.sellingPrice);
      expect(sortState.key, ProductSortKey.sellingPrice);
      expect(sortState.direction, SortDirection.desc);

      sortState = sortState.toggle(ProductSortKey.sellingPrice);
      expect(sortState.key, isNull);
      expect(sortState.direction, SortDirection.none);

      // Switching key starts from asc
      sortState = sortState.toggle(ProductSortKey.name);
      expect(sortState.key, ProductSortKey.name);
      expect(sortState.direction, SortDirection.asc);

      sortState = sortState.toggle(ProductSortKey.stock);
      expect(sortState.key, ProductSortKey.stock);
      expect(sortState.direction, SortDirection.asc);
    });

    test('Table sorting by Product Name (Ascending and Descending)', () {
      // Ascending
      final ascSorted = sortProducts(
        products: testProducts,
        sortState: const SortState(
          key: ProductSortKey.name,
          direction: SortDirection.asc,
        ),
      );
      expect(
        ascSorted.map((p) => p.name).toList(),
        ['Aloo Samosa', 'Butter Croissant', 'Espresso', 'Walnut Brownie'],
      );

      // Descending
      final descSorted = sortProducts(
        products: testProducts,
        sortState: const SortState(
          key: ProductSortKey.name,
          direction: SortDirection.desc,
        ),
      );
      expect(
        descSorted.map((p) => p.name).toList(),
        ['Walnut Brownie', 'Espresso', 'Butter Croissant', 'Aloo Samosa'],
      );
    });

    test('Table sorting by Selling Price (Ascending and Descending in Rupees)', () {
      // Samosa (₹30), Espresso (₹100), Croissant (₹120), Brownie (₹150)
      final ascSorted = sortProducts(
        products: testProducts,
        sortState: const SortState(
          key: ProductSortKey.sellingPrice,
          direction: SortDirection.asc,
        ),
      );
      expect(
        ascSorted.map((p) => p.sellingPrice).toList(),
        [30.0, 100.0, 120.0, 150.0],
      );

      // Descending
      final descSorted = sortProducts(
        products: testProducts,
        sortState: const SortState(
          key: ProductSortKey.sellingPrice,
          direction: SortDirection.desc,
        ),
      );
      expect(
        descSorted.map((p) => p.sellingPrice).toList(),
        [150.0, 120.0, 100.0, 30.0],
      );
    });

    test('Table sorting by Base Price and Tax Rate', () {
      // Base Price Ascending: Samosa (10), Espresso (40), Croissant (50), Brownie (60)
      final basePriceSorted = sortProducts(
        products: testProducts,
        sortState: const SortState(
          key: ProductSortKey.basePrice,
          direction: SortDirection.asc,
        ),
      );
      expect(
        basePriceSorted.map((p) => p.basePrice).toList(),
        [10.0, 40.0, 50.0, 60.0],
      );

      // Tax Rate Descending: Brownie (18%), Croissant (12%), Espresso (5%), Samosa (5%)
      final taxRateSorted = sortProducts(
        products: testProducts,
        sortState: const SortState(
          key: ProductSortKey.taxRate,
          direction: SortDirection.desc,
        ),
      );
      expect(taxRateSorted.first.taxRate, 18.0);
      expect(taxRateSorted[1].taxRate, 12.0);
      expect(taxRateSorted.last.taxRate, 5.0);
    });

    test('Table sorting by Stock Quantity and Category Name', () {
      // Stock Ascending: Samosa (5), Croissant (15), Espresso (50), Brownie (80)
      final stockAsc = sortProducts(
        products: testProducts,
        sortState: const SortState(
          key: ProductSortKey.stock,
          direction: SortDirection.asc,
        ),
      );
      expect(
        stockAsc.map((p) => p.stock?.quantity).toList(),
        [5, 15, 50, 80],
      );

      // Category Name Ascending: Bakery (Brownie, Croissant), Beverages (Espresso), Snacks (Samosa)
      final catAsc = sortProducts(
        products: testProducts,
        sortState: const SortState(
          key: ProductSortKey.category,
          direction: SortDirection.asc,
        ),
      );
      expect(
        catAsc.map((p) => p.category?.name).toList(),
        ['Bakery', 'Bakery', 'Beverages', 'Snacks'],
      );
    });

    test('Table filtering by active status, stock monitor, and search query', () {
      // Filter Active only
      final activeOnly = filterProducts(
        products: testProducts,
        statusFilter: true,
      );
      expect(activeOnly.length, 3);
      expect(activeOnly.every((p) => p.isActive), isTrue);

      // Filter Inactive only
      final inactiveOnly = filterProducts(
        products: testProducts,
        statusFilter: false,
      );
      expect(inactiveOnly.length, 1);
      expect(inactiveOnly.first.name, 'Aloo Samosa');

      // Filter stockMonitor: true
      final monitoredOnly = filterProducts(
        products: testProducts,
        stockMonitorFilter: true,
      );
      expect(monitoredOnly.length, 3);

      // Search by SKU: 'SKU-CRO'
      final searchSku = filterProducts(
        products: testProducts,
        search: 'SKU-CRO',
      );
      expect(searchSku.length, 1);
      expect(searchSku.first.name, 'Butter Croissant');

      // Search by Barcode: '8901004'
      final searchBarcode = filterProducts(
        products: testProducts,
        search: '8901004',
      );
      expect(searchBarcode.length, 1);
      expect(searchBarcode.first.name, 'Walnut Brownie');
    });
  });
}
