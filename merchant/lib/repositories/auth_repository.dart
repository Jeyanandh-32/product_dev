import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

class AuthRepository {
  const AuthRepository._();

  static Future<Merchant?> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await dio.post(
        ApiEndpoints.merchantLogin,
        data: {'email': email, 'password': password},
      );
      return Merchant.fromJson(result.data['data']['merchant']);
    } on DioException catch (e) {
      handleDioError(e, 'Login failed.');
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
      final result = await dio.post(
        ApiEndpoints.merchantRegister,
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
      handleDioError(e, 'Register failed.');
    }
  }

  static Future<void> logout() async {
    try {
      await dio.get(ApiEndpoints.logout);
    } on DioException catch (e) {
      handleDioError(e, 'Logout failed.');
    }
  }
}
