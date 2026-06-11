import 'package:dio/dio.dart';
import 'package:web/web.dart' as web;

class ApiClient {
  const ApiClient._();

  static Dio dio = Dio(
    BaseOptions(
      baseUrl:
          'http://${web.window.location.hostname.isEmpty ? 'localhost' : web.window.location.hostname}:8080',
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
}

class ApiEndpoints {
  const ApiEndpoints._();

  static const String login = '/v1/auth/merchant/login';
  static const String register = '/v1/auth/merchant/register';
  static const String logout = '/v1/auth/logout';
  static const String merchants = '/v1/merchants';
  static const String stores = '/v1/stores';
  static const String terminals = '/v1/terminals';
  static const String counters = '/v1/counters';
}
