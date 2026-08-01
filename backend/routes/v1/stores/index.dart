import 'dart:io';

import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/store_row_extension.dart';
import 'package:backend/repositories/store_repository.dart';
import 'package:backend/utils/constraint_errors.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    .get => _onGet(context),
    .post => _onPost(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final (pageError, page) = context.parsePage();
  if (pageError != null) return pageError;

  final (sizeError, size) = context.parseSize();
  if (sizeError != null) return sizeError;

  final repo = context.read<StoreRepository>();
  final tokenPayload = context.tokenPayload;

  try {
    final total = await repo.count(
      merchantId: tokenPayload.sub,
    );

    final offset = (page - 1) * size;
    final storeRows = await repo.getAll(
      merchantId: tokenPayload.sub,
      limit: size,
      offset: offset,
    );

    final stores = storeRows.map((s) => s.toStore()).toList();
    final totalPages = (total / size).ceil();

    return success(
      data: {
        'currentPage': page,
        'pageSize': size,
        'totalItems': total,
        'totalPages': totalPages,
        'stores': stores,
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPost(RequestContext context) async {
  final repo = context.read<StoreRepository>();
  final tokenPayload = context.tokenPayload;

  try {
    final body = await context.validateBody(StoreValidator.create);
    final input = StoreCreate.fromJson(body);

    final storeRow = await repo.create(
      merchantId: tokenPayload.sub,
      name: input.name.trim(),
      storeType: input.storeType?.trim(),
    );

    return success(
      statusCode: HttpStatus.created,
      data: {'store': storeRow.toStore()},
    );
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return tryConstraintError(e) ?? error(message: e.toString());
  }
}
