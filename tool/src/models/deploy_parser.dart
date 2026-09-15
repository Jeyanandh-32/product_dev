/// Command-line argument parsing for deployment options.
library;

import 'dart:io';
import 'package:args/args.dart';
import 'component.dart';
import 'deploy_config.dart';

/// Parses raw CLI arguments and environment variables into a [DeployConfig].
class DeployParser {
  /// Builds the argument parser with all supported deployment flags.
  static ArgParser buildParser() {
    return ArgParser()
      ..addOption('target', abbr: 't', help: 'Target branch (stage or main)')
      ..addOption('ssh-key', help: 'Path to SSH private key file')
      ..addOption('host', help: 'EC2 Hostname')
      ..addOption('user', help: 'EC2 Username')
      ..addOption('base', help: 'Git base commit/ref to diff against')
      ..addOption('only', help: 'Comma-separated list of components to deploy')
      ..addFlag('all', abbr: 'a', negatable: false, help: 'Deploy all')
      ..addFlag('dry-run', abbr: 'n', negatable: false, help: 'Dry run')
      ..addFlag('skip-tests', negatable: false, help: 'Skip test runs')
      ..addFlag('skip-deploy', negatable: false, help: 'Build without deploy')
      ..addFlag('skip-tag', negatable: false, help: 'Skip updating git tag')
      ..addFlag('detect-only', negatable: false, help: 'Only detect changes')
      ..addFlag('build-only', negatable: false, help: 'Only test & compile')
      ..addFlag('deploy-only', negatable: false, help: 'Only sync to EC2')
      ..addFlag('tag-only', negatable: false, help: 'Only mark git tag');
  }

  /// Parses CLI arguments and environment parameters into [DeployConfig].
  static DeployConfig parse(List<String> rawArgs, {Map<String, String>? environment}) {
    final env = environment ?? Platform.environment;
    final parser = buildParser();
    final results = parser.parse(rawArgs);

    final rawTarget = results['target'] as String? ?? env['TARGET_BRANCH'] ?? 'stage';
    final target = rawTarget.replaceAll('refs/heads/', '');
    final isStage = target == 'stage';

    final onlyNames = (results['only'] as String?)?.split(',') ?? const [];
    final only = onlyNames
        .map((s) => DeployComponent.fromIdentifier(s.trim()))
        .whereType<DeployComponent>()
        .toSet();

    final isDetect = results['detect-only'] as bool? ?? false;
    final isBuild = results['build-only'] as bool? ?? false;
    final isDeploy = results['deploy-only'] as bool? ?? false;
    final isTag = results['tag-only'] as bool? ?? false;

    return DeployConfig(
      target: target,
      webDir: isStage ? '/var/www/pos/stage' : '/var/www/pos/main',
      appDir: isStage ? 'pos/stage' : 'pos/main',
      systemdService: isStage ? 'pos-stage-backend' : 'pos-backend',
      deployTag: 'deployed-${target.replaceAll('/', '-')}',
      ec2Host: results['host'] as String? ?? env['EC2_HOST'],
      ec2User: results['user'] as String? ?? env['EC2_USER'],
      sshKey: env['EC2_SSH_KEY'],
      sshKeyPath: results['ssh-key'] as String? ?? env['EC2_SSH_KEY_PATH'],
      baseSha: results['base'] as String?,
      dryRun: results['dry-run'] as bool? ?? false,
      all: results['all'] as bool? ?? false,
      skipTests: (results['skip-tests'] as bool? ?? false) || isDeploy || isTag || isDetect,
      skipBuild: isDeploy || isTag || isDetect,
      skipDeploy: (results['skip-deploy'] as bool? ?? false) || isBuild || isTag || isDetect,
      skipTag: (results['skip-tag'] as bool? ?? false) || isBuild || isDeploy || isDetect,
      detectOnly: isDetect,
      buildOnly: isBuild,
      deployOnly: isDeploy,
      tagOnly: isTag,
      onlyComponents: only,
    );
  }
}
