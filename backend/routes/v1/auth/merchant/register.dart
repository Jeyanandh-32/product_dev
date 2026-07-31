import 'dart:io';

import 'package:backend/extensions/merchant_row_extension.dart';
import 'package:backend/repositories/merchant_repository.dart';
import 'package:backend/services/auth_service.dart';
import 'package:backend/utils/constraint_errors.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onPost(RequestContext context) async {
  final repo = context.read<MerchantRepository>();

  final jsonBody = await context.request.json();

  if (jsonBody is! Map<String, Object?>) return invalidBody();

  final body = jsonBody;

  final name = body['name'] as String?;
  final businessName = body['businessName'] as String?;
  final whatsappNumber = body['whatsappNumber'] as String?;
  final email = (body['email'] as String?)?.trim().toLowerCase();
  final password = (body['password'] as String?)?.trim();

  final errorMessage = await MerchantValidator.register({
    'name': name,
    'businessName': businessName,
    'whatsappNumber': whatsappNumber,
    'email': email,
    'password': password,
  });

  if (errorMessage != null) {
    return badRequest(message: errorMessage);
  }

  final input = MerchantRegister.fromJson({
    'name': name,
    'businessName': businessName,
    'whatsappNumber': whatsappNumber,
    'email': email,
    'password': password,
  });

  final passwordHash = await PasswordService.hash(input.password);

  try {
    final merchantRow = await repo.create(
      name: input.name.trim(),
      businessName: input.businessName.trim(),
      whatsappNumber: input.whatsappNumber.trim(),
      email: input.email,
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
  } catch (e) {
    return tryConstraintError(e) ?? error(message: e.toString());
  }
}
