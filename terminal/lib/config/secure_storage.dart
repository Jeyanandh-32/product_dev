import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  const SecureStorage._();

  static const _storage = FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';

  // Access Token
  static Future<void> saveAccessToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  static Future<String?> getAccessToken() =>
      _storage.read(key: _accessTokenKey);

  static Future<void> deleteAccessToken() =>
      _storage.delete(key: _accessTokenKey);

  // Clear all
  static Future<void> clearAll() => _storage.deleteAll();
}
