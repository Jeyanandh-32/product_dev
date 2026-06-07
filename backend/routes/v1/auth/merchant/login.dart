import 'dart:io';

import 'package:backend/extensions/merchant_dto_extension.dart';
import 'package:backend/repositories/merchant_repository.dart';
import 'package:backend/services/auth_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    .post => _onPost(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onPost(RequestContext context) async {
  final repo = context.read<MerchantRepository>();

  final jsonBody = await context.request.json();

  if (jsonBody is! Map<String, Object?>) return inValidBody();

  final body = jsonBody;

  final email = (body['email'] as String?)?.trim().toLowerCase();
  final password = (body['password'] as String?)?.trim();

  final errorMessage = MerchantValidator.login(
    email: email,
    password: password,
  );

  if (errorMessage != null) {
    return badRequest(message: errorMessage);
  }

  try {
    final merchantDto = await repo.getByEmail(email!);

    if (merchantDto == null) {
      return badRequest(message: 'Invalid email or password.');
    }

    final isValid = await AuthService.verifyPassword(
      password!,
      merchantDto.passwordHash,
    );

    if (!isValid) return badRequest(message: 'Invalid email or password.');

    final accessToken = AuthService.generateAccessToken(
      id: merchantDto.id,
      role: .merchant,
    );

    final refreshToken = AuthService.generateRefreshToken(
      id: merchantDto.id,
      role: .merchant,
    );

    final cookies = [
      AuthService.buildAccessTokenCookie(accessToken),
      AuthService.buildRefreshTokenCookie(refreshToken),
    ];

    return success(
      headers: {
        HttpHeaders.setCookieHeader: cookies,
      },
      data: {
        'merchant': merchantDto.toMerchant(),
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}
