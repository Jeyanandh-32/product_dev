import 'package:models/models.dart';
import 'package:trina_grid/trina_grid.dart';

/// Row transformer for inventory products TrinaGrid.
class InventoryTrinaRows {
  const InventoryTrinaRows._();

  static List<TrinaRow> fromProducts(List<Product> products) {
    return products.map(buildRow).toList();
  }

  static TrinaRow buildRow(Product p) {
    return TrinaRow(
      cells: {
        'product_ref': TrinaCell(value: p),
        'action': TrinaCell(value: ''),
        'image': TrinaCell(value: p.imageUrl ?? ''),
        'name': TrinaCell(value: p.name),
        'sku': TrinaCell(value: p.sku ?? '-'),
        'barcode': TrinaCell(value: p.barcode ?? '-'),
        'status': TrinaCell(value: p.isActive),
        'stock': TrinaCell(value: p.stock?.quantity ?? 0),
        'low_stock': TrinaCell(value: p.stock?.lowStockThreshold != null ? '${p.stock!.lowStockThreshold}' : '-'),
        'monitor': TrinaCell(value: p.stock?.stockMonitor ?? false),
        'base_price': TrinaCell(value: '₹${p.basePrice.toStringAsFixed(2)}'),
        'selling_price': TrinaCell(value: '₹${p.sellingPrice.toStringAsFixed(2)}'),
        'tax_rate': TrinaCell(value: '${p.taxRate.toStringAsFixed(2)}%'),
        'category': TrinaCell(value: p.category?.name ?? '-'),
        'counter': TrinaCell(value: p.counter?.name ?? '-'),
      },
    );
  }
}
