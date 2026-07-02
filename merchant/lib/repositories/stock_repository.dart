import 'package:dio/dio.dart';
import 'package:merchant/config/api_client.dart';
import 'package:models/models.dart';

class StockRepository {
  const StockRepository._();

  static Future<Stock> update({
    required String id,
    int? quantity,
    int? lowStockThreshold,
    bool? stockMonitor,
  }) async {
    try {
      final path = '${ApiEndpoints.stocks}/$id';
      final result = await ApiClient.dio.patch(
        path,
        data: {
          'quantity': ?quantity,
          'lowStockThreshold': ?lowStockThreshold,
          'stockMonitor': ?stockMonitor,
        },
      );

      return Stock.fromJson(
        result.data['data']['stock'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      ApiClient.handleDioError(e, 'Failed to update stock.');
    }
  }
}
