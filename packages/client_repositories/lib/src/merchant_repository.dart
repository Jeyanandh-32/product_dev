import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

abstract final class MerchantRepository {
  static Future<Merchant?> getMerchant() async {
    try {
      final result = await dio.get(ApiEndpoints.merchants);
      if (result.statusCode == 401 ||
          result.data == null ||
          result.data['data'] == null ||
          result.data['data']['merchant'] == null) {
        return null;
      }

      return Merchant.fromJson(
        result.data['data']['merchant'] as Map<String, Object?>,
      );
    } on DioException {
      return null;
    }
  }

  static Future<Merchant> updateMerchant({
    String? name,
    String? businessName,
    String? whatsappNumber,
    String? email,
    String? currentPassword,
    String? newPassword,
  }) async {
    try {
      final result = await dio.patch(
        ApiEndpoints.merchants,
        data: {
          'name': ?name,
          'businessName': ?businessName,
          'whatsappNumber': ?whatsappNumber,
          'email': ?email,
          'currentPassword': ?currentPassword,
          'newPassword': ?newPassword,
        },
      );

      return Merchant.fromJson(
        result.data['data']['merchant'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to update profile.');
    }
  }
}
