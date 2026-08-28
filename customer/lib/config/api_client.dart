import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:web/web.dart' as web;

/// Initializes the global Dio HTTP client for the Customer web application.
///
/// Resolves API URL via `--dart-define=API_BASE_URL=...` or `--dart-define=API_URL=...`.
/// Defaults dynamically to current browser hostname on port 8080.
void initCustomerDio() {
  const envUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: String.fromEnvironment('API_URL'),
  );

  String baseUrl;
  if (envUrl.isNotEmpty) {
    baseUrl = envUrl.replaceAll(RegExp(r'/+$'), '');
  } else {
    final origin = web.window.location.origin;
    if (origin.startsWith('https://')) {
      baseUrl = origin;
    } else {
      final hostname = web.window.location.hostname;
      baseUrl = 'http://${hostname.isEmpty ? 'localhost' : hostname}:8080';
    }
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
