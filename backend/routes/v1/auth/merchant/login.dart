import 'dart:io';

import 'package:backend/extensions/merchant_dto_extension.dart';
import 'package:backend/repositories/merchant_repository.dart';
import 'package:backend/services/auth_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    .post => _onPost(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onPost(RequestContext context) async {
  final conn = context.read<Connection>();
  final repo = MerchantRepository(conn: conn);

  final jsonBody = await context.request.json();

  if (jsonBody is! Map<String, Object?>) return inValidBody();

  final body = jsonBody;

  final email = body['email'] as String?;
  final password = body['password'] as String?;

  final errorMessage = MerchantValidator.login(
    email: email,
    password: password,
  );

  if (errorMessage != null) {
    return badRequest(message: errorMessage);
  }

  try {
    final merchantRow = await repo.getByEmail(email!);

    if (merchantRow == null) {
      return badRequest(message: 'Invalid email or password.');
    }

    final isValid = AuthService.verifyPassword(
      password!,
      merchantRow.passwordHash,
    );

    if (!isValid) return badRequest(message: 'Invalid email or password.');

    final accessToken = AuthService.generateAccessToken(
      id: merchantRow.id,
      role: .merchant,
    );

    final refreshToken = AuthService.generateRefreshToken(
      id: merchantRow.id,
      role: .merchant,
    );

    final cookies = [
      AuthService.buildAccessTokenCookie(accessToken),
      AuthService.buildRefreshTokenCookie(refreshToken),
    ];

    return succes(
      headers: {
        HttpHeaders.setCookieHeader: cookies,
      },
      data: {
        'merchant': merchantRow.toMerchant(),
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}
