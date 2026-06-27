import 'dart:io';
import 'dart:math';

import 'package:backend/extensions/terminal_dto_extension.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/terminal_repository.dart';
import 'package:backend/services/auth_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(RequestContext context) async {
  final parameters = context.request.uri.queryParameters;
  final storeId = parameters['storeId'];

  if (context.request.method == HttpMethod.get) {
    if (storeId != null && storeId.isNotEmpty && !storeId.isUUID()) {
      return badRequest(message: 'Invalid store id.');
    }
    return _onGet(context, storeId);
  } else if (context.request.method == HttpMethod.post) {
    if (storeId == null || storeId.isEmpty) {
      return badRequest(message: 'Store Id is required.');
    }
    if (!storeId.isUUID()) {
      return badRequest(message: 'Invalid store id.');
    }
    return _onPost(context, storeId);
  } else {
    return methodNotAllowed();
  }
}

Future<Response> _onGet(RequestContext context, String? storeId) async {
  final repo = context.read<TerminalRepository>();
  final tokenPayload = context.read<TokenPayload>();
  final merchantId = tokenPayload.sub;

  if (tokenPayload.role == .terminal && tokenPayload.terminalCode != null) {
    try {
      final terminalDto = await repo.getByCode(tokenPayload.terminalCode!);

      if (terminalDto == null) {
        return badRequest(message: 'Terminal not exists');
      }

      if (!terminalDto.isActive) {
        return forbidden(message: 'This Terminal is deactivated.');
      }

      return success(
        data: {
          'terminal': terminalDto.toTerminal(),
        },
      );
    } catch (e) {
      return error(message: e.toString());
    }
  }

  try {
    final terminalDtos = await repo.getAll(
      storeId: storeId,
      merchantId: merchantId,
    );

    final terminals = terminalDtos.map((s) => s.toTerminal()).toList();

    return success(
      data: {
        'terminals': terminals,
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPost(RequestContext context, String storeId) async {
  final repo = context.read<TerminalRepository>();
  final tokenPayload = context.read<TokenPayload>();
  final merchantId = tokenPayload.sub;

  final jsonBody = await context.request.json();

  if (jsonBody is! Map<String, Object?>) return inValidBody();

  final body = jsonBody;

  final name = body['name'] as String?;
  final password = body['password'] as String?;

  final errorMessage = TerminalValidator.create(
    name: name,
    password: password,
  );

  if (errorMessage != null) {
    return badRequest(message: errorMessage);
  }

  final passwordHash = await AuthService.hashPassword(password!);
  final code = _generateTerminalCode();

  try {
    final terminalDto = await repo.create(
      code: code,
      merchantId: merchantId,
      storeId: storeId,
      name: name!.trim(),
      passwordHash: passwordHash,
    );

    return success(
      statusCode: HttpStatus.created,
      data: {
        'terminal': terminalDto.toTerminal(),
      },
    );
  } catch (e) {
    if (e.toString().contains('unique_store_terminal_name')) {
      return badRequest(
        message: 'You already have a terminal with this name in this store.',
      );
    }
    if (e.toString().contains('terminals_pkey')) {
      return badRequest(
        message: 'Something went wrong. Please try again.',
      );
    }
    return error(message: e.toString());
  }
}

String _generateTerminalCode() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random.secure();
  return List.generate(12, (_) => chars[random.nextInt(chars.length)]).join();
}
