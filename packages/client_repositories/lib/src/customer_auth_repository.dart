import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// Client repository for customer authentication, registration, profile, and recent stores.
class CustomerAuthRepository {
  const CustomerAuthRepository._();

  /// Logs in a customer with their mobile number and PIN.
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

  /// Registers a new customer account.
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

  /// Fetches the currently authenticated customer profile, or null if unauthenticated.
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

  /// Updates profile details for the authenticated customer.
  static Future<Customer> updateProfile({
    String? name,
    String? mobileNumber,
    String? pin,
    String? currentPin,
  }) async {
    try {
      final result = await dio.patch(
        ApiEndpoints.customers,
        data: {
          'name': ?name,
          'mobileNumber': ?mobileNumber,
          'pin': ?pin,
          'currentPin': ?currentPin,
        },
      );

      final data = result.data['data'] as Map<String, dynamic>;
      return Customer.fromJson(data['customer'] as Map<String, Object?>);
    } on DioException catch (e) {
      handleDioError(e, 'Failed to update profile.');
    }
  }

  /// Fetches stores recently visited or ordered from by the customer.
  static Future<List<Store>> getRecentStores() async {
    try {
      final result = await dio.get(ApiEndpoints.customerRecentStores);
      if (result.statusCode == 401 ||
          result.data == null ||
          result.data['data'] == null ||
          result.data['data']['stores'] == null) {
        return [];
      }

      final list = result.data['data']['stores'] as List<dynamic>;
      return list
          .map((s) => Store.fromJson(s as Map<String, Object?>))
          .toList();
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch recent stores.');
    }
  }

  /// Terminates the active customer session.
  static Future<void> logout() async {
    try {
      await dio.get(ApiEndpoints.logout);
    } on DioException catch (e) {
      handleDioError(e, 'Logout failed.');
    }
  }

  /// Records that the customer browsed or interacted with a store.
  static Future<void> recordStoreVisit(String storeId) async {
    try {
      await dio.post(
        ApiEndpoints.customerRecentStores,
        data: {'storeId': storeId},
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to record store visit.');
    }
  }
}

