import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

abstract final class StoreRepository {
  static Future<Store> create({
    required String name,
    StoreType? storeType,
    bool? isOnlineEnabled,
    String? slug,
  }) async {
    try {
      final result = await dio.post(
        ApiEndpoints.stores,
        data: {
          'name': name,
          'storeType': ?storeType?.name,
          'isOnlineEnabled': ?isOnlineEnabled,
          'slug': ?slug,
        },
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
    StoreType? storeType,
    bool? isActive,
    bool? isOnlineEnabled,
    String? slug,
  }) async {
    try {
      final path = '${ApiEndpoints.stores}/$id';
      final result = await dio.patch(
        path,
        data: {
          'name': ?name,
          'storeType': ?storeType?.name,
          'isActive': ?isActive,
          'isOnlineEnabled': ?isOnlineEnabled,
          'slug': ?slug,
        },
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

  static Future<List<Store>> getOnlineStores() async {
    try {
      final path = '${ApiEndpoints.stores}/online';
      final result = await dio.get(path);

      final list = result.data['data']['stores'] as List<dynamic>;

      return list
          .map((s) => Store.fromJson(s as Map<String, Object?>))
          .toList();
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch online stores.');
    }
  }

  static Future<Store?> getBySlug(String slug) async {
    try {
      final path = '${ApiEndpoints.stores}/online';
      final result = await dio.get(path, queryParameters: {'slug': slug});

      final data = result.data['data'] as Map<String, dynamic>;
      if (data['store'] == null) return null;

      return Store.fromJson(data['store'] as Map<String, Object?>);
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch store by slug.');
    }
  }

  static Future<StorePhonePeConfig?> getPhonePeConfig(String storeId) async {
    try {
      final path = ApiEndpoints.storePhonePeConfig(storeId);
      final result = await dio.get(path);

      final data = result.data['data'] as Map<String, dynamic>;
      if (data['config'] == null) return null;

      return StorePhonePeConfig.fromJson(data['config'] as Map<String, Object?>);
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch PhonePe config.');
    }
  }

  static Future<StorePhonePeConfig> savePhonePeConfig({
    required String storeId,
    required String merchantId,
    bool isEnabled = true,
    String env = 'UAT',
    String? clientId,
    String? clientVersion,
    String? clientSecret,
    String? saltKey,
    int? saltIndex,
    bool enableUpi = true,
    bool enableCards = true,
    bool enableNetBanking = true,
    bool enableEmi = true,
    bool enableWallets = true,
    String? allowedUpiApps,
    String webhookAuthType = 'HMAC',
    String? webhookSecretKey,
  }) async {
    try {
      final path = ApiEndpoints.storePhonePeConfig(storeId);
      final result = await dio.put(
        path,
        data: {
          'merchantId': merchantId,
          'isEnabled': isEnabled,
          'env': env,
          'clientId': ?clientId,
          'clientVersion': ?clientVersion,
          'clientSecret': ?clientSecret,
          'saltKey': ?saltKey,
          'saltIndex': ?saltIndex,
          'enableUpi': enableUpi,
          'enableCards': enableCards,
          'enableNetBanking': enableNetBanking,
          'enableEmi': enableEmi,
          'enableWallets': enableWallets,
          'allowedUpiApps': ?allowedUpiApps,
          'webhookAuthType': webhookAuthType,
          'webhookSecretKey': ?webhookSecretKey,
        },
      );

      final data = result.data['data'] as Map<String, dynamic>;
      return StorePhonePeConfig.fromJson(data['config'] as Map<String, Object?>);
    } on DioException catch (e) {
      handleDioError(e, 'Failed to save PhonePe config.');
    }
  }
}
