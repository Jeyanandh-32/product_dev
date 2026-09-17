import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// Client repository for managing service counters within a store.
abstract final class CounterRepository {
  /// Creates a new counter under the specified store.
  static Future<Counter> create({
    required String storeId,
    required String name,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final result = await dio.post(
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
      handleDioError(e, 'Failed to create counter.');
    }
  }

  /// Updates an existing counter by its unique [id].
  static Future<Counter> update({
    required String id,
    String? name,
    bool? isActive,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final path = '${ApiEndpoints.counters}/$id';
      final result = await dio.patch(
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
      handleDioError(e, 'Failed to update counter.');
    }
  }

  /// Fetches a paginated list of counters for a store matching search and active filters.
  static Future<PaginatedResponse<Counter>> getAll({
    required String storeId,
    int? page,
    int? size,
    String? search,
    bool? isActive,
  }) async {
    try {
      final result = await dio.get(
        ApiEndpoints.counters,
        queryParameters: {
          'storeId': storeId,
          'page': ?page,
          'size': ?size,
          'search': ?search,
          'isActive': ?isActive,
        },
      );

      return parsePaginatedResponse(
        data: result.data['data'] as Map<String, dynamic>,
        key: 'counters',
        fromJson: Counter.fromJson,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch counters.');
    }
  }
}
