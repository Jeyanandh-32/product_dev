import 'package:api_client/api_client.dart';
import 'package:client_repositories/src/order_response_types.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// Helper client repository handling online checkout initiation and status verification.
abstract final class OrderOnlineCheckoutHelper {
  /// Initiates an online checkout session via PhonePe payment gateway or store wallet.
  static Future<OnlinePaymentInitiationResult> initiateOnlinePayment({
    required String storeId,
    required List<Map<String, dynamic>> products,
    double? discountTotal,
    bool? useWallet,
  }) async {
    try {
      final result = await dio.post(
        '/v1/orders/initiate-online-payment',
        queryParameters: {'storeId': storeId},
        data: {
          'products': products,
          'discountTotal': ?discountTotal,
          'useWallet': ?useWallet,
        },
      );

      final data = result.data['data'] as Map<String, dynamic>;
      final order = Order.fromJson(data['order'] as Map<String, Object?>);
      final tokenUrl = data['tokenUrl'] as String?;
      final merchantOrderId = data['merchantOrderId'] as String;
      final isFullyPaidByWallet = data['isFullyPaidByWallet'] as bool? ?? false;

      return (
        order: order,
        tokenUrl: tokenUrl,
        merchantOrderId: merchantOrderId,
        isFullyPaidByWallet: isFullyPaidByWallet,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to initiate online payment.');
    }
  }

  /// Verifies status of a pending order payment.
  static Future<Order> verifyStatus({required String reference}) async {
    try {
      final result = await dio.get(
        '/v1/orders/verify-status',
        queryParameters: {'reference': reference},
      );
      final data = result.data['data'] as Map<String, dynamic>;
      return Order.fromJson(data['order'] as Map<String, Object?>);
    } on DioException catch (e) {
      handleDioError(e, 'Failed to verify order status.');
    }
  }
}
