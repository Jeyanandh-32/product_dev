import 'dart:io';

import 'package:backend/config/env.dart';
import 'package:backend/config/filesystem_migration_source.dart';
import 'package:backend/database/schema.dart';
import 'package:migrant/migrant.dart' as migrant;
import 'package:migrant_db_postgresql/migrant_db_postgresql.dart';
import 'package:postgres/postgres.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

class Database {
  const Database._();

  static Pool<Object>? _pool;
  static bool _warmedUp = false;

  static Pool<Object> get pool {
    return _pool ??= Pool.withEndpoints(
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

    final dir = Directory('migrations').existsSync()
        ? Directory('migrations')
        : Directory('backend/migrations');

    if (dir.existsSync()) {
      final gateway = PostgreSQLGateway(connection);
      final source = FilesystemMigrationSource(dir);
      await migrant.Database(gateway).upgrade(source);
    }

    await connection.close();
  }
}
