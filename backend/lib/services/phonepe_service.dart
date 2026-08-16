import 'package:backend/services/phonepe_payload_builder.dart';
import 'package:backend/services/phonepe_security_helper.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// Integration service for PhonePe Payment Gateway (OAuth 2.0 & PG V2 Standard Checkout).
class PhonePeService {
  PhonePeService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            );

  final Dio _dio;

  /// Returns the base URL for standard PG checkout API.
  String getBaseUrl(PaymentGatewayEnv env) =>
      env == PaymentGatewayEnv.prod
          ? 'https://api.phonepe.com/apis/pg'
          : 'https://api-preprod.phonepe.com/apis/pg-sandbox';

  /// Returns the base URL for OAuth 2.0 client credential authorization.
  String getAuthBaseUrl(PaymentGatewayEnv env) =>
      env == PaymentGatewayEnv.prod
          ? 'https://api.phonepe.com/apis/identity-manager'
          : 'https://api-preprod.phonepe.com/apis/pg-sandbox';

  /// Step 1: Generate OAuth Token (/v1/oauth/token)
  Future<String?> getAuthToken(StorePhonePeConfig config) async {
    if (config.clientId == null ||
        config.clientSecret == null ||
        config.clientVersion == null) {
      return null;
    }

    try {
      final url = '${getAuthBaseUrl(config.env)}/v1/oauth/token';
      final response = await _dio.post<Map<String, dynamic>>(
        url,
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
        data: {
          'client_id': config.clientId,
          'client_version': config.clientVersion,
          'client_secret': config.clientSecret,
          'grant_type': 'client_credentials',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!;
        return data['access_token'] as String?;
      }
    } catch (_) {}
    return null;
  }

  /// Step 2: Initiate Payment Session (/checkout/v2/pay)
  Future<({String tokenUrl, String orderId})> initiatePayment({
    required StorePhonePeConfig config,
    required String merchantOrderId,
    required int amountInPaisa,
    required String redirectUrl,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? storeId,
    String? customerId,
  }) async {
    final url = '${getBaseUrl(config.env)}/checkout/v2/pay';
    final token = await getAuthToken(config);
    final payload = PhonePePayloadBuilder.buildCheckoutPayload(
      config: config,
      merchantOrderId: merchantOrderId,
      amountInPaisa: amountInPaisa,
      redirectUrl: redirectUrl,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      storeId: storeId,
      customerId: customerId,
    );

    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'O-Bearer $token',
    };

    final response = await _dio.post<Map<String, dynamic>>(
      url,
      options: Options(headers: headers),
      data: payload,
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data!;
      final innerData = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : null;
      final redirectUrlStr = (data['redirectUrl'] as String?) ??
          (innerData?['redirectUrl'] as String?);
      final orderIdStr = (data['orderId'] as String?) ??
          (innerData?['orderId'] as String?) ??
          '';

      if (redirectUrlStr != null && redirectUrlStr.isNotEmpty) {
        return (tokenUrl: redirectUrlStr, orderId: orderIdStr);
      }
    }

    throw Exception('Failed to initiate PhonePe payment session: ${response.data}');
  }

  /// Step 3: Check Order Status (/checkout/v2/order/{merchantOrderId}/status)
  Future<Map<String, dynamic>> checkOrderStatus({
    required StorePhonePeConfig config,
    required String merchantOrderId,
  }) async {
    final url =
        '${getBaseUrl(config.env)}/checkout/v2/order/$merchantOrderId/status?details=false&errorContext=true';
    final token = await getAuthToken(config);

    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'O-Bearer $token',
    };

    final response = await _dio.get<Map<String, dynamic>>(url, options: Options(headers: headers));
    return response.data ?? {};
  }

  /// Step 4: Verify Webhook HMAC Signature
  bool verifyWebhookHmac({
    required String rawRequestBody,
    required String signatureHeader,
    required String secretKey,
  }) =>
      PhonePeSecurityHelper.verifyWebhookHmac(
        rawRequestBody: rawRequestBody,
        signatureHeader: signatureHeader,
        secretKey: secretKey,
      );
}
