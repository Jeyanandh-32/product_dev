import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// Client repository for managing store categories.
abstract final class CategoryRepository {
  /// Creates a new product category under the specified store.
  static Future<Category> create({
    required String storeId,
    required String name,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final result = await dio.post(
        ApiEndpoints.categories,
        queryParameters: {'storeId': storeId},
        data: {
          'name': name,
          'description': ?description,
          'imageUrl': ?imageUrl,
        },
      );

      return Category.fromJson(
        result.data['data']['category'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to create category.');
    }
  }

  /// Updates an existing category by its unique [id].
  static Future<Category> update({
    required String id,
    String? name,
    bool? isActive,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final path = '${ApiEndpoints.categories}/$id';
      final result = await dio.patch(
        path,
        data: {
          'name': ?name,
          'isActive': ?isActive,
          'description': ?description,
          'imageUrl': ?imageUrl,
        },
      );

      return Category.fromJson(
        result.data['data']['category'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to update category.');
    }
  }

  /// Fetches a paginated list of categories for a store matching search and active filters.
  static Future<PaginatedResponse<Category>> getAll({
    required String storeId,
    int? page,
    int? size,
    String? search,
    bool? isActive,
  }) async {
    try {
      final result = await dio.get(
        ApiEndpoints.categories,
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
        key: 'categories',
        fromJson: Category.fromJson,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch categories.');
    }
  }
}
