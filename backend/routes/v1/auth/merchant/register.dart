import 'dart:io';

import 'package:backend/extensions/merchant_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/services/auth_service.dart';
import 'package:backend/utils/constraint_errors.dart';
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
  final repo = context.merchantRepo;

  try {
    final body = await context.validateBody(MerchantValidator.register);
    final input = MerchantRegister.fromJson(body);

    final passwordHash = await PasswordService.hash(input.password);

    final merchantRow = await repo.create(
      name: input.name.trim(),
      businessName: input.businessName.trim(),
      whatsappNumber: input.whatsappNumber.trim(),
      email: input.email.trim().toLowerCase(),
      passwordHash: passwordHash,
    );

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
      statusCode: HttpStatus.created,
      data: {
        'merchant': merchantRow.toMerchant(),
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return tryConstraintError(e) ?? error(message: e.toString());
  }
}
