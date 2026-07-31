import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

abstract final class MerchantRepository {
  static Future<Merchant?> getMerchant() async {
    try {
      final result = await dio.get(ApiEndpoints.merchants);

      return Merchant.fromJson(
        result.data['data']['merchant'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch merchant info.');
    }
  }
}
