import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// Client repository for managing product inventory stock levels.
abstract final class StockRepository {
  /// Updates inventory levels, thresholds, or logs a stock transaction adjustment for [id].
  static Future<Stock> update({
    required String id,
    int? quantity,
    int? lowStockThreshold,
    bool? stockMonitor,
    StockTransactionType? transactionType,
    int? amount,
    StockTransactionReason? reason,
    String? customReason,
  }) async {
    try {
      final path = '${ApiEndpoints.stocks}/$id';
      final result = await dio.patch(
        path,
        data: {
          'quantity': ?quantity,
          'lowStockThreshold': ?lowStockThreshold,
          'stockMonitor': ?stockMonitor,
          'transactionType': transactionType?.name,
          'amount': ?amount,
          'reason': reason?.name,
          'customReason': ?customReason,
        },
      );

      return Stock.fromJson(
        result.data['data']['stock'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to update stock.');
    }
  }
}
