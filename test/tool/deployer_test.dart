import 'package:test/test.dart';
import '../../tool/src/deployer.dart';
import '../../tool/src/models/component.dart';
import '../../tool/src/models/deploy_config.dart';

void main() {
  group('Ec2Deployer path calculation', () {
    test('calculates correct web and application target paths for stage', () {
      final config = DeployConfig.fromArgs(['--target=stage'], environment: {});
      final deployer = Ec2Deployer(config: config);

      expect(deployer.sourcePathFor(DeployComponent.backend), equals('dist/server.exe'));
      expect(deployer.sourcePathFor(DeployComponent.merchant), equals('dist/merchant/'));
      expect(deployer.sourcePathFor(DeployComponent.customer), equals('dist/store/'));
      expect(deployer.sourcePathFor(DeployComponent.terminal), equals('dist/terminal/'));
      expect(deployer.sourcePathFor(DeployComponent.landing), equals('landing/'));
      expect(deployer.sourcePathFor(DeployComponent.migrations), equals('backend/migrations/'));

      expect(
        deployer.remoteTargetFor(DeployComponent.merchant, user: 'u', host: 'h'),
        equals('u@h:/var/www/pos/stage/merchant/'),
      );
      expect(
        deployer.remoteTargetFor(DeployComponent.customer, user: 'u', host: 'h'),
        equals('u@h:/var/www/pos/stage/store/'),
      );
      expect(
        deployer.remoteTargetFor(DeployComponent.backend, user: 'u', host: 'h'),
        equals('u@h:/home/u/pos/stage/server.exe'),
      );
      expect(
        deployer.remoteTargetFor(DeployComponent.migrations, user: 'u', host: 'h'),
        equals('u@h:/home/u/pos/stage/migrations/'),
      );
    });

    test('calculates correct paths for main environment', () {
      final config = DeployConfig.fromArgs(['--target=main'], environment: {});
      final deployer = Ec2Deployer(config: config);

      expect(
        deployer.remoteTargetFor(DeployComponent.terminal, user: 'u', host: 'h'),
        equals('u@h:/var/www/pos/main/terminal/'),
      );
      expect(
        deployer.remoteTargetFor(DeployComponent.landing, user: 'u', host: 'h'),
        equals('u@h:/var/www/pos/main/landing/'),
      );
      expect(
        deployer.remoteTargetFor(DeployComponent.backend, user: 'u', host: 'h'),
        equals('u@h:/home/u/pos/main/server.exe'),
      );
    });
  });
}
