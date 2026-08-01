import 'dart:io';

import 'package:backend/extensions/merchant_row_extension.dart';
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

  if (jsonBody is! Map<String, Object?>) return invalidBody();

  final body = jsonBody;

  final email = (body['email'] as String?)?.trim().toLowerCase();
  final password = (body['password'] as String?)?.trim();

  final errorMessage = await MerchantValidator.login({
    'email': email,
    'password': password,
  });

  if (errorMessage != null) {
    return badRequest(message: errorMessage);
  }

  final input = MerchantLogin.fromJson({
    'email': email,
    'password': password,
  });

  try {
    final merchantRow = await repo.getByEmail(input.email);

    if (merchantRow == null) {
      return badRequest(message: 'Invalid email or password.');
    }

    final isValid = await PasswordService.verify(
      input.password,
      merchantRow.passwordHash,
    );

    if (!isValid) return badRequest(message: 'Invalid email or password.');

    final accessToken = JwtService.generateAccessToken(
      id: merchantRow.id,
      role: .merchant,
    );

    final refreshToken = JwtService.generateRefreshToken(
      id: merchantRow.id,
      role: .merchant,
    );

    final cookies = [
      CookieService.buildAccessTokenCookie(accessToken),
      CookieService.buildRefreshTokenCookie(refreshToken),
    ];

    return success(
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
