import 'package:test/test.dart';
import '../../tool/src/models/component.dart';
import '../../tool/src/models/deploy_config.dart';

void main() {
  group('DeployConfig', () {
    test('defaults to stage environment when no args or env provided', () {
      final config = DeployConfig.fromArgs([], environment: {});

      expect(config.target, equals('stage'));
      expect(config.webDir, equals('/var/www/pos/stage'));
      expect(config.appDir, equals('pos/stage'));
      expect(config.systemdService, equals('pos-stage-backend'));
      expect(config.deployTag, equals('deployed-stage'));
      expect(config.dryRun, isFalse);
      expect(config.all, isFalse);
    });

    test('configures main environment correctly', () {
      final config = DeployConfig.fromArgs(['--target=main'], environment: {});

      expect(config.target, equals('main'));
      expect(config.webDir, equals('/var/www/pos/main'));
      expect(config.appDir, equals('pos/main'));
      expect(config.systemdService, equals('pos-backend'));
      expect(config.deployTag, equals('deployed-main'));
    });

    test('strips refs/heads/ prefix from git branch names', () {
      final config = DeployConfig.fromArgs(['--target=refs/heads/stage'], environment: {});
      expect(config.target, equals('stage'));
    });

    test('parses boolean CLI flags and only components list', () {
      final config = DeployConfig.fromArgs([
        '--target=stage',
        '--dry-run',
        '--all',
        '--skip-tests',
        '--skip-deploy',
        '--skip-tag',
        '--only=backend,merchant',
        '--base=HEAD~1',
        '--host=1.2.3.4',
        '--user=deployer',
        '--ssh-key=/custom/id_rsa',
      ], environment: {});

      expect(config.dryRun, isTrue);
      expect(config.all, isTrue);
      expect(config.skipTests, isTrue);
      expect(config.skipDeploy, isTrue);
      expect(config.skipTag, isTrue);
      expect(config.baseSha, equals('HEAD~1'));
      expect(config.ec2Host, equals('1.2.3.4'));
      expect(config.ec2User, equals('deployer'));
      expect(config.sshKeyPath, equals('/custom/id_rsa'));
      expect(config.onlyComponents, containsAll([DeployComponent.backend, DeployComponent.merchant]));
      expect(config.onlyComponents.length, equals(2));
    });

    test('falls back to environment variables for credentials', () {
      final config = DeployConfig.fromArgs([], environment: {
        'EC2_HOST': 'ec2.aws.com',
        'EC2_USER': 'ubuntu',
        'EC2_SSH_KEY': 'PRIVATE_KEY_CONTENT',
      });

      expect(config.ec2Host, equals('ec2.aws.com'));
      expect(config.ec2User, equals('ubuntu'));
      expect(config.sshKey, equals('PRIVATE_KEY_CONTENT'));
    });
  });
}
