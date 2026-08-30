import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// Client for handling PhonePe Standard PG V1 API (SHA256 X-VERIFY).
class PhonePeV1Client {
  PhonePeV1Client({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  /// Returns base URL for V1 standard checkout.
  String getBaseUrl(PaymentGatewayEnv env) => env == PaymentGatewayEnv.prod
      ? 'https://api.phonepe.com/apis/hermes'
      : 'https://api-preprod.phonepe.com/apis/pg-sandbox';

  /// Initiates standard V1 Pay Page session.
  Future<({String tokenUrl, String orderId})> initiatePayment({
    required StorePhonePeConfig config,
    required String merchantOrderId,
    required int amountInPaisa,
    required String redirectUrl,
    String? storeId,
    String? customerId,
  }) async {
    const endpoint = '/pg/v1/pay';
    final merchantId = config.clientId ?? 'PGTESTPAYUAT';
    final saltKey = config.saltKey ?? '';
    final saltIndex = config.saltIndex;

    final jsonPayload = {
      'merchantId': merchantId,
      'merchantTransactionId': merchantOrderId,
      'merchantUserId': customerId ?? storeId ?? 'MUID_$merchantOrderId',
      'amount': amountInPaisa,
      'redirectUrl': redirectUrl,
      'redirectMode': 'REDIRECT',
      'paymentInstrument': {'type': 'PAY_PAGE'},
    };

    final base64Payload = base64Encode(utf8.encode(jsonEncode(jsonPayload)));
    final stringToHash = '$base64Payload$endpoint$saltKey';
    final sha256Hash = sha256.convert(utf8.encode(stringToHash)).toString();
    final xVerify = '$sha256Hash###$saltIndex';

    final url = '${getBaseUrl(config.env)}$endpoint';
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-VERIFY': xVerify,
          },
        ),
        data: {'request': base64Payload},
      );

      final data = response.data;
      if (response.statusCode == 200 &&
          data != null &&
          data['success'] == true) {
        final innerData = data['data'] as Map<String, dynamic>?;
        final redirectInfo =
            innerData?['instrumentResponse']?['redirectInfo']
                as Map<String, dynamic>?;
        final redirectUrlStr = redirectInfo?['url'] as String?;
        if (redirectUrlStr != null && redirectUrlStr.isNotEmpty) {
          return (tokenUrl: redirectUrlStr, orderId: merchantOrderId);
        }
      }
      throw Exception(
        'Failed to initiate PhonePe V1 payment: ${response.data}',
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;
      final errorMsg = errorData is Map
          ? (errorData['message'] ??
                errorData['error'] ??
                errorData['code'] ??
                e.message)
          : (errorData is String && errorData.trim().isNotEmpty
                ? errorData.trim()
                : (e.message ?? 'Unknown gateway error'));
      throw Exception('PhonePe gateway error: $errorMsg');
    }
  }

  /// Checks order status via V1 status API.
  Future<Map<String, dynamic>> checkOrderStatus({
    required StorePhonePeConfig config,
    required String merchantOrderId,
  }) async {
    final merchantId = config.clientId ?? 'PGTESTPAYUAT';
    final saltKey = config.saltKey ?? '';
    final saltIndex = config.saltIndex;
    final endpoint = '/pg/v1/status/$merchantId/$merchantOrderId';

    final stringToHash = '$endpoint$saltKey';
    final sha256Hash = sha256.convert(utf8.encode(stringToHash)).toString();
    final xVerify = '$sha256Hash###$saltIndex';

    final url = '${getBaseUrl(config.env)}$endpoint';
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-VERIFY': xVerify,
            'X-MERCHANT-ID': merchantId,
          },
        ),
      );
      return response.data ?? {};
    } on DioException catch (e) {
      final errorData = e.response?.data;
      final errorMsg = errorData is Map
          ? (errorData['message'] ??
                errorData['error'] ??
                errorData['code'] ??
                e.message)
          : (errorData is String && errorData.trim().isNotEmpty
                ? errorData.trim()
                : (e.message ?? 'Unknown gateway error'));
      throw Exception('PhonePe gateway error: $errorMsg');
    }
  }
}
