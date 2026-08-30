import 'package:backend/services/phonepe_v1_client.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('PhonePeV1Client Unit Tests', () {
    late PhonePeV1Client client;

    setUp(() {
      client = PhonePeV1Client();
    });

    test('getBaseUrl returns correct environment endpoint', () {
      expect(
        client.getBaseUrl(PaymentGatewayEnv.uat),
        equals('https://api-preprod.phonepe.com/apis/pg-sandbox'),
      );
      expect(
        client.getBaseUrl(PaymentGatewayEnv.prod),
        equals('https://api.phonepe.com/apis/hermes'),
      );
    });
  });
}
