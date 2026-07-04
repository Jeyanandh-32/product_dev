import 'package:backend/database/schema.dart';
import 'package:models/models.dart';

extension StockRowExtension on StockRow {
  Stock toStock() => Stock(
    id: id,
    productId: productId,
    storeId: storeId,
    quantity: quantity,
    lowStockThreshold: lowStockThreshold,
    stockMonitor: stockMonitor,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
