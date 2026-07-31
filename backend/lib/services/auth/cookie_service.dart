import 'dart:io';

/// Handles HTTP cookie building, parsing, and clearing.
class CookieService {
  const CookieService._();

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
