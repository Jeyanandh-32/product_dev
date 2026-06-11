import 'package:dio/dio.dart';
import 'package:merchant/config/api_client.dart';
import 'package:models/models.dart';

class CategoryRepository {
  const CategoryRepository._();

  static Future<Category> create({
    required String storeId,
    required String name,
  }) async {
    try {
      final result = await ApiClient.dio.post(
        ApiEndpoints.categories,
        queryParameters: {'storeId': storeId},
        data: {
          'name': name,
        },
      );

      return Category.fromJson(
        result.data['data']['category'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      ApiClient.handleDioError(e, 'Failed to create category.');
    }
  }

  static Future<Category> update({
    required String id,
    String? name,
    bool? isActive,
  }) async {
    try {
      final path = '${ApiEndpoints.categories}/$id';
      final result = await ApiClient.dio.patch(
        path,
        data: {
          if (name != null) 'name': name,
          if (isActive != null) 'isActive': isActive,
        },
      );

      return Category.fromJson(
        result.data['data']['category'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      ApiClient.handleDioError(e, 'Failed to update category.');
    }
  }

  static Future<List<Category>> getAll({String? storeId}) async {
    try {
      final result = await ApiClient.dio.get(
        ApiEndpoints.categories,
        queryParameters: {
          if (storeId != null) 'storeId': storeId,
        },
      );

      final list = result.data['data']['categories'] as List<dynamic>;

      return list
          .map((s) => Category.fromJson(s as Map<String, Object?>))
          .toList();
    } on DioException catch (e) {
      ApiClient.handleDioError(e, 'Failed to fetch categories.');
    }
  }
}
