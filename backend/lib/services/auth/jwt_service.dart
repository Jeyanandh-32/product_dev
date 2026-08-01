import 'package:backend/config/env.dart';
import 'package:backend/enums/user_role.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

/// Handles JWT token generation and verification.
class JwtService {
  const JwtService._();

  static String generateAccessToken({
    required String id,
    required UserRole role,
    String? terminalCode,
  }) {
    final jwt = JWT(
      {
        'sub': id,
        'role': role.name,
        if (terminalCode != null) 'terminalCode': terminalCode,
      },
    );

    return jwt.sign(
      SecretKey(Env.accessSecret),
      expiresIn: role == .terminal ? null : const Duration(hours: 24),
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
}
