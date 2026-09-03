import 'package:backend/repositories/platform_phonepe_config_repository.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('PlatformPhonePeConfigRepository Unit Tests', () {
    test(
      'getConfig returns PlatformPhonePeConfig or null based on environment',
      () {
        const repo = PlatformPhonePeConfigRepository();
        final config = repo.getConfig();

        if (config != null) {
          expect(config.id, equals('env-platform-phonepe'));
          expect(config.isEnabled, isTrue);
          expect(config.clientId, equals('M222MD48X2MKH_2609031908'));
          expect(config.clientVersion, equals('1'));
          expect(config.env, equals(PaymentGatewayEnv.uat));

          final storeConfig = config.toStorePhonePeConfig(storeId: 'store-123');
          expect(storeConfig.storeId, equals('store-123'));
          expect(storeConfig.isEnabled, equals(config.isEnabled));
          expect(storeConfig.clientId, equals('M222MD48X2MKH_2609031908'));
        } else {
          expect(config, isNull);
        }
      },
    );
  });
}
