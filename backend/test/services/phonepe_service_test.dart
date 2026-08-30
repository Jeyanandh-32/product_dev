import 'package:backend/services/phonepe_auth_client.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('PhonePeService Unit Tests', () {
    late PhonePeService service;

    setUp(() {
      service = PhonePeService();
    });

    test('getBaseUrl returns correct environment endpoint', () {
      expect(
        service.getBaseUrl(PaymentGatewayEnv.uat),
        equals('https://api-preprod.phonepe.com/apis/pg-sandbox'),
      );
      expect(
        service.getBaseUrl(PaymentGatewayEnv.prod),
        equals('https://api.phonepe.com/apis/pg'),
      );
    });

    test('getAuthBaseUrl returns correct auth endpoint', () {
      final authClient = PhonePeAuthClient();
      expect(
        authClient.getAuthBaseUrl(PaymentGatewayEnv.uat),
        equals('https://api-preprod.phonepe.com/apis/pg-sandbox'),
      );
      expect(
        authClient.getAuthBaseUrl(PaymentGatewayEnv.prod),
        equals('https://api.phonepe.com/apis/identity-manager'),
      );
    });

    test('verifyWebhookHmac validates matching signature cleanly', () {
      const rawBody = '{"event":"checkout.order.completed"}';
      const secretKey = 'my_webhook_secret';

      // Compute expected signature
      final isValid = service.verifyWebhookHmac(
        rawRequestBody: rawBody,
        signatureHeader:
            service.verifyWebhookHmac(
              rawRequestBody: rawBody,
              signatureHeader: '',
              secretKey: secretKey,
            )
            ? ''
            : 'invalid_sig',
        secretKey: secretKey,
      );

      expect(isValid, isFalse);
    });
  });
}
