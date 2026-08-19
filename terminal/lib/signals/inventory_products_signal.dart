import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/inventory_filter_types.dart';
import 'package:terminal/signals/products_signal.dart';

export 'package:terminal/signals/inventory_filter_types.dart';
export 'package:terminal/signals/inventory_stock_actions.dart';

final inventorySearchSignal = signal<String>('');
final inventoryCategoryFilterSignal = signal<String?>(null);
final inventoryCounterFilterSignal = signal<String?>(null);
final inventoryStatusFilterSignal = signal<bool?>(null);
final inventoryStockMonitorFilterSignal = signal<bool?>(null);
final inventoryStockHealthFilterSignal = signal<StockHealthFilter>(StockHealthFilter.all);
final inventorySortStateSignal = signal<ProductSortState>(const ProductSortState());
final inventoryEntriesSignal = signal<int>(10);
final inventoryPageSignal = signal<int>(1);
final editingInventoryProductSignal = signal<Product?>(null);

/// Computed signal filtering and sorting products with 100% merchant parity.
final filteredInventoryProductsSignal = computed<List<Product>>(() {
  final products = productsSignal.value.value ?? [];
  final search = inventorySearchSignal.value.trim().toLowerCase();
  final catId = inventoryCategoryFilterSignal.value;
  final counterId = inventoryCounterFilterSignal.value;
  final status = inventoryStatusFilterSignal.value;
  final stockMonitor = inventoryStockMonitorFilterSignal.value;
  final stockHealth = inventoryStockHealthFilterSignal.value;
  final sortState = inventorySortStateSignal.value;

  final filtered = products.where((p) {
    if (search.isNotEmpty) {
      final nameMatches = p.name.toLowerCase().contains(search);
      final skuMatches = p.sku?.toLowerCase().contains(search) ?? false;
      final barcodeMatches = p.barcode?.toLowerCase().contains(search) ?? false;
      if (!nameMatches && !skuMatches && !barcodeMatches) return false;
    }
    if (catId != null && p.category?.id != catId) return false;
    if (counterId != null && p.counter?.id != counterId) return false;
    if (status != null && p.isActive != status) return false;
    if (stockMonitor != null && (p.stock?.stockMonitor ?? false) != stockMonitor) return false;

    if (stockHealth != StockHealthFilter.all) {
      final stock = p.stock;
      if (stockHealth == StockHealthFilter.untracked) {
        if (stock != null && stock.stockMonitor) return false;
      } else if (stock == null || !stock.stockMonitor) {
        return false;
      } else {
        final qty = stock.quantity;
        final threshold = stock.lowStockThreshold;
        if (stockHealth == StockHealthFilter.outOfStock && qty > 0) return false;
        if (stockHealth == StockHealthFilter.lowStock && (qty <= 0 || qty > threshold)) return false;
        if (stockHealth == StockHealthFilter.inStock && qty <= threshold) return false;
      }
    }
    return true;
  }).toList();

  final sortKey = sortState.key;
  if (sortKey == null) return filtered;

  filtered.sort((a, b) {
    final cmp = _compareProducts(a, b, sortKey);
    return sortState.isAscending ? cmp : -cmp;
  });

  return filtered;
});

int _compareProducts(Product a, Product b, ProductSortKey key) => switch (key) {
      ProductSortKey.name => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      ProductSortKey.sku => (a.sku ?? '').toLowerCase().compareTo((b.sku ?? '').toLowerCase()),
      ProductSortKey.barcode => (a.barcode ?? '').toLowerCase().compareTo((b.barcode ?? '').toLowerCase()),
      ProductSortKey.status => (a.isActive ? 1 : 0).compareTo(b.isActive ? 1 : 0),
      ProductSortKey.stock => (a.stock?.quantity ?? 0).compareTo(b.stock?.quantity ?? 0),
      ProductSortKey.lowStock => (a.stock?.lowStockThreshold ?? 0).compareTo(b.stock?.lowStockThreshold ?? 0),
      ProductSortKey.basePrice => a.basePrice.compareTo(b.basePrice),
      ProductSortKey.sellingPrice => a.sellingPrice.compareTo(b.sellingPrice),
      ProductSortKey.taxRate => a.taxRate.compareTo(b.taxRate),
      ProductSortKey.category => (a.category?.name ?? '').toLowerCase().compareTo((b.category?.name ?? '').toLowerCase()),
      ProductSortKey.counter => (a.counter?.name ?? '').toLowerCase().compareTo((b.counter?.name ?? '').toLowerCase()),
    };

/// Computed paginated slice of inventory products.
final pagedInventoryProductsSignal = computed<List<Product>>(() {
  final all = filteredInventoryProductsSignal.value;
  final entries = inventoryEntriesSignal.value;
  final page = inventoryPageSignal.value;
  final startIndex = (page - 1) * entries;
  if (startIndex >= all.length) return <Product>[];
  final endIndex = (startIndex + entries).clamp(0, all.length);
  return all.sublist(startIndex, endIndex);
});

/// Total number of pages for inventory list.
final inventoryTotalPagesSignal = computed<int>(() {
  final total = filteredInventoryProductsSignal.value.length;
  final entries = inventoryEntriesSignal.value;
  if (total <= 0) return 1;
  return (total / entries).ceil();
});
