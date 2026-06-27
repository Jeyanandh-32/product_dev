import 'package:dio/dio.dart';
import 'package:terminal/exceptions/api_exception.dart';

class ApiClient {
  const ApiClient._();

  // Point to the backend server. Using localhost:8080 works for desktop and web.
  // If running on a physical Android device or emulator, you can update this to the computer's IP or 10.0.2.2.
  static const String baseUrl = 'http://localhost:8080';

  static Dio dio = Dio(
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
  static const String products = '/$version/products';
  static const String stores = '/$version/stores';
}
