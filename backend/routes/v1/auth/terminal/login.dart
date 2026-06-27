import 'package:backend/extensions/terminal_dto_extension.dart';
import 'package:backend/repositories/terminal_repository.dart';
import 'package:backend/services/auth_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(RequestContext context) async {
  await Future<void>.delayed(const Duration(seconds: 2));
  return switch (context.request.method) {
    .post => _onPost(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onPost(RequestContext context) async {
  final repo = context.read<TerminalRepository>();

  final jsonBody = await context.request.json();

  if (jsonBody is! Map<String, Object?>) return inValidBody();

  final body = jsonBody;

  final code = (body['code'] as String?)?.trim().toUpperCase();
  final password = (body['password'] as String?)?.trim();

  final errorMessage = TerminalValidator.login(code: code, password: password);

  if (errorMessage != null) return badRequest(message: errorMessage);

  try {
    final terminalDto = await repo.getByCode(code!);

    if (terminalDto == null) {
      return badRequest(message: 'Invalid Terminal code or password.');
    }

    if (!terminalDto.isActive) {
      return badRequest(message: 'This terminal is deactivated.');
    }

    final isValid = await AuthService.verifyPassword(
      password!,
      terminalDto.passwordHash,
    );

    if (!isValid) {
      return badRequest(message: 'Invalid Terminal code or password.');
    }

    final accessToken = AuthService.generateAccessToken(
      id: terminalDto.merchantId,
      role: .terminal,
      terminalCode: terminalDto.code,
    );

    return success(
      data: {
        'terminal': terminalDto.toTerminal(),
        'accessToken': accessToken,
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}
