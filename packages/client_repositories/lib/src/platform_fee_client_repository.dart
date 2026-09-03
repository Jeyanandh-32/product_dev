import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// Client repository handling merchant platform fee summary and settlements.
abstract final class PlatformFeeClientRepository {
  /// Fetches the platform fee summary for the logged-in merchant.
  static Future<MerchantPlatformFeeSummary> getSummary() async {
    try {
      final result = await dio.get(ApiEndpoints.merchantPlatformFees);
      final rawData = result.data['data'] as Map;
      return MerchantPlatformFeeSummary.fromJson(
        Map<String, dynamic>.from(rawData),
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch platform fee summary.');
    }
  }

  /// Initiates PhonePe payment session to clear unsettled platform fees.
  static Future<String> initiatePayment() async {
    try {
      final result = await dio.post(
        ApiEndpoints.merchantPlatformFeesInitiatePayment,
      );
      final rawData = result.data['data'] as Map;
      final tokenUrl = rawData['tokenUrl'] as String?;
      if (tokenUrl == null || tokenUrl.isEmpty) {
        throw Exception('Payment token URL not received from gateway.');
      }
      return tokenUrl;
    } on DioException catch (e) {
      handleDioError(e, 'Failed to initiate platform fee payment.');
    }
  }

  /// Verifies pending platform fee settlements with PhonePe and returns updated summary.
  static Future<MerchantPlatformFeeSummary> verifyPayment() async {
    try {
      final result = await dio.post(
        ApiEndpoints.merchantPlatformFeesVerifyPayment,
      );
      final rawData = result.data['data'] as Map;
      return MerchantPlatformFeeSummary.fromJson(
        Map<String, dynamic>.from(rawData),
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to verify platform fee payment.');
    }
  }
}
