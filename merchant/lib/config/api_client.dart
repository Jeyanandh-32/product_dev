import 'package:api_client/api_client.dart';

/// Resolves the backend API base URL for the Merchant web application.
String resolveMerchantApiBaseUrl() => resolveBaseUrl(
      defaultBaseUrl: 'http://${Uri.base.host.isEmpty ? 'localhost' : Uri.base.host}:8080',
      host: Uri.base.host,
      isWeb: true,
    );

/// Initializes the global Dio HTTP client for the Merchant web application.
void initMerchantDio() {
  initDio(createClientDio(baseUrl: resolveMerchantApiBaseUrl()));
}
