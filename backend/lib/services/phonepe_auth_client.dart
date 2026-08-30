import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// Client for handling PhonePe OAuth 2.0 authorization tokens.
class PhonePeAuthClient {
  PhonePeAuthClient({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  /// Returns the base URL for OAuth 2.0 client credential authorization.
  String getAuthBaseUrl(PaymentGatewayEnv env) => env == PaymentGatewayEnv.prod
      ? 'https://api.phonepe.com/apis/identity-manager'
      : 'https://api-preprod.phonepe.com/apis/pg-sandbox';

  /// Generates OAuth Token (/v1/oauth/token).
  Future<String?> getAuthToken(StorePhonePeConfig config) async {
    if (config.clientId == null ||
        config.clientSecret == null ||
        config.clientVersion == null) {
      return null;
    }

    try {
      final url = '${getAuthBaseUrl(config.env)}/v1/oauth/token';
      final response = await _dio.post<Map<String, dynamic>>(
        url,
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
        data: {
          'client_id': config.clientId,
          'client_version': config.clientVersion,
          'client_secret': config.clientSecret,
          'grant_type': 'client_credentials',
        },
      );

      final data = response.data;
      if (response.statusCode == 200 && data != null) {
        return data['access_token'] as String?;
      }
    } catch (_) {}
    return null;
  }
}
