/// Compilation, testing, and artifact building for workspace apps.
library;

import 'dart:io';
import 'package:path/path.dart' as p;
import 'models/component.dart';
import 'models/deploy_config.dart';
import 'process_runner.dart';

/// Coordinates tests, code generation, and production builds for workspace targets.
class AppBuilder {
  /// Creates an application builder.
  const AppBuilder({
    required this.config,
    this.runner = const ProcessRunner(),
  });

  /// Deployment configuration options.
  final DeployConfig config;

  /// Process runner for executing build tools.
  final ProcessRunner runner;

  /// Bootstraps workspace dependencies across all subprojects.
  Future<void> bootstrap() async {
    stdout.writeln('📦 Bootstrapping workspace dependencies with Melos...');
    await runner.run('dart', ['pub', 'global', 'activate', 'melos']);
    await runner.run('dart', ['pub', 'global', 'run', 'melos:melos', 'bootstrap']);
  }

  /// Runs automated tests for the specified component.
  Future<void> test(DeployComponent component) async {
    if (config.skipTests) return;

    switch (component) {
      case DeployComponent.backend:
        stdout.writeln('🧪 Running backend tests...');
        await runner.run('dart', ['test'], workingDirectory: 'backend');
      case DeployComponent.customer:
        stdout.writeln('🧪 Running customer tests...');
        await runner.run('dart', ['test'], workingDirectory: 'customer');
      case DeployComponent.terminal:
        stdout.writeln('🧪 Running terminal tests...');
        await runner.run('flutter', ['test'], workingDirectory: 'terminal');
      default:
        break;
    }
  }

  /// Builds and compiles production artifacts for the given component.
  Future<void> build(DeployComponent component) async {
    Directory('dist').createSync(recursive: true);

    switch (component) {
      case DeployComponent.backend:
        await _buildBackend();
      case DeployComponent.merchant:
        await _buildJasprApp('merchant', 'dist/merchant');
      case DeployComponent.customer:
        await _buildJasprApp('customer', 'dist/store');
      case DeployComponent.terminal:
        await _buildTerminal();
      case DeployComponent.landing:
      case DeployComponent.migrations:
        stdout.writeln('ℹ️  ${component.identifier} requires no compilation.');
    }
  }

  Future<void> _buildBackend() async {
    stdout.writeln('🔨 Compiling native Dart Frog backend binary...');
    await runner.run('dart', ['pub', 'global', 'activate', 'dart_frog_cli']);
    await runner.run('dart', ['pub', 'global', 'run', 'dart_frog_cli:dart_frog', 'build'], workingDirectory: 'backend');

    final buildDir = p.join('backend', 'build');
    final outExe = p.join(Directory.current.path, 'dist', 'server.exe');
    await runner.run('dart', ['pub', 'get'], workingDirectory: buildDir);
    await runner.run('dart', ['compile', 'exe', 'bin/server.dart', '-o', outExe], workingDirectory: buildDir);
  }

  Future<void> _buildJasprApp(String projectDir, String distTarget) async {
    stdout.writeln('🔨 Building $projectDir web app (WASM)...');
    await runner.run('dart', ['pub', 'global', 'activate', 'jaspr_cli']);
    await runner.run('dart', ['pub', 'global', 'run', 'jaspr_cli:jaspr', 'build', '--experimental-wasm'], workingDirectory: projectDir);
    _copyDirectory(Directory(p.join(projectDir, 'build', 'jaspr')), Directory(distTarget));
  }

  Future<void> _buildTerminal() async {
    stdout.writeln('🔨 Building Flutter terminal web app (WASM)...');
    await runner.run('flutter', ['build', 'web', '--wasm', '--release', '--base-href', '/'], workingDirectory: 'terminal');
    _copyDirectory(Directory(p.join('terminal', 'build', 'web')), Directory('dist/terminal'));
  }

  void _copyDirectory(Directory source, Directory destination) {
    if (config.dryRun || !source.existsSync()) return;
    destination.createSync(recursive: true);
    for (final entity in source.listSync(recursive: true)) {
      if (entity is File) {
        final rel = p.relative(entity.path, from: source.path);
        final targetFile = File(p.join(destination.path, rel));
        targetFile.parent.createSync(recursive: true);
        entity.copySync(targetFile.path);
      }
    }
  }
}
