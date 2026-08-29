import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/terminal_row_extension.dart';
import 'package:backend/repositories/terminal_repository.dart';
import 'package:backend/services/auth_service.dart';
import 'package:backend/utils/constraint_errors.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(
  RequestContext context,
  String code,
) async {
  return switch (context.request.method) {
    .get => _onGet(context, code),
    .put || .patch => _onPutOrPatch(context, code),
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

  try {
    final body = await context.validateBody(TerminalValidator.update);
    final input = TerminalUpdate.fromJson(body);

    String? passwordHash;
    if (input.password case final password? when password.isNotEmpty) {
      passwordHash = await PasswordService.hash(password);
    }

    final terminalRow = await repo.update(
      code: code,
      name: input.name?.trim(),
      passwordHash: passwordHash,
      isActive: input.isActive,
    );

    return success(
      data: {
        'terminal': terminalRow?.toTerminal(),
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return tryConstraintError(e) ?? error(message: e.toString());
  }
}
