import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

abstract final class StoreRepository {
  static Future<Store> create({required String name, String? storeType}) async {
    try {
      final result = await dio.post(
        ApiEndpoints.stores,
        data: {'name': name, 'storeType': ?storeType},
      );

      return Store.fromJson(
        result.data['data']['store'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to create store.');
    }
  }

  static Future<Store> update({
    required String id,
    String? name,
    String? storeType,
    bool? isActive,
  }) async {
    try {
      final path = '${ApiEndpoints.stores}/$id';
      final result = await dio.patch(
        path,
        data: {'name': ?name, 'storeType': ?storeType, 'isActive': ?isActive},
      );

      return Store.fromJson(
        result.data['data']['store'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to update store.');
    }
  }

  static Future<List<Store>> getAll() async {
    try {
      final result = await dio.get(ApiEndpoints.stores);

      final list = result.data['data']['stores'] as List<dynamic>;

      return list
          .map((s) => Store.fromJson(s as Map<String, Object?>))
          .toList();
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch stores.');
    }
  }
}
