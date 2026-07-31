import 'package:dio/dio.dart';

import 'api_exception.dart';

/// Global Dio instance for client-side HTTP requests.
/// Must be initialized by the app before use via [initDio].
Dio? _dio;

/// Initialize the shared Dio instance. Call this at app startup.
void initDio(Dio instance) {
  _dio = instance;
}

/// Access the shared Dio instance.
Dio get dio {
  assert(_dio != null, 'Call initDio() before accessing dio.');
  return _dio!;
}

/// Extract error message from a Dio error response and throw [ApiException].
Never handleDioError(DioException e, String defaultMessage) {
  final data = e.response?.data;
  final message =
      (data is Map ? data['message'] as String? : null) ?? defaultMessage;
  throw ApiException(message);
}
