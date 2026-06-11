import 'package:backend/config/env.dart';
import 'package:backend/src/migrations.dart';
import 'package:migrant/migrant.dart' as migrant;
import 'package:migrant_db_postgresql/migrant_db_postgresql.dart';
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

    final gateway = PostgreSQLGateway(connection);

    await migrant.Database(gateway).upgrade(migrations);

    await connection.close();
  }
}
