import 'dart:io';

import 'package:backend/enums/user_role.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/services/auth_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:validators/validators.dart';

/// Comprehensive authentication middleware validating Bearer / Cookie JWTs.
/// Supports `publicPaths` allowing public access for guest users (e.g. stores and catalog browsing).
Middleware authMiddleware({
  List<UserRole>? allowedRoles,
  List<HttpMethod>? notAllowedMethods,
  Map<UserRole, List<HttpMethod>>? roleRestrictedMethods,
  List<String>? publicPaths,
}) {
  return (handler) => (context) async {
    final path = context.request.uri.path;

    // Check if the current route is marked public for all or GET operations
    final isPublic = publicPaths != null &&
        publicPaths.any((p) => path == p || path.startsWith('$p/'));

    final authorization = context.request.headers['authorization'];
    final bearerToken = CookieService.extractBearerToken(authorization);
    final cookieToken = CookieService.extractAccessCookieToken(
      context.request.headers[HttpHeaders.cookieHeader],
    );
    final token = bearerToken ?? cookieToken;

    if (token == null) {
      if (isPublic) {
        return handler(context);
      }
      return unauthorized(message: 'No token provided.');
    }

    late final TokenPayload tokenPayload;

    try {
      final jwt = JwtService.verifyAccessToken(token);

      tokenPayload = TokenPayload.fromJson(
        jwt.payload as Map<String, Object?>,
      );

      if (!tokenPayload.sub.isUUID()) {
        if (isPublic) return handler(context);
        return forbidden(message: 'Invalid Token.');
      }

      if (allowedRoles != null && !allowedRoles.contains(tokenPayload.role)) {
        if (isPublic) return handler(context);
        return forbidden(message: 'No access.');
      }

      if (notAllowedMethods != null &&
          notAllowedMethods.contains(context.request.method)) {
        return forbidden(message: 'No access.');
      }

      final restrictedMethods = roleRestrictedMethods?[tokenPayload.role];

      if (restrictedMethods != null &&
          restrictedMethods.contains(context.request.method)) {
        return forbidden(message: 'No access.');
      }
    } on JWTExpiredException {
      if (isPublic) return handler(context);
      return forbidden(message: 'Token expired.');
    } on JWTException {
      if (isPublic) return handler(context);
      return forbidden(message: 'Invalid Token');
    }

    return handler(
      context.provide<TokenPayload>(() => tokenPayload),
    );
  };
}

Middleware merchantAuthMiddleware() =>
    authMiddleware(allowedRoles: [.merchant]);

Middleware terminalAuthMiddleware() =>
    authMiddleware(allowedRoles: [.terminal]);

Middleware merchantTerminalAuthMiddleware({
  Map<UserRole, List<HttpMethod>>? roleRestrictedMethods,
  List<String>? publicPaths,
}) => authMiddleware(
  allowedRoles: [.merchant, .terminal],
  roleRestrictedMethods: roleRestrictedMethods,
  publicPaths: publicPaths,
);

Middleware customerAuthMiddleware({List<String>? publicPaths}) =>
    authMiddleware(
      allowedRoles: [.customer],
      publicPaths: publicPaths,
    );
