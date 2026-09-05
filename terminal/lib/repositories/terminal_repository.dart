import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:models/models.dart';
import 'package:terminal/config/secure_storage.dart';

/// Repository managing Terminal authentication across Web and Native platforms.
abstract final class TerminalAuthRepository {
  /// Authenticates a terminal by its unique [code] and [password].
  static Future<Terminal> login({
    required String code,
    required String password,
  }) async {
    try {
      final result = await dio.post(
        ApiEndpoints.terminalLogin,
        data: {'code': code, 'password': password},
      );

      final data = result.data['data'] as Map<String, dynamic>;

      if (!kIsWeb) {
        final accessToken = data['accessToken'] as String?;
        if (accessToken != null) {
          await SecureStorage.saveAccessToken(accessToken);
        }
      }

      final terminal = Terminal.fromJson(data['terminal']);
      return terminal;
    } on DioException catch (e) {
      handleDioError(e, 'Login failed.');
    }
  }

  /// Fetches the currently authenticated terminal profile.
  static Future<Terminal?> getTerminal() async {
    if (!kIsWeb) {
      final token = await SecureStorage.getAccessToken();
      if (token == null) return null;
    }

    try {
      final result = await dio.get(ApiEndpoints.terminals);

      if (result.statusCode == 401 ||
          result.data == null ||
          result.data['data'] == null ||
          result.data['data']['terminal'] == null) {
        return null;
      }

      final data = result.data['data'] as Map<String, dynamic>;
      return Terminal.fromJson(data['terminal']);
    } on DioException {
      return null;
    }
  }

  /// Fetches the authenticated terminal account and store details.
  static Future<TerminalAccount?> getTerminalAccount() async {
    if (!kIsWeb) {
      final token = await SecureStorage.getAccessToken();
      if (token == null) return null;
    }

    try {
      final result = await dio.get(ApiEndpoints.terminals);

      if (result.statusCode == 401 ||
          result.data == null ||
          result.data['data'] == null) {
        return null;
      }

      final data = result.data['data'] as Map<String, dynamic>;
      return TerminalAccount.fromJson(data);
    } on DioException {
      return null;
    }
  }

  /// Logs out the terminal session, clearing browser cookies on web or secure storage on native.
  static Future<void> logout() async {
    if (kIsWeb) {
      try {
        await dio.get(ApiEndpoints.logout);
      } on DioException catch (e) {
        handleDioError(e, 'Logout failed.');
      }
    } else {
      await SecureStorage.deleteAccessToken();
    }
  }
}
