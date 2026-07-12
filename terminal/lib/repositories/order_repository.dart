import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:terminal/config/api_client.dart';

class OrderRepository {
  const OrderRepository._();

  static Future<Order> create({
    required String storeId,
    required List<Map<String, dynamic>> products,
    String? source,
    String? type,
    String? paymentMethod,
  }) async {
    try {
      final result = await ApiClient.dio.post(
        ApiEndpoints.orders,
        queryParameters: {'storeId': storeId},
        data: {
          'products': products,
          'source': ?source,
          'type': ?type,
          'paymentMethod': ?paymentMethod,
        },
      );

      return Order.fromJson(
        result.data['data']['order'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      ApiClient.handleDioError(e, 'Failed to place order.');
    }
  }
}
