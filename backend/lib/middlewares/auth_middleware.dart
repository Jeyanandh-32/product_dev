import 'dart:io';

import 'package:backend/enums/user_role.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/services/auth_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:validators/validators.dart';

Middleware authMiddleware({List<UserRole>? allowedRoles}) {
  return (handler) => (context) async {
    final authorization = context.request.headers['authorization'];

    final bearerToken = AuthService.extractBearerToken(authorization);
    final cookieToken = AuthService.extractAccessCookieToken(
      context.request.headers[HttpHeaders.cookieHeader],
    );

    final token = bearerToken ?? cookieToken;

    if (token == null) return unauthorized(message: 'No token provided.');

    late final TokenPayload tokenPayload;
    try {
      final jwt = AuthService.verifyAccessToken(token);
      tokenPayload = TokenPayload.fromJson(
        jwt.payload as Map<String, Object?>,
      );

      if (!tokenPayload.sub.isUUID()) {
        return forbidden(message: 'Invalid Token.');
      }

      if (allowedRoles != null && !allowedRoles.contains(tokenPayload.role)) {
        return forbidden(message: 'No access.');
      }
    } on JWTExpiredException {
      return forbidden(message: 'Token expired.');
    } on JWTException {
      return forbidden(message: 'Invalid Token');
    }

    return handler(
      context.provide<TokenPayload>(
        () => tokenPayload,
      ),
    );
  };
}

Middleware merchantAuthMiddleware() =>
    authMiddleware(allowedRoles: [.merchant]);

Middleware terminalAuthMiddleware() =>
    authMiddleware(allowedRoles: [.terminal]);

Middleware merchantTerminalAuthMiddleware() =>
    authMiddleware(allowedRoles: [.merchant, .terminal]);
