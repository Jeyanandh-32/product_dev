import 'package:dio/dio.dart';
import 'package:merchant/config/api_client.dart';
import 'package:models/models.dart';

class CounterRepository {
  const CounterRepository._();

  static Future<Counter> create({
    required String storeId,
    required String name,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final result = await ApiClient.dio.post(
        ApiEndpoints.counters,
        queryParameters: {'storeId': storeId},
        data: {
          'name': name,
          'description': ?description,
          'imageUrl': ?imageUrl,
        },
      );

      return Counter.fromJson(
        result.data['data']['counter'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      ApiClient.handleDioError(e, 'Failed to create counter.');
    }
  }

  static Future<Counter> update({
    required String id,
    String? name,
    bool? isActive,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final path = '${ApiEndpoints.counters}/$id';
      final result = await ApiClient.dio.patch(
        path,
        data: {
          'name': ?name,
          'isActive': ?isActive,
          'description': ?description,
          'imageUrl': ?imageUrl,
        },
      );

      return Counter.fromJson(
        result.data['data']['counter'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      ApiClient.handleDioError(e, 'Failed to update counter.');
    }
  }

  static Future<
    ({
      List<Counter> counters,
      int currentPage,
      int pageSize,
      int totalItems,
      int totalPages,
    })
  >
  getAll({
    required String storeId,
    int? page,
    int? size,
  }) async {
    try {
      final result = await ApiClient.dio.get(
        ApiEndpoints.counters,
        queryParameters: {
          'storeId': storeId,
          'page': ?page,
          'size': ?size,
        },
      );

      final list = result.data['data']['counters'] as List<dynamic>;
      final currentPage = result.data['data']['currentPage'] as int? ?? 1;
      final pageSize = result.data['data']['pageSize'] as int? ?? 50;
      final totalItems =
          result.data['data']['totalItems'] as int? ?? list.length;
      final totalPages = result.data['data']['totalPages'] as int? ?? 1;

      final counters = list
          .map((s) => Counter.fromJson(s as Map<String, Object?>))
          .toList();

      return (
        counters: counters,
        currentPage: currentPage,
        pageSize: pageSize,
        totalItems: totalItems,
        totalPages: totalPages,
      );
    } on DioException catch (e) {
      ApiClient.handleDioError(e, 'Failed to fetch counters.');
    }
  }
}
