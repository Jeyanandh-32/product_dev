import 'package:backend/extensions/terminal_row_extension.dart';
import 'package:backend/repositories/terminal_repository.dart';
import 'package:backend/services/auth_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(
  RequestContext context,
  String code,
) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context, code),
    HttpMethod.put || HttpMethod.patch => _onPutOrPatch(context, code),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context, String code) async {
  final repo = context.read<TerminalRepository>();

  try {
    final terminalRow = await repo.getByCode(code);

    return success(
      data: {
        'terminal': terminalRow?.toTerminal(),
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPutOrPatch(RequestContext context, String code) async {
  final repo = context.read<TerminalRepository>();

  final jsonBody = await context.request.json();

  if (jsonBody is! Map<String, Object?>) return inValidBody();

  final body = jsonBody;

  final name = body['name'] as String?;
  final password = body['password'] as String?;
  final isActive = body['isActive'] as bool?;

  final errorMessage = TerminalValidator.update(
    name: name,
    password: password,
    isActive: isActive,
  );

  if (errorMessage != null) {
    return badRequest(message: errorMessage);
  }

  String? passwordHash;
  if (password != null && password.isNotEmpty) {
    passwordHash = await AuthService.hashPassword(password);
  }

  try {
    final terminalRow = await repo.update(
      code: code,
      name: name?.trim(),
      passwordHash: passwordHash,
      isActive: isActive,
    );

    return success(
      data: {
        'terminal': terminalRow?.toTerminal(),
      },
    );
  } catch (e) {
    if (e.toString().contains('unique_store_terminal_name')) {
      return badRequest(
        message: 'You already have a terminal with this name in this store.',
      );
    }
    return error(message: e.toString());
  }
}
