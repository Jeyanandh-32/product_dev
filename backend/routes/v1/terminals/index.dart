import 'dart:io';
import 'dart:math';

import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/terminal_row_extension.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/terminal_repository.dart';
import 'package:backend/services/auth_service.dart';
import 'package:backend/utils/constraint_errors.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(RequestContext context) async {
  final storeId = context.request.uri.queryParameters['storeId'];
  final tokenPayload = context.tokenPayload;

  switch (context.request.method) {
    case .get:
      if (tokenPayload.role == .terminal && tokenPayload.terminalCode != null) {
        return _onGetTerminal(context, tokenPayload);
      }
      if (storeId != null && storeId.isNotEmpty && !storeId.isUUID()) {
        return badRequest(message: 'Invalid store id.');
      }
      return _onGet(context, storeId);
    case .post:
      final storeIdError = context.validateStoreId();
      if (storeIdError != null) return storeIdError;
      return _onPost(context, context.storeId);
    case .put:
    case .delete:
    case .patch:
    case .head:
    case .options:
      return methodNotAllowed();
  }
}

Future<Response> _onGetTerminal(
  RequestContext context,
  TokenPayload tokenPayload,
) async {
  final repo = context.read<TerminalRepository>();

  try {
    final terminalRow = await repo.getByCode(tokenPayload.terminalCode!);

    if (terminalRow == null) {
      return badRequest(message: 'Terminal not exists');
    }

    if (!terminalRow.isActive) {
      return forbidden(message: 'This Terminal is deactivated.');
    }

    return success(data: {'terminal': terminalRow.toTerminal()});
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onGet(RequestContext context, String? storeId) async {
  final (pageError, page) = context.parsePage();
  if (pageError != null) return pageError;

  final (sizeError, size) = context.parseSize();
  if (sizeError != null) return sizeError;

  final repo = context.read<TerminalRepository>();
  final tokenPayload = context.tokenPayload;

  try {
    final total = await repo.count(
      merchantId: tokenPayload.sub,
      storeId: storeId,
    );

    final offset = (page - 1) * size;
    final terminalRows = await repo.getAll(
      storeId: storeId,
      merchantId: tokenPayload.sub,
      limit: size,
      offset: offset,
    );

    final terminals = terminalRows.map((s) => s.toTerminal()).toList();
    final totalPages = (total / size).ceil();

    return success(
      data: {
        'currentPage': page,
        'pageSize': size,
        'totalItems': total,
        'totalPages': totalPages,
        'terminals': terminals,
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPost(RequestContext context, String storeId) async {
  final repo = context.read<TerminalRepository>();
  final tokenPayload = context.tokenPayload;

  try {
    final body = await context.validateBody(TerminalValidator.create);
    final input = TerminalCreate.fromJson(body);

    final passwordHash = await PasswordService.hash(input.password);
    final code = _generateTerminalCode();

    final terminalRow = await repo.create(
      code: code,
      merchantId: tokenPayload.sub,
      storeId: storeId,
      name: input.name.trim(),
      passwordHash: passwordHash,
    );

    return success(
      statusCode: HttpStatus.created,
      data: {'terminal': terminalRow.toTerminal()},
    );
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return tryConstraintError(e) ?? error(message: e.toString());
  }
}

String _generateTerminalCode() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random.secure();
  return List.generate(12, (_) => chars[random.nextInt(chars.length)]).join();
}
