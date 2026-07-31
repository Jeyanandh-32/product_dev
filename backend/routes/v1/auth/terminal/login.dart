import 'package:backend/extensions/terminal_row_extension.dart';
import 'package:backend/repositories/terminal_repository.dart';
import 'package:backend/services/auth_service.dart';
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
  final repo = context.read<TerminalRepository>();

  final jsonBody = await context.request.json();

  if (jsonBody is! Map<String, Object?>) return invalidBody();

  final body = jsonBody;

  final code = (body['code'] as String?)?.trim().toUpperCase();
  final password = (body['password'] as String?)?.trim();

  final errorMessage = await TerminalValidator.login({
    'code': code,
    'password': password,
  });

  if (errorMessage != null) return badRequest(message: errorMessage);

  try {
    final terminalRow = await repo.getByCode(code!);

    if (terminalRow == null) {
      return badRequest(message: 'Invalid Terminal code or password.');
    }

    if (!terminalRow.isActive) {
      return badRequest(message: 'This terminal is deactivated.');
    }

    final isValid = await PasswordService.verify(
      password!,
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

    return success(
      data: {
        'terminal': terminalRow.toTerminal(),
        'accessToken': accessToken,
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}
