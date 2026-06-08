import 'package:dio/dio.dart';
import 'package:merchant/config/api_client.dart';
import 'package:merchant/repositories/auth_repository.dart';
import 'package:models/models.dart';

class StoreRepository {
  const StoreRepository._();

  static Never _handleDioError(DioException e, String defaultMessage) {
    final data = e.response?.data;
    final message = (data is Map ? data['message'] as String? : null) ?? defaultMessage;
    throw ApiException(message);
  }

  static Future<Store> create({required String name, String? storeType}) async {
    try {
      final result = await ApiClient.dio.post(
        ApiEndpoints.stores,
        data: {
          'name': name,
          if (storeType != null) 'storeType': storeType,
        },
      );

      return Store.fromJson(result.data['data']['store'] as Map<String, Object?>);
    } on DioException catch (e) {
      _handleDioError(e, 'Failed to create store.');
    }
  }

  static Future<Store> update({
    required String id,
    String? name,
    String? storeType,
  }) async {
    try {
      final path = '${ApiEndpoints.stores}/$id';
      final result = await ApiClient.dio.patch(
        path,
        data: {
          if (name != null) 'name': name,
          if (storeType != null) 'storeType': storeType,
        },
      );

      return Store.fromJson(result.data['data']['store'] as Map<String, Object?>);
    } on DioException catch (e) {
      _handleDioError(e, 'Failed to update store.');
    }
  }

  static Future<List<Store>> getAll() async {
    try {
      final result = await ApiClient.dio.get(ApiEndpoints.stores);

      final list = result.data['data']['stores'] as List<dynamic>;

      return list.map((s) => Store.fromJson(s as Map<String, Object?>)).toList();
    } on DioException catch (e) {
      _handleDioError(e, 'Failed to fetch stores.');
    }
  }
}
