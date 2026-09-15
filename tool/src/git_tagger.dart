/// Git tag tracking for deployed commits.
library;

import 'dart:io';
import 'models/deploy_config.dart';
import 'process_runner.dart';

/// Tags the successfully deployed commit and updates the remote repository.
class GitTagger {
  /// Creates a git tagger.
  const GitTagger({
    required this.config,
    this.runner = const ProcessRunner(),
  });

  /// Deployment configuration options.
  final DeployConfig config;

  /// Process runner for executing git commands.
  final ProcessRunner runner;

  /// Updates and pushes the deployment tag to the origin remote.
  Future<void> tagDeployment() async {
    if (config.skipTag) {
      stdout.writeln('ℹ️  Skipping git tag update as requested.');
      return;
    }

    stdout.writeln('🏷️  Updating deployment tag: ${config.deployTag}...');
    final currentSha = await runner.capture('git', ['rev-parse', 'HEAD']);

    if (Platform.environment.containsKey('GITHUB_ACTIONS')) {
      await runner.run('git', ['config', 'user.name', 'github-actions[bot]'], quiet: true);
      await runner.run('git', ['config', 'user.email', 'github-actions[bot]@users.noreply.github.com'], quiet: true);
    }

    await runner.run('git', ['tag', '-f', config.deployTag, currentSha]);
    await runner.run('git', ['push', 'origin', 'refs/tags/${config.deployTag}', '--force']);

    stdout.writeln('✅ Tag ${config.deployTag} successfully pushed to origin at $currentSha.');
  }
}
