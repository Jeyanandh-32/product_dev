import 'package:dio/dio.dart';
import 'package:merchant/config/api_client.dart';
import 'package:merchant/repositories/auth_repository.dart';
import 'package:models/models.dart';

class CounterRepository {
  const CounterRepository._();

  static Never _handleDioError(DioException e, String defaultMessage) {
    final data = e.response?.data;
    final message =
        (data is Map ? data['message'] as String? : null) ?? defaultMessage;
    throw ApiException(message);
  }

  static Future<Counter> create({
    required String storeId,
    required String name,
  }) async {
    try {
      final result = await ApiClient.dio.post(
        ApiEndpoints.counters,
        queryParameters: {'storeId': storeId},
        data: {
          'name': name,
        },
      );

      return Counter.fromJson(
        result.data['data']['counter'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      _handleDioError(e, 'Failed to create counter.');
    }
  }

  static Future<Counter> update({
    required String id,
    String? name,
    bool? isActive,
  }) async {
    try {
      final path = '${ApiEndpoints.counters}/$id';
      final result = await ApiClient.dio.patch(
        path,
        data: {
          if (name != null) 'name': name,
          if (isActive != null) 'isActive': isActive,
        },
      );

      return Counter.fromJson(
        result.data['data']['counter'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      _handleDioError(e, 'Failed to update counter.');
    }
  }

  static Future<List<Counter>> getAll({String? storeId}) async {
    try {
      final result = await ApiClient.dio.get(
        ApiEndpoints.counters,
        queryParameters: {
          if (storeId != null) 'storeId': storeId,
        },
      );

      final list = result.data['data']['counters'] as List<dynamic>;

      return list
          .map((s) => Counter.fromJson(s as Map<String, Object?>))
          .toList();
    } on DioException catch (e) {
      _handleDioError(e, 'Failed to fetch counters.');
    }
  }
}
