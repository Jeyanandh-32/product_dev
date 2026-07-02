import 'package:dio/dio.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:web/web.dart' as web;

class ApiClient {
  const ApiClient._();

  static const String _envUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_envUrl.isNotEmpty) return _envUrl;
    final hostname = web.window.location.hostname;
    return 'http://${hostname.isEmpty ? 'localhost' : hostname}:8080';
  }

  static Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      extra: {'withCredentials': true},
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) =>
          status != null && status >= 200 && status < 300,
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

  static const String login = '/$version/auth/merchant/login';
  static const String register = '/v1/auth/merchant/register';
  static const String logout = '/$version/auth/logout';
  static const String merchants = '/v1/merchants';
  static const String stores = '/$version/stores';
  static const String terminals = '/v1/terminals';
  static const String counters = '/$version/counters';
  static const String categories = '/$version/categories';
  static const String products = '/$version/products';
  static const String stocks = '/$version/stocks';
}
