import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:web/web.dart' as web;

void initMerchantDio() {
  const envUrl = String.fromEnvironment('API_BASE_URL');

  String baseUrl;
  if (envUrl.isNotEmpty) {
    baseUrl = envUrl;
  } else {
    final hostname = web.window.location.hostname;
    baseUrl = 'http://${hostname.isEmpty ? 'localhost' : hostname}:8080';
  }

  initDio(
    Dio(
      BaseOptions(
        baseUrl: baseUrl,
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
