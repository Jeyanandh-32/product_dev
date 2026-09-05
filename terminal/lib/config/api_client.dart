import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:terminal/config/secure_storage.dart';

/// Resolves the backend API base URL for the Terminal application.
///
/// Priority:
/// 1. Compile-time `--dart-define=API_BASE_URL=...` override.
/// 2. If running on Web ([kIsWeb]), dynamically derives from browser [Uri.base.origin].
/// 3. Native fallback defaults to `http://localhost:8080`.
String resolveApiBaseUrl() {
  const envUrl = String.fromEnvironment('API_BASE_URL');
  if (envUrl.isNotEmpty) {
    return envUrl.replaceAll(RegExp(r'/+$'), '');
  }

  if (kIsWeb) {
    final origin = Uri.base.origin;
    if (origin.startsWith('https://')) {
      return origin;
    }
    final host = Uri.base.host;
    return 'http://${host.isEmpty ? 'localhost' : host}:8080';
  }

  return 'http://localhost:8080';
}

/// Initializes the global Dio HTTP client for the Terminal application.
void initTerminalDio() {
  initDio(
    Dio(
        BaseOptions(
          baseUrl: resolveApiBaseUrl(),
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          extra: kIsWeb ? {'withCredentials': true} : {},
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) =>
              status != null &&
              ((status >= 200 && status < 300) || status == 401),
        ),
      )
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            if (!kIsWeb) {
              final token = await SecureStorage.getAccessToken();
              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
            }
            return handler.next(options);
          },
        ),
      ),
  );
}
