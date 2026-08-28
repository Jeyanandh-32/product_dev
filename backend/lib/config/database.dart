import 'dart:io';

import 'package:backend/config/env.dart';
import 'package:backend/database/schema.dart';
import 'package:postgres/postgres.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

class Database {
  const Database._();

  static Pool<Object>? _pool;
  static bool _warmedUp = false;

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
      settings: PoolSettings(
        sslMode: SslMode.disable,
        maxConnectionCount: Env.dbMaxConnections,
      ),
    );
    return _pool!;
  }

  static final db = ts.Database<DatabaseSchema>(
    ts.DatabaseAdapter.postgres(pool),
    ts.SqlDialect.postgres(),
  );

  static Future<void> init() async {
    await ensureWarm();
  }

  /// Ensures database connection is active to avoid first-request latency.
  static Future<void> ensureWarm() async {
    if (_warmedUp) return;
    _warmedUp = true;
    try {
      await pool.execute('SELECT 1');
    } catch (_) {
      _warmedUp = false;
    }
  }

  static Future<void> close() async {
    await _pool?.close();
  }

  static Future<void> runMigrations() async {
    final connection = await Connection.open(
      Endpoint(
        host: Env.dbHost,
        database: Env.dbName,
        username: Env.dbUsername,
        password: Env.dbPassword,
        port: Env.dbPort,
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );

    await _executeSqlFiles(connection);
    await connection.close();
  }

  static Future<void> _executeSqlFiles(Connection connection) async {
    final dir = Directory('migrations');
    if (!dir.existsSync()) return;

    final files =
        dir
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.sql'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));

    for (final file in files) {
      final content = await file.readAsString();
      final statements = content
          .split(';')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty);

      for (final statement in statements) {
        if (statement.startsWith('--') && !statement.contains('\n')) continue;
        try {
          await connection.execute(statement);
        } catch (_) {}
      }
    }
  }
}
