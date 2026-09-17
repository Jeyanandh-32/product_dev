import 'package:api_client/api_client.dart';

/// Resolves the backend API base URL for the Customer web application.
String resolveCustomerApiBaseUrl() => resolveBaseUrl(
      defaultBaseUrl: 'http://${Uri.base.host.isEmpty ? 'localhost' : Uri.base.host}:8080',
      host: Uri.base.host,
      isWeb: true,
    );

/// Initializes the global Dio HTTP client for the Customer web application.
void initCustomerDio() {
  initDio(createClientDio(baseUrl: resolveCustomerApiBaseUrl()));
}
