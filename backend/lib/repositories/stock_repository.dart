import 'package:backend/models/stock/stock_dto.dart';
import 'package:postgres/postgres.dart';

class StockRepository {
  StockRepository({required Session session}) : _session = session;

  final Session _session;

  Future<StockDto> create({
    required String productId,
    required String storeId,
  }) async {
    final result = await _session.execute(
      Sql.named('''
      INSERT INTO stocks(product_id, store_id)
      VALUES(@productId, @storeId) RETURNING *
      '''),
      parameters: {
        'productId': productId,
        'storeId': storeId,
      },
    );

    return StockDto.fromJson(result.first.toColumnMap());
  }

  Future<StockDto?> update({
    required String id,
    int? quantity,
    int? lowStockThreshold,
    bool? stockMonitor,
  }) async {
    final result = await _session.execute(
      Sql.named('''
      UPDATE stocks SET 
        quantity = COALESCE(@quantity, quantity),
        low_stock_threshold = COALESCE(@lowStockThreshold, low_stock_threshold),
        stock_monitor = COALESCE(@stockMonitor, stock_monitor),
        updated_at = NOW()
      WHERE id = @id RETURNING *
      '''),
      parameters: {
        'id': id,
        'quantity': quantity,
        'lowStockThreshold': lowStockThreshold,
        'stockMonitor': stockMonitor,
      },
    );

    if (result.isEmpty) return null;

    return StockDto.fromJson(result.first.toColumnMap());
  }
}
