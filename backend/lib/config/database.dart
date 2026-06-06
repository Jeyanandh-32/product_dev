import 'dart:io';

import 'package:backend/config/env.dart';
import 'package:postgres/postgres.dart';

class Database {
  const Database._();

  static late Connection _connection;

  static Connection get connection => _connection;

  static Future<void> init() async {
    _connection = await _connect();
  }

  static Future<Connection> _connect() async {
    final conn = await Connection.open(
      Endpoint(
        host: Env.dbHost,
        database: Env.dbName,
        username: Env.dbUsername,
        password: Env.dbPassword,
        port: Env.dbPort,
      ),
      settings: const ConnectionSettings(sslMode: .disable),
    );

    return conn;
  }

  static Future<void> close() async {
    await _connection.close();
  }

  static Future<void> runMigrations() async {
    final migrationsDir = Directory('migrations');

    final files =
        migrationsDir
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.sql'))
            .toList()
          ..sort(
            (a, b) => a.path.compareTo(b.path),
          );

    for (final file in files) {
      final sql = await file.readAsString();

      final statements = sql
          .split(';')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      for (final statement in statements) {
        await _connection.execute(statement);
      }

      // ignore: avoid_print
      print('Migration applied: ${file.path}');
    }
  }
}
