import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:terminal/config/secure_storage.dart';

/// Resolves the backend API base URL for the Terminal application.
String resolveApiBaseUrl() => resolveBaseUrl(
      defaultBaseUrl: 'http://localhost:8080',
      host: kIsWeb ? Uri.base.host : null,
      isWeb: kIsWeb,
    );

/// Initializes the global Dio HTTP client for the Terminal application.
void initTerminalDio() {
  initDio(
    createClientDio(
      baseUrl: resolveApiBaseUrl(),
      withCredentials: kIsWeb,
      interceptors: [
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
      ],
    ),
  );
}
