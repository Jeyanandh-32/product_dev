import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/inventory_products_signal.dart';
import 'package:terminal/signals/products_signal.dart';

void main() {
  final now = DateTime.now();
  final cat1 = Category(id: 'c1', name: 'Drinks', merchantId: 'm1', storeId: 's1', isActive: true, createdAt: now, updatedAt: now);
  final cat2 = Category(id: 'c2', name: 'Food', merchantId: 'm1', storeId: 's1', isActive: true, createdAt: now, updatedAt: now);

  final p1 = Product(
    id: 'p1',
    merchantId: 'm1',
    name: 'Coffee',
    category: cat1,
    taxRate: 5.0,
    basePrice: 80.0,
    sellingPrice: 120.0,
    sku: 'SKU1',
    barcode: 'BAR1',
    isActive: true,
    stock: Stock(id: 's1', productId: 'p1', storeId: 's1', quantity: 20, lowStockThreshold: 5, stockMonitor: true, createdAt: now, updatedAt: now),
    createdAt: now,
    updatedAt: now,
  );

  final p2 = Product(
    id: 'p2',
    merchantId: 'm1',
    name: 'Bread',
    category: cat2,
    taxRate: 12.0,
    basePrice: 50.0,
    sellingPrice: 90.0,
    sku: 'SKU2',
    barcode: 'BAR2',
    isActive: false,
    stock: Stock(id: 's2', productId: 'p2', storeId: 's1', quantity: 3, lowStockThreshold: 5, stockMonitor: true, createdAt: now, updatedAt: now),
    createdAt: now,
    updatedAt: now,
  );

  final p3 = Product(
    id: 'p3',
    merchantId: 'm1',
    name: 'Donut',
    category: cat2,
    taxRate: 0.0,
    basePrice: 30.0,
    sellingPrice: 45.0,
    sku: 'SKU3',
    barcode: 'BAR3',
    isActive: true,
    stock: Stock(id: 's3', productId: 'p3', storeId: 's1', quantity: 0, lowStockThreshold: 5, stockMonitor: true, createdAt: now, updatedAt: now),
    createdAt: now,
    updatedAt: now,
  );

  final p4 = Product(
    id: 'p4',
    merchantId: 'm1',
    name: 'Untracked',
    category: cat1,
    taxRate: 0.0,
    basePrice: 10.0,
    sellingPrice: 15.0,
    isActive: true,
    stock: Stock(id: 's4', productId: 'p4', storeId: 's1', quantity: 100, lowStockThreshold: 0, stockMonitor: false, createdAt: now, updatedAt: now),
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    initDio(Dio(BaseOptions(baseUrl: 'http://localhost:8080')));
    productsSignal.value = AsyncData([p1, p2, p3, p4]);
    inventorySearchSignal.value = '';
    inventoryCategoryFilterSignal.value = null;
    inventoryStatusFilterSignal.value = null;
    inventoryStockMonitorFilterSignal.value = null;
    inventoryStockHealthFilterSignal.value = StockHealthFilter.all;
    inventorySortStateSignal.value = const ProductSortState();
    inventoryEntriesSignal.value = 10;
    inventoryPageSignal.value = 1;
  });

  test('Search filter queries name, SKU, and barcode', () {
    inventorySearchSignal.value = 'coffee';
    expect(filteredInventoryProductsSignal.value.length, 1);
    expect(filteredInventoryProductsSignal.value.first.id, 'p1');

    inventorySearchSignal.value = 'SKU2';
    expect(filteredInventoryProductsSignal.value.length, 1);
    expect(filteredInventoryProductsSignal.value.first.id, 'p2');
  });

  test('Status, monitor, and category filters work accurately', () {
    inventoryStatusFilterSignal.value = false;
    expect(filteredInventoryProductsSignal.value.length, 1);
    expect(filteredInventoryProductsSignal.value.first.id, 'p2');
    inventoryStatusFilterSignal.value = null;

    inventoryStockMonitorFilterSignal.value = false;
    expect(filteredInventoryProductsSignal.value.length, 1);
    expect(filteredInventoryProductsSignal.value.first.id, 'p4');
    inventoryStockMonitorFilterSignal.value = null;

    inventoryCategoryFilterSignal.value = 'c1';
    expect(filteredInventoryProductsSignal.value.length, 2);
  });

  test('Stock health filter classifies stock correctly', () {
    inventoryStockHealthFilterSignal.value = StockHealthFilter.inStock;
    expect(filteredInventoryProductsSignal.value.map((p) => p.id), ['p1']);

    inventoryStockHealthFilterSignal.value = StockHealthFilter.lowStock;
    expect(filteredInventoryProductsSignal.value.map((p) => p.id), ['p2']);

    inventoryStockHealthFilterSignal.value = StockHealthFilter.outOfStock;
    expect(filteredInventoryProductsSignal.value.map((p) => p.id), ['p3']);

    inventoryStockHealthFilterSignal.value = StockHealthFilter.untracked;
    expect(filteredInventoryProductsSignal.value.map((p) => p.id), ['p4']);
  });

  test('Sorting ascending and descending orders list appropriately', () {
    inventorySortStateSignal.value = const ProductSortState(key: ProductSortKey.sellingPrice, isAscending: true);
    expect(filteredInventoryProductsSignal.value.first.id, 'p4');

    inventorySortStateSignal.value = const ProductSortState(key: ProductSortKey.sellingPrice, isAscending: false);
    expect(filteredInventoryProductsSignal.value.first.id, 'p1');
  });

  test('Pagination slices data into pages', () {
    inventoryEntriesSignal.value = 2;
    inventoryPageSignal.value = 1;
    expect(pagedInventoryProductsSignal.value.length, 2);
    expect(inventoryTotalPagesSignal.value, 2);
  });
}
