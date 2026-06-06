import 'package:dotenv/dotenv.dart';

class Env {
  const Env._();

  static late final DotEnv _env;

  static String get accessSecret => _env['JWT_ACCESS_SECRET'] ?? '';
  static String get refreshSecret => _env['JWT_REFRESH_SECRET'] ?? '';
  static String get dbHost => _env['DB_HOST'] ?? '127.0.0.1';
  static String get dbUsername => _env['DB_USERNAME'] ?? 'postgres';
  static String get dbPassword => _env['DB_PASSWORD'] ?? '';
  static int get dbPort => int.parse(_env['DB_PORT'] ?? '5432');
  static String get dbName => _env['DB_NAME'] ?? 'test_db';

  static void init() {
    _env = DotEnv(includePlatformEnvironment: true)..load();
  }
}
