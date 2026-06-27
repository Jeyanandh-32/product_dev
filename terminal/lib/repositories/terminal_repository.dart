import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:terminal/config/api_client.dart';
import 'package:terminal/config/secure_storage.dart';

class TerminalRepository {
  const TerminalRepository._();

  static Future<Terminal> login({
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

      await SecureStorage.saveAccessToken(accessToken);

      final terminal = Terminal.fromJson(data['terminal']);
      return terminal;
    } on DioException catch (e) {
      ApiClient.handleDioError(e, 'Login failed.');
    }
  }

  static Future<Terminal?> getTerminal() async {
    final token = await SecureStorage.getAccessToken();
    if (token == null) return null;

    try {
      final result = await ApiClient.dio.get(
        ApiEndpoints.terminals,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = result.data['data'] as Map<String, dynamic>;
      return Terminal.fromJson(data['terminal']);
    } on DioException {
      return null;
    }
  }
}
