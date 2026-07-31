import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

class OrderRepository {
  const OrderRepository._();

  static Future<Order> create({
    required String storeId,
    required List<Map<String, dynamic>> products,
    OrderSource? source,
    OrderType? type,
    PaymentMethod? paymentMethod,
  }) async {
    try {
      final result = await dio.post(
        ApiEndpoints.orders,
        queryParameters: {'storeId': storeId},
        data: {
          'products': products,
          'source': ?source?.name,
          'type': ?type?.name,
          'paymentMethod': ?paymentMethod?.name,
        },
      );

      return Order.fromJson(
        result.data['data']['order'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to place order.');
    }
  }

  static Future<PaginatedResponse<Order>> getAll({
    required String storeId,
    int? page,
    int? size,
  }) async {
    try {
      final result = await dio.get(
        ApiEndpoints.orders,
        queryParameters: {'storeId': storeId, 'page': ?page, 'size': ?size},
      );

      return parsePaginatedResponse(
        data: result.data['data'] as Map<String, dynamic>,
        key: 'orders',
        fromJson: Order.fromJson,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch orders.');
    }
  }
}
