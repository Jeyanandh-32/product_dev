import 'package:dio/dio.dart';
import 'package:merchant/config/api_client.dart';
import 'package:models/models.dart';

class AuthRepository {
  const AuthRepository._();

  static Never _handleDioError(DioException e, String defaultMessage) {
    final data = e.response?.data;
    final message = (data is Map ? data['message'] as String? : null) ?? defaultMessage;
    throw ApiException(message);
  }

  static Future<Merchant?> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await ApiClient.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      return Merchant.fromJson(result.data['data']['merchant']);
    } on DioException catch (e) {
      _handleDioError(e, 'Login failed.');
    }
  }

  static Future<Merchant> register({
    required String name,
    required String businessName,
    required String whatsappNumber,
    required String email,
    required String password,
  }) async {
    try {
      final result = await ApiClient.dio.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'businessName': businessName,
          'whatsappNumber': whatsappNumber,
          'email': email,
          'password': password,
        },
      );
      return Merchant.fromJson(result.data['data']['merchant']);
    } on DioException catch (e) {
      _handleDioError(e, 'Register failed.');
    }
  }

  static Future<void> logout() async {
    try {
      await ApiClient.dio.get(ApiEndpoints.logout);
    } on DioException catch (e) {
      _handleDioError(e, 'Logout failed.');
    }
  }
}

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;
}
