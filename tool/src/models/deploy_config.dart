/// Deployment configuration and environment parameters.
library;

import 'dart:io';
import 'package:args/args.dart';
import 'component.dart';

/// Target configuration for deploying Finch POS to AWS EC2.
class DeployConfig {
  /// Creates a deployment configuration.
  const DeployConfig({
    required this.target,
    required this.webDir,
    required this.appDir,
    required this.systemdService,
    required this.deployTag,
    this.ec2Host,
    this.ec2User,
    this.sshKey,
    this.sshKeyPath,
    this.baseSha,
    this.dryRun = false,
    this.all = false,
    this.skipTests = false,
    this.skipDeploy = false,
    this.skipTag = false,
    this.onlyComponents = const <DeployComponent>{},
  });

  /// Target branch/environment name (e.g., 'stage' or 'main').
  final String target;

  /// Web directory on EC2 server (e.g., '/var/www/pos/stage').
  final String webDir;

  /// Application directory on EC2 server (e.g., 'pos/stage').
  final String appDir;

  /// Systemd service identifier (e.g., 'pos-stage-backend').
  final String systemdService;

  /// Git tag tracking the deployed commit (e.g., 'deployed-stage').
  final String deployTag;

  /// EC2 server hostname or IP address.
  final String? ec2Host;

  /// EC2 SSH username.
  final String? ec2User;

  /// Raw SSH private key text from environment.
  final String? sshKey;

  /// Path to existing SSH private key file.
  final String? sshKeyPath;

  /// Custom base commit SHA or git ref to diff against.
  final String? baseSha;

  /// When true, commands are logged without executing actions on the server.
  final bool dryRun;

  /// Force build and deploy all components.
  final bool all;

  /// Skip automated test execution prior to compilation.
  final bool skipTests;

  /// Skip the EC2 rsync and restart phase (build only).
  final bool skipDeploy;

  /// Skip moving and pushing the git deploy tag.
  final bool skipTag;

  /// Explicitly restricted set of components to process.
  final Set<DeployComponent> onlyComponents;

  /// Creates a configuration parsed from CLI flags and environment variables.
  factory DeployConfig.fromArgs(
    List<String> rawArgs, {
    Map<String, String>? environment,
  }) {
    final env = environment ?? Platform.environment;
    final parser = ArgParser()
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
      ..addFlag('skip-tag', negatable: false, help: 'Skip updating git tag');

    final results = parser.parse(rawArgs);
    final rawTarget = results['target'] as String? ?? env['TARGET_BRANCH'] ?? 'stage';
    final target = rawTarget.replaceAll('refs/heads/', '');
    final isStage = target == 'stage';

    final onlyNames = (results['only'] as String?)?.split(',') ?? const [];
    final only = onlyNames
        .map((s) => DeployComponent.fromIdentifier(s.trim()))
        .whereType<DeployComponent>()
        .toSet();

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
      skipTests: results['skip-tests'] as bool? ?? false,
      skipDeploy: results['skip-deploy'] as bool? ?? false,
      skipTag: results['skip-tag'] as bool? ?? false,
      onlyComponents: only,
    );
  }
}
