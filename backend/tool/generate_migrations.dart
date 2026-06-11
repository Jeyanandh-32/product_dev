// ignore_for_file: avoid_print

import 'dart:io';

void main() async {
  final migrationsDir = Directory('migrations');

  if (!migrationsDir.existsSync()) {
    print('Error: migrations/ directory not found.');
    exit(1);
  }

  final files =
      migrationsDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.sql'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  if (files.isEmpty) {
    print('No .sql files found in migrations/');
    exit(1);
  }

  final buffer = StringBuffer()
    ..writeln('// Generated file do not edit manually')
    ..writeln('// Run: dart tool/generate_migrations.dart')
    ..writeln()
    ..writeln("import 'package:migrant/migrant.dart';")
    ..writeln("import 'package:migrant/testing.dart';")
    ..writeln()
    ..writeln('final migrations = InMemory([');

  for (final file in files) {
    final filename = file.uri.pathSegments.last;
    final version = filename.split('_').first;
    final sql = await file.readAsString();

    final statements = sql
        .split(';')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    buffer
      ..writeln('  // $filename')
      ..writeln('  Migration(')
      ..writeln("    '$version',")
      ..writeln('    [');
    for (final stmt in statements) {
      final isMultiline = stmt.contains('\n');
      if (isMultiline) {
        buffer.writeln("      '''\n$stmt''',");
      } else {
        buffer.writeln("      '$stmt',");
      }
    }
    buffer
      ..writeln('    ],')
      ..writeln('  ),');
  }

  buffer.writeln(']);');

  final outputFile = File('lib/src/migrations.dart');
  await outputFile.parent.create(recursive: true);
  await outputFile.writeAsString(buffer.toString());

  print('Generated lib/src/migrations.dart with ${files.length} migrations');
}
