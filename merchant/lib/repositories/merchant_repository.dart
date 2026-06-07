import 'package:merchant/config/api_client.dart';
import 'package:models/models.dart';

class MerchantRepository {
  const MerchantRepository._();

  static Future<Merchant?> getMerchant() async {
    final result = await ApiClient.dio.get(ApiEndpoints.merchants);

    return Merchant.fromJson(result.data['data']['merchant']);
  }
}
