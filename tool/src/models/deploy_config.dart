/// Deployment configuration model and environment targets.
library;

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
    this.skipBuild = false,
    this.skipDeploy = false,
    this.skipTag = false,
    this.detectOnly = false,
    this.buildOnly = false,
    this.deployOnly = false,
    this.tagOnly = false,
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

  /// Skip compilation of artifacts.
  final bool skipBuild;

  /// Skip the EC2 rsync and restart phase (build only).
  final bool skipDeploy;

  /// Skip moving and pushing the git deploy tag.
  final bool skipTag;

  /// Only run change detection and emit outputs.
  final bool detectOnly;

  /// Only run test and compilation phases.
  final bool buildOnly;

  /// Only run rsync and remote service restart phases.
  final bool deployOnly;

  /// Only mark and push the git deploy tag.
  final bool tagOnly;

  /// Explicitly restricted set of components to process.
  final Set<DeployComponent> onlyComponents;
}
