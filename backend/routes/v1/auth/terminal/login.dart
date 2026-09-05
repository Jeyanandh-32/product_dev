import 'dart:io';

import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/terminal_row_extension.dart';
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
  final repo = context.terminalRepo;

  try {
    final body = await context.validateBody(TerminalValidator.login);
    final input = TerminalLogin.fromJson(body);

    final terminalRow = await repo.getByCode(input.code.trim().toUpperCase());

    if (terminalRow == null) {
      return badRequest(message: 'Invalid Terminal code or password.');
    }

    if (!terminalRow.isActive) {
      return badRequest(message: 'This terminal is deactivated.');
    }

    final isValid = await PasswordService.verify(
      input.password.trim(),
      terminalRow.passwordHash,
    );

    if (!isValid) {
      return badRequest(message: 'Invalid Terminal code or password.');
    }

    final accessToken = JwtService.generateAccessToken(
      id: terminalRow.merchantId,
      role: .terminal,
      terminalCode: terminalRow.code,
    );

    final cookies = [
      CookieService.buildAccessTokenCookie(accessToken),
    ];

    return success(
      headers: {
        HttpHeaders.setCookieHeader: cookies,
      },
      data: {
        'terminal': terminalRow.toTerminal(),
        'accessToken': accessToken,
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return error(message: e.toString());
  }
}
