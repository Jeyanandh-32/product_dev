import 'dart:io';

import 'package:migrant/migrant.dart';

/// Reads sequential SQL migration files from the local filesystem directory.
class FilesystemMigrationSource implements MigrationSource {
  const FilesystemMigrationSource(this.directory);

  final Directory directory;

  List<File> _getSortedMigrationFiles() {
    if (!directory.existsSync()) return [];
    return directory
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.sql'))
        .toList()
      ..sort(
        (a, b) => a.uri.pathSegments.last.compareTo(b.uri.pathSegments.last),
      );
  }

  @override
  Future<Migration> getInitial() async {
    final files = _getSortedMigrationFiles();
    if (files.isEmpty) {
      return Migration('0000', []);
    }
    return _parseFile(files.first);
  }

  @override
  Future<Migration?> getNext(String version) async {
    final files = _getSortedMigrationFiles();
    final nextFile = files
        .where((f) => f.uri.pathSegments.last.compareTo(version) > 0)
        .firstOrNull;
    if (nextFile == null) return null;
    return _parseFile(nextFile);
  }

  Future<Migration> _parseFile(File file) async {
    final version = file.uri.pathSegments.last;
    final content = await file.readAsString();
    final statements = content
        .split(';')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty && (!s.startsWith('--') || s.contains('\n')))
        .toList();
    return Migration(version, statements);
  }
}
