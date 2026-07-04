import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  const SecureStorage._();

  static const _storage = FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';

  static String? _cachedToken;
  static bool _hasLoaded = false;

  static Future<void> saveAccessToken(String token) async {
    _cachedToken = token;
    _hasLoaded = true;
    await _storage.write(key: _accessTokenKey, value: token);
  }

  static Future<String?> getAccessToken() async {
    if (_hasLoaded) {
      return _cachedToken;
    }
    _cachedToken = await _storage.read(key: _accessTokenKey);
    _hasLoaded = true;
    return _cachedToken;
  }

  static Future<void> deleteAccessToken() async {
    _cachedToken = null;
    _hasLoaded = true;
    await _storage.delete(key: _accessTokenKey);
  }

  static Future<void> clearAll() async {
    _cachedToken = null;
    _hasLoaded = true;
    await _storage.deleteAll();
  }
}
