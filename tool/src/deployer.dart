/// EC2 artifact deployment and systemd service management.
library;

import 'dart:io';
import 'package:path/path.dart' as p;
import 'models/component.dart';
import 'models/deploy_config.dart';
import 'process_runner.dart';

/// Manages SSH key setup, Rsync synchronization, and remote service restarts on EC2.
class Ec2Deployer {
  /// Creates an EC2 deployer.
  const Ec2Deployer({
    required this.config,
    this.runner = const ProcessRunner(),
  });

  /// Deployment configuration options.
  final DeployConfig config;

  /// Process runner for executing rsync and ssh.
  final ProcessRunner runner;

  /// Deploys the specified components to the target EC2 instance.
  Future<void> deploy(Set<DeployComponent> components) async {
    if (components.isEmpty) {
      stdout.writeln('ℹ️  No components changed. Skipping deployment.');
      return;
    }

    final keyFile = _resolveSshKeyFile();
    try {
      final host = config.ec2Host ?? 'localhost';
      final user = config.ec2User ?? 'ec2-user';
      final keyPath = keyFile?.path ?? '${Platform.environment['HOME']}/.ssh/id_rsa';
      final sshCmd = 'ssh -i $keyPath -o StrictHostKeyChecking=accept-new';

      stdout.writeln('🚀 Deploying ${components.length} component(s) to $user@$host...');

      for (final component in components) {
        await _syncComponent(component, user: user, host: host, sshCmd: sshCmd);
      }

      if (components.contains(DeployComponent.backend) || components.contains(DeployComponent.migrations)) {
        await _restartBackendService(user: user, host: host, keyPath: keyFile?.path);
      }
    } finally {
      if (keyFile != null && keyFile.path.contains('ci_deploy_key_') && keyFile.existsSync()) {
        keyFile.deleteSync();
      }
    }
  }

  Future<void> _syncComponent(
    DeployComponent component, {
    required String user,
    required String host,
    required String sshCmd,
  }) async {
    final remoteTarget = remoteTargetFor(component, user: user, host: host);
    final sourcePath = sourcePathFor(component);

    stdout.writeln('  -> Syncing ${component.identifier} ($sourcePath -> $remoteTarget)...');
    await runner.run('rsync', ['-avz', '-e', sshCmd, sourcePath, remoteTarget]);
  }

  /// Returns source path for artifact synchronization.
  String sourcePathFor(DeployComponent component) {
    switch (component) {
      case DeployComponent.backend:
        return 'dist/server.exe';
      case DeployComponent.merchant:
        return 'dist/merchant/';
      case DeployComponent.customer:
        return 'dist/store/';
      case DeployComponent.terminal:
        return 'dist/terminal/';
      case DeployComponent.landing:
        return 'landing/';
      case DeployComponent.migrations:
        return 'backend/migrations/';
    }
  }

  /// Returns target path on remote EC2 host.
  String remoteTargetFor(DeployComponent component, {required String user, required String host}) {
    if (component.isWeb || component.isStatic) {
      final sub = component == DeployComponent.customer ? 'store' : component.identifier;
      return '$user@$host:${config.webDir}/$sub/';
    }
    if (component == DeployComponent.backend) {
      return '$user@$host:/home/$user/${config.appDir}/server.exe';
    }
    return '$user@$host:/home/$user/${config.appDir}/migrations/';
  }

  Future<void> _restartBackendService({required String user, required String host, String? keyPath}) async {
    stdout.writeln('🔄 Restarting remote systemd service (${config.systemdService})...');
    final binaryPath = '/home/$user/${config.appDir}/server.exe';
    final cmd = 'if [ -f "$binaryPath" ]; then chmod +x "$binaryPath" && sudo systemctl restart ${config.systemdService}; fi';

    await runner.run('ssh', [
      if (keyPath != null) ...['-i', keyPath],
      '-o',
      'StrictHostKeyChecking=accept-new',
      '$user@$host',
      cmd,
    ]);
  }

  File? _resolveSshKeyFile() {
    if (config.sshKeyPath != null) {
      return File(config.sshKeyPath!);
    }
    if (config.sshKey != null && config.sshKey!.trim().isNotEmpty) {
      final tempFile = File(p.join(Directory.systemTemp.path, 'ci_deploy_key_${DateTime.now().millisecondsSinceEpoch}'));
      tempFile.writeAsStringSync('${config.sshKey!.trim()}\n');
      Process.runSync('chmod', ['600', tempFile.path]);
      return tempFile;
    }
    return null;
  }
}
