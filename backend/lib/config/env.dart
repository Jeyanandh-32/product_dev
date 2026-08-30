import 'dart:io';

import 'package:dotenv/dotenv.dart';

class Env {
  const Env._();

  static DotEnv? _env;

  static DotEnv get _instance {
    if (_env == null) init();
    return _env!;
  }

  static String get accessSecret => _instance['JWT_ACCESS_SECRET'] ?? '';
  static String get refreshSecret => _instance['JWT_REFRESH_SECRET'] ?? '';
  static String get dbHost => _instance['DB_HOST'] ?? '127.0.0.1';
  static String get dbUsername => _instance['DB_USERNAME'] ?? 'postgres';
  static String get dbPassword => _instance['DB_PASSWORD'] ?? '';
  static int get dbPort => int.parse(_instance['DB_PORT'] ?? '5432');
  static String get dbName => _instance['DB_NAME'] ?? 'test_db';
  static String get allowedOrigin =>
      _instance['ALLOWED_ORIGIN'] ?? 'http://localhost:3000';

  static int get dbMaxConnections =>
      int.tryParse(_instance['DB_MAX_CONNECTIONS'] ?? '10') ?? 10;

  static String? get phonepePlatformMerchantId =>
      _instance['PHONEPE_PLATFORM_MERCHANT_ID'];
  static String? get phonepePlatformClientId =>
      _instance['PHONEPE_PLATFORM_CLIENT_ID'] ??
      _instance['PHONEPE_PLATFORM_MERCHANT_ID'];
  static String? get phonepePlatformClientSecret =>
      _instance['PHONEPE_PLATFORM_CLIENT_SECRET'];
  static String? get phonepePlatformClientVersion =>
      _instance['PHONEPE_PLATFORM_CLIENT_VERSION'] ?? '1';
  static String? get phonepePlatformSaltKey =>
      _instance['PHONEPE_PLATFORM_SALT_KEY'];
  static int get phonepePlatformSaltIndex =>
      int.tryParse(_instance['PHONEPE_PLATFORM_SALT_INDEX'] ?? '1') ?? 1;
  static String get phonepePlatformEnv =>
      _instance['PHONEPE_PLATFORM_ENV'] ?? 'UAT';

  static void init({bool force = false}) {
    if (_env != null && !force) return;
    final dotEnv = DotEnv(includePlatformEnvironment: true);
    if (File('.env').existsSync()) {
      dotEnv.load();
    } else if (File('backend/.env').existsSync()) {
      dotEnv.load(['backend/.env']);
    } else if (File('../backend/.env').existsSync()) {
      dotEnv.load(['../backend/.env']);
    }
    _env = dotEnv;
  }

  static void reload() => init(force: true);
}
