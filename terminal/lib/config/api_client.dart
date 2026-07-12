import 'package:dio/dio.dart';
import 'package:terminal/config/secure_storage.dart';
import 'package:terminal/exceptions/api_exception.dart';

class ApiClient {
  const ApiClient._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  static Dio dio =
      Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            validateStatus: (status) =>
                status != null && status >= 200 && status < 300,
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await SecureStorage.getAccessToken();
              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              return handler.next(options);
            },
          ),
        );

  static Never handleDioError(DioException e, String defaultMessage) {
    final data = e.response?.data;
    final message =
        (data is Map ? data['message'] as String? : null) ?? defaultMessage;
    throw ApiException(message);
  }
}

class ApiEndpoints {
  const ApiEndpoints._();

  static const String version = 'v1';

  static const String login = '/$version/auth/terminal/login';
  static const String terminals = '/$version/terminals';
  static const String products = '/$version/products';
  static const String categories = '/$version/categories';
  static const String stores = '/$version/stores';
  static const String stocks = '/$version/stocks';
  static const String orders = '/$version/orders';
}
