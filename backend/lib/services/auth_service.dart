import 'dart:io';
import 'dart:isolate';

import 'package:backend/config/env.dart';
import 'package:backend/enums/user_role.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthService {
  const AuthService._();

  static Future<String> hashPassword(String password) {
    return Isolate.run(() => BCrypt.hashpw(password, BCrypt.gensalt()));
  }

  static Future<bool> verifyPassword(String password, String hash) {
    return Isolate.run(() => BCrypt.checkpw(password, hash));
  }

  static String generateAccessToken({
    required String id,
    required UserRole role,
  }) {
    final jwt = JWT(
      {
        'sub': id,
        'role': role.name,
      },
    );

    return jwt.sign(
      SecretKey(Env.accessSecret),
      expiresIn: const Duration(hours: 24),
    );
  }

  static String generateRefreshToken({
    required String id,
    required UserRole role,
  }) {
    final jwt = JWT(
      {
        'sub': id,
        'role': role.name,
      },
    );

    return jwt.sign(
      SecretKey(Env.refreshSecret),
      expiresIn: const Duration(days: 30),
    );
  }

  static JWT verifyAccessToken(String accessToken) {
    return JWT.verify(accessToken, SecretKey(Env.accessSecret));
  }

  static JWT verifyRefreshToken(String refreshToken) {
    return JWT.verify(refreshToken, SecretKey(Env.refreshSecret));
  }

  static String buildAccessTokenCookie(String accessToken) {
    final cookie = Cookie('access_token', accessToken)
      ..httpOnly = true
      ..path = '/'
      ..sameSite = .lax
      ..secure = false
      ..maxAge = 7 * 3600;

    return cookie.toString();
  }

  static String buildRefreshTokenCookie(String refreshToken) {
    final cookie = Cookie('refresh_token', refreshToken)
      ..httpOnly = true
      ..path = '/'
      ..sameSite = .lax
      ..secure = false
      ..maxAge = 30 * 24 * 3600;

    return cookie.toString();
  }

  static List<String> removeTokens() {
    final access = Cookie('access_token', '')
      ..httpOnly = true
      ..path = '/'
      ..sameSite = .lax
      ..secure = false
      ..maxAge = 0;
    final refresh = Cookie('refresh_token', '')
      ..httpOnly = true
      ..path = '/'
      ..sameSite = .lax
      ..secure = false
      ..maxAge = 0;

    return [access.toString(), refresh.toString()];
  }

  static String? extractBearerToken(String? authorization) {
    if (authorization == null) {
      return null;
    }

    final parts = authorization.split(' ');

    if (parts.length != 2 || parts.first != 'Bearer' || parts.last.isEmpty) {
      return null;
    }

    return parts.last;
  }

  static String? extractAccessCookieToken(String? cookies) {
    if (cookies == null) {
      return null;
    }

    for (final cookie in cookies.split(';')) {
      final trimmedCookie = cookie.trim();
      if (trimmedCookie.startsWith('access_token=')) {
        return trimmedCookie.substring('access_token='.length);
      }
    }

    return null;
  }

  static String? extractRefreshCookieToken(String? cookies) {
    if (cookies == null) {
      return null;
    }

    for (final cookie in cookies.split(';')) {
      final trimmedCookie = cookie.trim();
      if (trimmedCookie.startsWith('refresh_token=')) {
        return trimmedCookie.substring('refresh_token='.length);
      }
    }

    return null;
  }
}
