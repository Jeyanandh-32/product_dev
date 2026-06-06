import 'package:dio/dio.dart';
import 'package:merchant/config/api_client.dart';
import 'package:models/models.dart';

class AuthRepository {
  const AuthRepository._();

  static Future<Merchant?> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await ApiClient.dio.post(
        '/v1/auth/merchant/login',
        data: {'email': email, 'password': password},
      );
      return Merchant.fromJson(result.data['data']['merchant']);
    } on DioException catch (e) {
      final message = e.response?.data['message'] as String? ?? 'Login failed.';
      throw ApiException(message);
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
        '/v1/auth/merchant/register',
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
      final message = e.response?.data['message'] as String? ?? 'Register failed.';
      throw ApiException(message);
    }
  }

  static Future<void> logout() async {
    try {
      await ApiClient.dio.get('/v1/auth/logout');
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] as String? ?? 'Logout failed.';

      throw ApiException(message);
    }
  }
}

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;
}
