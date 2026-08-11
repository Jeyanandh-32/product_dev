import 'dart:io';

import 'package:backend/enums/user_role.dart';
import 'package:backend/extensions/customer_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/services/auth/cookie_service.dart';
import 'package:backend/services/auth/jwt_service.dart';
import 'package:backend/services/auth/password_service.dart';
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
  final repo = context.read<CustomerRepository>();

  try {
    final body = await context.validateBody(CustomerValidator.login);
    final input = CustomerLogin.fromJson(body);

    final customerRow = await repo.getByMobileNumber(input.mobileNumber.trim());

    if (customerRow == null) {
      return badRequest(message: 'Invalid mobile number or security PIN.');
    }

    final isValid = await PasswordService.verify(
      input.pin.trim(),
      customerRow.pinHash,
    );

    if (!isValid) {
      return badRequest(message: 'Invalid mobile number or security PIN.');
    }

    final accessToken = JwtService.generateAccessToken(
      id: customerRow.id,
      role: UserRole.customer,
    );
    final refreshToken = JwtService.generateRefreshToken(
      id: customerRow.id,
      role: UserRole.customer,
    );

    final cookies = [
      CookieService.buildAccessTokenCookie(accessToken),
      CookieService.buildRefreshTokenCookie(refreshToken),
    ];

    return success(
      headers: {
        HttpHeaders.setCookieHeader: cookies.join(', '),
      },
      data: {
        'customer': customerRow.toCustomer().toJson(),
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return error(message: e.toString());
  }
}
