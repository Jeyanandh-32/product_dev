/// CLI entrypoint for orchestrating Finch POS testing, builds, and deployments.
library;

import 'dart:io';
import 'src/builders.dart';
import 'src/change_detector.dart';
import 'src/deployer.dart';
import 'src/git_tagger.dart';
import 'src/models/deploy_parser.dart';
import 'src/process_runner.dart';

/// Main entrypoint for `dart run tool/deploy.dart`.
Future<void> main(List<String> rawArgs) async {
  final config = DeployParser.parse(rawArgs);
  final runner = ProcessRunner(dryRun: config.dryRun);
  final builder = AppBuilder(config: config, runner: runner);
  final detector = ChangeDetector(config: config, runner: runner);
  final deployer = Ec2Deployer(config: config, runner: runner);
  final tagger = GitTagger(config: config, runner: runner);

  stdout.writeln('====================================================');
  stdout.writeln('🚀 Finch POS Deployment Orchestrator');
  stdout.writeln('Target Environment : ${config.target}');
  stdout.writeln('Target Web Dir     : ${config.webDir}');
  stdout.writeln('Target App Dir     : ${config.appDir}');
  stdout.writeln('Target Service     : ${config.systemdService}');
  stdout.writeln('Dry Run Mode       : ${config.dryRun}');
  stdout.writeln('====================================================\n');

  try {
    if (config.tagOnly) {
      stdout.writeln('🏷️  Stage: Tagging deployed commit...');
      await tagger.tagDeployment();
      stdout.writeln('\n🎉 Tagging completed successfully!');
      return;
    }

    stdout.writeln('🔍 Stage 1: Detecting changed workspace components...');
    final components = await detector.detectChanges();
    detector.emitGithubOutputs(components);

    if (config.detectOnly) {
      stdout.writeln('Detected: ${components.map((c) => c.identifier).join(', ')}');
      stdout.writeln('\n✨ Change detection complete.');
      return;
    }

    if (components.isEmpty) {
      stdout.writeln('✨ All components up-to-date. No deployment needed.');
      return;
    }

    stdout.writeln('Active targets: ${components.map((c) => c.identifier).join(', ')}\n');

    if (!config.skipBuild) {
      stdout.writeln('📦 Stage 2: Bootstrapping workspace dependencies...');
      await builder.bootstrap();
      stdout.writeln('');

      stdout.writeln('🧪 Stage 3: Running automated tests...');
      for (final component in components) {
        await builder.test(component);
      }
      stdout.writeln('');

      stdout.writeln('🔨 Stage 4: Compiling production artifacts...');
      for (final component in components) {
        await builder.build(component);
      }
      stdout.writeln('');
    }

    if (!config.skipDeploy) {
      stdout.writeln('🚀 Stage 5: Deploying artifacts to AWS EC2...');
      await deployer.deploy(components);
      stdout.writeln('');

      if (!config.skipTag) {
        stdout.writeln('🏷️  Stage 6: Tagging deployed commit...');
        await tagger.tagDeployment();
      }
    } else {
      stdout.writeln('ℹ️  Skipping deploy stage (--skip-deploy enabled).');
    }

    stdout.writeln('\n🎉 Deployment pipeline completed successfully!');
  } on ProcessException catch (e) {
    stderr.writeln('\n❌ Process execution failed: ${e.executable} ${e.arguments.join(' ')}');
    stderr.writeln('Message: ${e.message}');
    exit(e.errorCode != 0 ? e.errorCode : 1);
  } catch (e, stack) {
    stderr.writeln('\n❌ Unexpected error during deployment: $e');
    stderr.writeln(stack);
    exit(1);
  }
}
