import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// Client repository for managing merchant alert and notification preferences.
abstract final class MerchantSettingsRepository {
  /// Fetches settings for the authenticated merchant, or null if unauthenticated.
  static Future<MerchantSettings?> getSettings() async {
    try {
      final result = await dio.get('/v1/merchants/settings');
      if (result.statusCode == 401 ||
          result.data == null ||
          result.data['data'] == null ||
          result.data['data']['settings'] == null) {
        return null;
      }

      return MerchantSettings.fromJson(
        result.data['data']['settings'] as Map<String, Object?>,
      );
    } on DioException {
      return null;
    }
  }

  /// Updates notification preferences for the authenticated merchant.
  static Future<MerchantSettings> updateSettings({
    bool? waNotifications,
    bool? lowStockAlerts,
    bool? dailyReports,
  }) async {
    try {
      final result = await dio.patch(
        '/v1/merchants/settings',
        data: {
          'waNotifications': ?waNotifications,
          'lowStockAlerts': ?lowStockAlerts,
          'dailyReports': ?dailyReports,
        },
      );

      return MerchantSettings.fromJson(
        result.data['data']['settings'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to update settings.');
    }
  }
}
