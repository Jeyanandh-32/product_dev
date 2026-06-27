import 'package:dio/dio.dart';
import 'package:terminal/config/api_client.dart';

class TerminalRepository {
  const TerminalRepository._();

  static Future<Map<String, dynamic>?> login({
    required String code,
    required String password,
  }) async {
    try {
      final result = await ApiClient.dio.post(
        ApiEndpoints.login,
        data: {'code': code, 'password': password},
      );

      final data = result.data['data'] as Map<String, dynamic>;

      // Dynamically attach the bearer token for subsequent requests
      final accessToken = data['accessToken'] as String;
      ApiClient.dio.options.headers['Authorization'] = 'Bearer $accessToken';

      return data;
    } on DioException catch (e) {
      ApiClient.handleDioError(e, 'Login failed.');
    }
  }
}