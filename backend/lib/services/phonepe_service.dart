import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

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

  String getBaseUrl(PaymentGatewayEnv env) {
    return env == PaymentGatewayEnv.prod
        ? 'https://api.phonepe.com/apis/pg'
        : 'https://api-preprod.phonepe.com/apis/pg-sandbox';
  }

  String getAuthBaseUrl(PaymentGatewayEnv env) {
    return env == PaymentGatewayEnv.prod
        ? 'https://api.phonepe.com/apis/identity-manager'
        : 'https://api-preprod.phonepe.com/apis/pg-sandbox';
  }

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
    } catch (_) {
      // Fallback to legacy checksum header if OAuth token is not configured
    }
    return null;
  }

  /// Step 2: Build Payment Mode Config (V2 Schema)
  Map<String, dynamic>? _buildPaymentModeConfig(StorePhonePeConfig config) {
    final enabledModes = <Map<String, dynamic>>[];
    final disabledModes = <Map<String, dynamic>>[];

    // UPI
    if (config.enableUpi) {
      final upiObj = <String, dynamic>{'type': 'UPI'};
      if (config.allowedUpiApps != null &&
          config.allowedUpiApps!.trim().isNotEmpty) {
        final apps = config.allowedUpiApps!
            .split(',')
            .map((e) => e.trim().toLowerCase())
            .where((e) => e.isNotEmpty)
            .toList();
        if (apps.isNotEmpty) {
          upiObj['apps'] = apps;
        }
      }
      enabledModes.add(upiObj);
    } else {
      disabledModes.add({'type': 'UPI'});
    }

    // Cards
    if (config.enableCards) {
      enabledModes.add({'type': 'CARD'});
    } else {
      disabledModes.add({'type': 'CARD'});
    }

    // Net Banking
    if (config.enableNetBanking) {
      enabledModes.add({'type': 'NET_BANKING'});
    } else {
      disabledModes.add({'type': 'NET_BANKING'});
    }

    // EMI
    if (config.enableEmi) {
      enabledModes.add({'type': 'EMI'});
    } else {
      disabledModes.add({'type': 'EMI'});
    }

    // Wallet
    if (config.enableWallets) {
      enabledModes.add({'type': 'WALLET'});
    } else {
      disabledModes.add({'type': 'WALLET'});
    }

    if (enabledModes.isEmpty && disabledModes.isEmpty) return null;

    final result = <String, dynamic>{'version': 'V2'};
    if (enabledModes.isNotEmpty) {
      result['enabledPaymentModes'] = enabledModes;
    } else if (disabledModes.isNotEmpty) {
      result['disabledPaymentModes'] = disabledModes;
    }
    return result;
  }

  /// Step 3: Initiate Payment (/checkout/v2/pay)
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

    final paymentModeConfig = _buildPaymentModeConfig(config);

    final payload = <String, dynamic>{
      'merchantOrderId': merchantOrderId,
      'amount': amountInPaisa,
      'expireAfter': 1200,
      'paymentFlow': {
        'type': 'PG_CHECKOUT',
        'merchantUrls': {'redirectUrl': redirectUrl},
        if (paymentModeConfig != null) 'paymentModeConfig': paymentModeConfig,
      },
      if (customerPhone != null && customerPhone.isNotEmpty)
        'prefillUserLoginDetails': {'phoneNumber': customerPhone},
      if (customerName != null || customerEmail != null || customerPhone != null)
        'customerDetails': {
          if (customerName != null) 'name': customerName,
          if (customerEmail != null) 'email': customerEmail,
          if (customerPhone != null) 'phoneNumber': customerPhone,
        },
      'metaInfo': {
        if (storeId != null) 'udf1': storeId,
        if (customerId != null) 'udf2': customerId,
      },
    };

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'O-Bearer $token';
    }

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

  /// Step 4: Check Order Status (/checkout/v2/order/{merchantOrderId}/status)
  Future<Map<String, dynamic>> checkOrderStatus({
    required StorePhonePeConfig config,
    required String merchantOrderId,
  }) async {
    final url =
        '${getBaseUrl(config.env)}/checkout/v2/order/$merchantOrderId/status?details=false&errorContext=true';
    final token = await getAuthToken(config);

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'O-Bearer $token';
    }

    final response = await _dio.get<Map<String, dynamic>>(url, options: Options(headers: headers));
    return response.data ?? {};
  }

  /// Step 5: Verify Webhook HMAC Signature
  bool verifyWebhookHmac({
    required String rawRequestBody,
    required String signatureHeader,
    required String secretKey,
  }) {
    if (signatureHeader.isEmpty || secretKey.isEmpty) return false;
    final hmac = Hmac(sha256, utf8.encode(secretKey));
    final digest = hmac.convert(utf8.encode(rawRequestBody));
    final computedSignature = digest.toString();
    return computedSignature == signatureHeader;
  }
}
