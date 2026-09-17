import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

void main() {
  group('ApiEndpoints Tests', () {
    test('version segment is v1 and paths start with /v1', () {
      expect(ApiEndpoints.version, equals('v1'));
      expect(ApiEndpoints.merchantLogin, equals('/v1/auth/merchant/login'));
      expect(ApiEndpoints.customerLogin, equals('/v1/auth/customer/login'));
      expect(ApiEndpoints.terminalLogin, equals('/v1/auth/terminal/login'));
      expect(ApiEndpoints.merchants, equals('/v1/merchants'));
      expect(ApiEndpoints.stores, equals('/v1/stores'));
      expect(ApiEndpoints.orders, equals('/v1/orders'));
      expect(ApiEndpoints.products, equals('/v1/products'));
    });

    test('parameterized endpoint paths construct valid URLs', () {
      expect(
        ApiEndpoints.storePhonePeConfig('store-123'),
        equals('/v1/stores/store-123/phonepe-config'),
      );
      expect(
        ApiEndpoints.storeSubscription('store-456'),
        equals('/v1/stores/store-456/subscription'),
      );
      expect(
        ApiEndpoints.storeSubscriptionRenew('store-789'),
        equals('/v1/stores/store-789/subscription/renew'),
      );
    });
  });

  group('resolveBaseUrl Tests', () {
    test('returns defaultBaseUrl when not web and no environment variable', () {
      final url = resolveBaseUrl(
        defaultBaseUrl: 'http://localhost:8080',
        isWeb: false,
      );
      expect(url, equals('http://localhost:8080'));
    });

    test('returns defaultBaseUrl for localhost or IP hosts on web', () {
      final urlLocal = resolveBaseUrl(
        defaultBaseUrl: 'http://localhost:8080',
        host: 'localhost',
        isWeb: true,
      );
      expect(urlLocal, equals('http://localhost:8080'));

      final urlIp = resolveBaseUrl(
        defaultBaseUrl: 'http://192.168.1.50:8080',
        host: '192.168.1.50',
        isWeb: true,
      );
      expect(urlIp, equals('http://192.168.1.50:8080'));
    });

    test('resolves stage URL when host contains stage', () {
      final url = resolveBaseUrl(
        defaultBaseUrl: 'http://localhost:8080',
        host: 'merchant-stage.sparrow-x.in',
        isWeb: true,
      );
      expect(url, equals('https://api.finch-stage.sparrow-x.in'));
    });

    test('resolves production URL for external non-stage host', () {
      final url = resolveBaseUrl(
        defaultBaseUrl: 'http://localhost:8080',
        host: 'merchant.sparrow-x.in',
        isWeb: true,
      );
      expect(url, equals('https://api.finch.sparrow-x.in'));
    });
  });

  group('createClientDio Tests', () {
    test('configures base options correctly', () {
      final dio = createClientDio(
        baseUrl: 'https://api.finch.sparrow-x.in',
        withCredentials: true,
        enableRetry: false,
        enableLogging: false,
      );

      expect(dio.options.baseUrl, equals('https://api.finch.sparrow-x.in'));
      expect(dio.options.connectTimeout, equals(const Duration(seconds: 10)));
      expect(dio.options.receiveTimeout, equals(const Duration(seconds: 10)));
      expect(dio.options.extra['withCredentials'], isTrue);
      expect(dio.options.headers['Content-Type'], equals('application/json'));
    });

    test('adds custom interceptors and retry interceptor', () {
      final customInterceptor = QueuedInterceptorsWrapper();
      final dio = createClientDio(
        baseUrl: 'http://localhost:8080',
        enableRetry: true,
        enableLogging: true,
        interceptors: [customInterceptor],
      );

      expect(dio.interceptors.isNotEmpty, isTrue);
      expect(dio.interceptors.contains(customInterceptor), isTrue);
    });
  });

  group('ApiException and PaginatedResponse Tests', () {
    test('ApiException holds message and converts toString', () {
      const ex = ApiException('Resource not found');
      expect(ex.message, equals('Resource not found'));
      expect(ex.toString(), equals('Resource not found'));
    });

    test('parsePaginatedResponse parses data into record tuple correctly', () {
      final rawData = {
        'currentPage': 1,
        'pageSize': 2,
        'totalItems': 4,
        'totalPages': 2,
        'products': [
          {'id': '1', 'name': 'Milk'},
          {'id': '2', 'name': 'Bread'},
        ],
      };

      final response = parsePaginatedResponse<String>(
        data: rawData,
        key: 'products',
        fromJson: (json) => json['name']! as String,
      );

      expect(response.items, equals(['Milk', 'Bread']));
      expect(response.currentPage, equals(1));
      expect(response.pageSize, equals(2));
      expect(response.totalItems, equals(4));
      expect(response.totalPages, equals(2));
    });

    test('PhonePe stubs execute cleanly without exceptions on VM', () {
      expect(
        () => openPhonePeCheckoutModal(
          tokenUrl: 'https://phonepe.com/test',
          onComplete: (_) {},
        ),
        returnsNormally,
      );
      expect(
        () => renderQrCodeCanvas(
          elementId: 'qr-canvas',
          text: 'upi://pay?pa=test',
        ),
        returnsNormally,
      );
    });
  });
}
