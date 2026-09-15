/// Git diff inspection and affected component detection.
library;

import 'dart:io';
import 'models/component.dart';
import 'models/deploy_config.dart';
import 'process_runner.dart';

/// Detects workspace components that have changed relative to the last deployed tag.
class ChangeDetector {
  /// Creates a change detector.
  const ChangeDetector({
    required this.config,
    this.runner = const ProcessRunner(),
  });

  /// Deployment configuration options.
  final DeployConfig config;

  /// Process runner for executing git commands.
  final ProcessRunner runner;

  /// Determines which components need building and deploying.
  Future<Set<DeployComponent>> detectChanges() async {
    if (config.all) {
      return DeployComponent.values.toSet();
    }

    if (config.onlyComponents.isNotEmpty) {
      return config.onlyComponents;
    }

    final baseSha = await _resolveBaseSha();
    final changedFiles = await _getChangedFiles(baseSha);
    return mapFilesToComponents(changedFiles);
  }

  /// Maps a list of modified file paths to affected workspace components.
  static Set<DeployComponent> mapFilesToComponents(Iterable<String> files) {
    final components = <DeployComponent>{};
    for (final file in files) {
      for (final component in DeployComponent.values) {
        if (component.matchesPath(file)) {
          components.add(component);
        }
      }
    }
    return components;
  }

  /// Emits component change statuses to GitHub Actions $GITHUB_OUTPUT file if present.
  void emitGithubOutputs(Set<DeployComponent> components) {
    final outputPath = Platform.environment['GITHUB_OUTPUT'];
    if (outputPath == null || outputPath.isEmpty) return;

    final file = File(outputPath);
    final buffer = StringBuffer();
    for (final component in DeployComponent.values) {
      final isChanged = components.contains(component);
      buffer.writeln('${component.identifier}=$isChanged');
    }
    buffer.writeln('deploy_tag=${config.deployTag}');
    file.writeAsStringSync(buffer.toString(), mode: FileMode.append);
  }

  /// Resolves the base commit SHA by checking custom baseSha, deploy tag, or root commit.
  Future<String> _resolveBaseSha() async {
    if (config.baseSha != null && config.baseSha!.isNotEmpty) {
      final sha = await runner.capture('git', [
        'rev-parse',
        config.baseSha!,
      ]);
      stdout.writeln('  Diffing against custom base ${config.baseSha} ($sha)');
      return sha;
    }

    try {
      final tagSha = await runner.capture('git', [
        'rev-parse',
        '-q',
        '--verify',
        'refs/tags/${config.deployTag}',
      ]);
      if (tagSha.isNotEmpty) {
        stdout.writeln('  Diffing against tag ${config.deployTag} ($tagSha)');
        return tagSha;
      }
    } on ProcessException catch (_) {
      // Tag does not exist yet. Fall back to initial root commit.
    }

    final rootSha = await runner.capture('git', [
      'rev-list',
      '--max-parents=0',
      'HEAD',
    ]);
    stdout.writeln('  Deploy tag not found. Diffing against root ($rootSha)');
    return rootSha;
  }

  /// Returns relative paths of all files changed between [baseSha] and current HEAD.
  Future<List<String>> _getChangedFiles(String baseSha) async {
    final diffOutput = await runner.capture('git', [
      'diff',
      '--name-only',
      baseSha,
      'HEAD',
    ]);

    if (diffOutput.isEmpty) return const [];
    return diffOutput
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }
}
