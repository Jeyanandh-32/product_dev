import 'dart:io';

import 'package:backend/config/env.dart';
import 'package:postgres/postgres.dart';

class Database {
  const Database._();

  static Pool<Object>? _pool;

  static Pool<Object> get pool {
    _pool ??= Pool.withEndpoints(
      [
        Endpoint(
          host: Env.dbHost,
          database: Env.dbName,
          username: Env.dbUsername,
          password: Env.dbPassword,
          port: Env.dbPort,
        ),
      ],
      settings: const PoolSettings(
        sslMode: .disable,
        maxConnectionCount: 10,
      ),
    );
    return _pool!;
  }

  static Future<void> init() async {
    pool;
  }

  static Future<void> close() async {
    await _pool?.close();
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
        await pool.execute(statement);
      }

      // ignore: avoid_print
      print('Migration applied: ${file.path}');
    }
  }
}
