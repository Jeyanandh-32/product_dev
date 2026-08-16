import 'package:backend/database/schema.dart';

/// Aggregates and formats low stock products and category sales data for analytics responses.
class DashboardProductAggregator {
  const DashboardProductAggregator._();

  /// Formats top 5 low stock products from joined product, stock, and category tuples.
  static List<Map<String, dynamic>> formatLowStockProducts(
    List<(ProductRow, StockRow?, CategoryRow?)> productRows,
  ) {
    return productRows
        .where((tuple) {
          final s = tuple.$2;
          return s != null && s.quantity <= s.lowStockThreshold;
        })
        .take(5)
        .map((tuple) {
          final p = tuple.$1;
          final s = tuple.$2;
          final c = tuple.$3;
          return {
            'id': p.id,
            'name': p.name,
            'category': c?.name ?? 'General',
            'quantity': s?.quantity ?? 0,
            'lowStockThreshold': s?.lowStockThreshold ?? 5,
            'sellingPrice': p.sellingPrice,
          };
        })
        .toList();
  }
}
