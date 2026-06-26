import 'package:backend/models/stock/stock_dto.dart';
import 'package:models/models.dart';

extension StockDtoExtension on StockDto {
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
