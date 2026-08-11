import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

class CustomerAuthRepository {
  const CustomerAuthRepository._();

  static Future<Customer> login({
    required String mobileNumber,
    required String pin,
  }) async {
    try {
      final result = await dio.post(
        ApiEndpoints.customerLogin,
        data: {'mobileNumber': mobileNumber, 'pin': pin},
      );

      final data = result.data['data'] as Map<String, dynamic>;
      return Customer.fromJson(data['customer'] as Map<String, Object?>);
    } on DioException catch (e) {
      handleDioError(e, 'Customer login failed.');
    }
  }

  static Future<Customer> register({
    required String name,
    required String mobileNumber,
    required String pin,
  }) async {
    try {
      final result = await dio.post(
        ApiEndpoints.customerRegister,
        data: {'name': name, 'mobileNumber': mobileNumber, 'pin': pin},
      );

      final data = result.data['data'] as Map<String, dynamic>;
      return Customer.fromJson(data['customer'] as Map<String, Object?>);
    } on DioException catch (e) {
      handleDioError(e, 'Customer registration failed.');
    }
  }

  static Future<Customer?> getCustomer() async {
    try {
      final result = await dio.get(ApiEndpoints.customers);
      if (result.statusCode == 401 ||
          result.data == null ||
          result.data['data'] == null ||
          result.data['data']['customer'] == null) {
        return null;
      }

      final data = result.data['data'] as Map<String, dynamic>;
      return Customer.fromJson(data['customer'] as Map<String, Object?>);
    } on DioException {
      return null;
    }
  }
}
