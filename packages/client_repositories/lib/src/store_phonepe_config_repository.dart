import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// Client repository handling store PhonePe payment gateway configuration.
abstract final class StorePhonePeConfigRepository {
  /// Fetches PhonePe configuration details for a store.
  static Future<StorePhonePeConfig?> getConfig(String storeId) async {
    try {
      final path = ApiEndpoints.storePhonePeConfig(storeId);
      final result = await dio.get(path);

      final data = result.data['data'] as Map<String, dynamic>;
      if (data['config'] == null) return null;

      return StorePhonePeConfig.fromJson(
        data['config'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch PhonePe config.');
    }
  }

  /// Saves or updates PhonePe gateway settings for a store.
  static Future<StorePhonePeConfig> saveConfig({
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
      return StorePhonePeConfig.fromJson(
        data['config'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to save PhonePe config.');
    }
  }
}
