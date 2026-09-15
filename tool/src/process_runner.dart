/// Process execution utilities with streaming logs and dry-run support.
library;

import 'dart:convert';
import 'dart:io';

/// Execution wrapper for invoking command-line tools.
class ProcessRunner {
  /// Creates a process runner.
  const ProcessRunner({this.dryRun = false});

  /// When true, commands are logged without executing.
  final bool dryRun;

  /// Runs an executable process with live streaming output.
  Future<int> run(
    String executable,
    List<String> arguments, {
    String? workingDirectory,
    Map<String, String>? environment,
    bool quiet = false,
  }) async {
    final cmdString = '$executable ${arguments.join(' ')}';
    final dirSuffix = workingDirectory != null ? ' in $workingDirectory' : '';

    if (dryRun) {
      stdout.writeln('  [DRY-RUN] $cmdString$dirSuffix');
      return 0;
    }

    if (!quiet) {
      stdout.writeln('  -> $cmdString$dirSuffix');
    }

    final process = await Process.start(
      executable,
      arguments,
      workingDirectory: workingDirectory,
      environment: environment,
      mode: ProcessStartMode.normal,
    );

    final stdoutFuture = process.stdout
        .transform(utf8.decoder)
        .listen((data) => !quiet ? stdout.write(data) : null)
        .asFuture<void>();

    final stderrFuture = process.stderr
        .transform(utf8.decoder)
        .listen((data) => !quiet ? stderr.write(data) : null)
        .asFuture<void>();

    final exitCode = await process.exitCode;
    await Future.wait([stdoutFuture, stderrFuture]);

    if (exitCode != 0) {
      throw ProcessException(
        executable,
        arguments,
        'Process failed with exit code $exitCode$dirSuffix',
        exitCode,
      );
    }

    return exitCode;
  }

  /// Runs an executable and returns trimmed stdout as a String.
  Future<String> capture(
    String executable,
    List<String> arguments, {
    String? workingDirectory,
  }) async {
    final result = await Process.run(
      executable,
      arguments,
      workingDirectory: workingDirectory,
    );

    if (result.exitCode != 0) {
      throw ProcessException(
        executable,
        arguments,
        result.stderr.toString().trim(),
        result.exitCode,
      );
    }

    return result.stdout.toString().trim();
  }
}
