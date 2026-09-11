import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:web/web.dart' as web;

/// Resolves the backend API base URL for the Merchant web application.
String resolveMerchantApiBaseUrl() {
  const envUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: String.fromEnvironment('API_URL'),
  );

  if (envUrl.isNotEmpty) {
    return envUrl.replaceAll(RegExp(r'/+$'), '');
  }

  try {
    final hostname = web.window.location.hostname;
    final isIp = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$')
        .hasMatch(hostname);
    if (hostname.isEmpty || hostname == 'localhost' || isIp) {
      return 'http://${hostname.isEmpty ? 'localhost' : hostname}:8080';
    }

    if (hostname.contains('stage')) {
      return 'https://api.finch-stage.sparrow-x.in';
    }

    return 'https://api.finch.sparrow-x.in';
  } catch (_) {
    return 'http://localhost:8080';
  }
}

/// Initializes the global Dio HTTP client for the Merchant web application.
void initMerchantDio() {
  initDio(
    Dio(
      BaseOptions(
        baseUrl: resolveMerchantApiBaseUrl(),
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        extra: {'withCredentials': true},
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) =>
            status != null &&
            ((status >= 200 && status < 300) || status == 401),
      ),
    ),
  );
}
