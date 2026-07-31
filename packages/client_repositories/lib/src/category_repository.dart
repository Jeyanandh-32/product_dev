import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

class CategoryRepository {
  const CategoryRepository._();

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

  static Future<PaginatedResponse<Category>> getAll({
    required String storeId,
    int? page,
    int? size,
  }) async {
    try {
      final result = await dio.get(
        ApiEndpoints.categories,
        queryParameters: {'storeId': storeId, 'page': ?page, 'size': ?size},
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
