import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

export 'package:dio_smart_retry/dio_smart_retry.dart' show RetryInterceptor;
export 'package:pretty_dio_logger/pretty_dio_logger.dart' show PrettyDioLogger;

/// Helper to resolve the base URL across environment overrides and platforms.
String resolveBaseUrl({
  required String defaultBaseUrl,
  String? host,
  bool isWeb = false,
  String? stageBaseUrl = 'https://api.finch-stage.sparrow-x.in',
  String? prodBaseUrl = 'https://api.finch.sparrow-x.in',
}) {
  const envUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: String.fromEnvironment('API_URL'),
  );

  if (envUrl.isNotEmpty) {
    return envUrl.replaceAll(RegExp(r'/+$'), '');
  }

  if (isWeb && host != null) {
    final isIp = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$').hasMatch(host);
    if (host.isEmpty || host == 'localhost' || isIp) {
      return defaultBaseUrl;
    }

    if (stageBaseUrl != null && host.contains('stage')) {
      return stageBaseUrl;
    }

    if (prodBaseUrl != null) {
      return prodBaseUrl;
    }
  }

  return defaultBaseUrl;
}

/// Creates a standard configured [Dio] instance for client applications.
Dio createClientDio({
  required String baseUrl,
  bool withCredentials = true,
  bool enableLogging = false,
  bool enableRetry = true,
  int retries = 2,
  List<Interceptor>? interceptors,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      extra: withCredentials ? {'withCredentials': true} : {},
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) =>
          status != null &&
          ((status >= 200 && status < 300) || status == 401),
    ),
  );

  if (enableRetry) {
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        retries: retries,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
        ],
      ),
    );
  }

  if (enableLogging) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    );
  }

  if (interceptors != null) {
    dio.interceptors.addAll(interceptors);
  }

  return dio;
}
