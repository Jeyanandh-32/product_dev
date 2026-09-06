import 'dart:io';
import 'dart:math';

import 'package:backend/extensions/merchant_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/store_row_extension.dart';
import 'package:backend/extensions/subscription_row_extension.dart';
import 'package:backend/extensions/terminal_row_extension.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/services/auth_service.dart';
import 'package:backend/utils/constraint_errors.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(RequestContext context) async {
  final storeId = context.request.uri.queryParameters['storeId'];
  final tokenPayload = context.tokenPayload;

  return switch (context.request.method) {
    .get =>
      (tokenPayload.role == .terminal && tokenPayload.terminalCode != null)
          ? _onGetTerminal(context, tokenPayload)
          : (storeId != null && storeId.isNotEmpty && !storeId.isUUID())
          ? badRequest(message: 'Invalid store id.')
          : _onGet(context, storeId),
    .post => context.validateStoreId() ?? _onPost(context, context.storeId),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGetTerminal(
  RequestContext context,
  TokenPayload tokenPayload,
) async {
  final repo = context.terminalRepo;
  final subRepo = context.subscriptionRepo;

  try {
    final terminalCode = tokenPayload.terminalCode;
    if (terminalCode == null || terminalCode.isEmpty) {
      return badRequest(message: 'Terminal not exists');
    }
    final terminalRow = await repo.getByCode(terminalCode);
    if (terminalRow == null) return badRequest(message: 'Terminal not exists');
    if (!terminalRow.isActive) {
      return forbidden(message: 'This Terminal is deactivated.');
    }

    final storeRow = await repo.getStoreById(terminalRow.storeId);
    final merchantRow = await repo.getMerchantById(terminalRow.merchantId);
    final subRow = await subRepo.getStoreSubscription(terminalRow.storeId);

    return success(
      data: {
        'terminal': terminalRow.toTerminal().toJson(),
        'store': storeRow?.toStore().toJson(),
        'subscription': subRow?.toStoreSubscription().toJson(),
        'merchant': merchantRow?.toMerchant().toJson(),
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onGet(RequestContext context, String? storeId) async {
  final (pageError, page) = context.parsePage();
  if (pageError != null) return pageError;
  final (sizeError, size) = context.parseSize();
  if (sizeError != null) return sizeError;

  final repo = context.terminalRepo;
  final tokenPayload = context.tokenPayload;

  try {
    final activeParam = context.request.uri.queryParameters['isActive']
        ?.toLowerCase();
    final isActive = switch (activeParam) {
      'true' => true,
      'false' => false,
      'all' => null,
      _ => null,
    };
    final offset = (page - 1) * size;
    final (total, terminalRows) = await (
      repo.count(
        merchantId: tokenPayload.sub,
        storeId: storeId,
        isActive: isActive,
      ),
      repo.getAll(
        storeId: storeId,
        merchantId: tokenPayload.sub,
        isActive: isActive,
        limit: size,
        offset: offset,
      ),
    ).wait;

    return success(
      data: {
        'currentPage': page,
        'pageSize': size,
        'totalItems': total,
        'totalPages': (total / size).ceil(),
        'terminals': terminalRows.map((s) => s.toTerminal()).toList(),
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPost(RequestContext context, String storeId) async {
  final repo = context.terminalRepo;
  final tokenPayload = context.tokenPayload;

  try {
    final body = await context.validateBody(TerminalValidator.create);
    final input = TerminalCreate.fromJson(body);
    final passwordHash = await PasswordService.hash(input.password);
    final terminalRow = await repo.create(
      code: _generateTerminalCode(),
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
  final random = Random.secure();
  return List.generate(
    12,
    (_) => 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'[random.nextInt(36)],
  ).join();
}
