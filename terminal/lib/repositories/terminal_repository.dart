import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:terminal/config/api_client.dart';

class TerminalRepository {
  const TerminalRepository._();

  static Future<(Terminal, String)> login({
    required String code,
    required String password,
  }) async {
    try {
      final result = await ApiClient.dio.post(
        ApiEndpoints.login,
        data: {'code': code, 'password': password},
      );

      final data = result.data['data'] as Map<String, dynamic>;

      final accessToken = data['accessToken'] as String;

      final terminal = Terminal.fromJson(data['terminal']);
      return (terminal, accessToken);
    } on DioException catch (e) {
      ApiClient.handleDioError(e, 'Login failed.');
    }
  }
}
