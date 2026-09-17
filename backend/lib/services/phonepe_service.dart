import 'package:backend/services/phonepe_auth_client.dart';
import 'package:backend/services/phonepe_payload_builder.dart';
import 'package:backend/services/phonepe_security_helper.dart';
import 'package:backend/services/phonepe_v1_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// Integration service for PhonePe Payment Gateway (OAuth 2.0 & PG V2 Standard Checkout).
class PhonePeService {
  PhonePeService({
    Dio? dio,
    PhonePeAuthClient? authClient,
    PhonePeV1Client? v1Client,
  }) : _dio = dio ?? _defaultDio(),
       _authClient = authClient ?? PhonePeAuthClient(dio: dio),
       _v1Client = v1Client ?? PhonePeV1Client(dio: dio);

  static Dio _defaultDio() => Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: const {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ),
  );

  final Dio _dio;
  final PhonePeAuthClient _authClient;
  final PhonePeV1Client _v1Client;

  /// Returns the base URL for standard PG checkout API.
  String getBaseUrl(PaymentGatewayEnv env) => env == PaymentGatewayEnv.prod
      ? 'https://api.phonepe.com/apis/pg'
      : 'https://api-preprod.phonepe.com/apis/pg-sandbox';

  /// Step 1: Generate OAuth Token (/v1/oauth/token)
  Future<String?> getAuthToken(StorePhonePeConfig config) =>
      _authClient.getAuthToken(config);

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
    final secret = config.clientSecret;
    if (secret == null || secret.isEmpty) {
      return _v1Client.initiatePayment(
        config: config,
        merchantOrderId: merchantOrderId,
        amountInPaisa: amountInPaisa,
        redirectUrl: redirectUrl,
        storeId: storeId,
        customerId: customerId,
      );
    }

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

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        url,
        options: Options(headers: headers),
        data: payload,
      );
      final data = response.data;
      if (response.statusCode == 200 && data != null) {
        final inner = data['data'] as Map<String, dynamic>?;
        final redirectUrlStr = (data['redirectUrl'] ?? inner?['redirectUrl']) as String?;
        final orderIdStr = ((data['orderId'] ?? inner?['orderId']) as String?) ?? '';
        if (redirectUrlStr != null && redirectUrlStr.isNotEmpty) {
          return (tokenUrl: redirectUrlStr, orderId: orderIdStr);
        }
      }
      throw Exception('Failed to initiate PhonePe payment session: $data');
    } on DioException catch (e) {
      final err = e.response?.data;
      final msg = err is Map
          ? (err['message'] ?? err['error'] ?? e.message)
          : (err is String && err.trim().isNotEmpty ? err.trim() : (e.message ?? 'Unknown gateway error'));
      throw Exception('PhonePe gateway error: $msg');
    }
  }

  /// Step 3: Check Order Status (/checkout/v2/order/{merchantOrderId}/status)
  Future<Map<String, dynamic>> checkOrderStatus({
    required StorePhonePeConfig config,
    required String merchantOrderId,
  }) async {
    final secret = config.clientSecret;
    if (secret == null || secret.isEmpty) {
      return _v1Client.checkOrderStatus(
        config: config,
        merchantOrderId: merchantOrderId,
      );
    }

    final url =
        '${getBaseUrl(config.env)}/checkout/v2/order/$merchantOrderId/status?details=false&errorContext=true';
    final token = await getAuthToken(config);
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'O-Bearer $token',
    };

    final response = await _dio.get<Map<String, dynamic>>(
      url,
      options: Options(headers: headers),
    );
    return response.data ?? {};
  }

  /// Step 4: Verify Webhook HMAC Signature
  bool verifyWebhookHmac({
    required String rawRequestBody,
    required String signatureHeader,
    required String secretKey,
  }) => PhonePeSecurityHelper.verifyWebhookHmac(
    rawRequestBody: rawRequestBody,
    signatureHeader: signatureHeader,
    secretKey: secretKey,
  );
}
