import 'dart:io';

import 'package:backend/enums/user_role.dart';
import 'package:backend/extensions/customer_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/services/auth/cookie_service.dart';
import 'package:backend/services/auth/jwt_service.dart';
import 'package:backend/services/auth/password_service.dart';
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
  final repo = context.read<CustomerRepository>();

  try {
    final body = await context.validateBody(CustomerValidator.register);
    final input = CustomerRegister.fromJson(body);

    final pinHash = await PasswordService.hash(input.pin.trim());

    final customerRow = await repo.create(
      name: input.name.trim(),
      mobileNumber: input.mobileNumber.trim(),
      pinHash: pinHash,
    );

    final customer = customerRow.toCustomer();

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

    return Response.json(
      statusCode: HttpStatus.created,
      body: {
        'status': 'success',
        'message': 'Customer registered successfully.',
        'data': {
          'customer': customer.toJson(),
        },
      },
      headers: {
        HttpHeaders.setCookieHeader: cookies,
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return tryConstraintError(e) ??
        Response.json(
          statusCode: HttpStatus.internalServerError,
          body: {
            'status': 'error',
            'message': e.toString(),
          },
        );
  }
}
