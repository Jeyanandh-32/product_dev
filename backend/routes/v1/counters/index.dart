import 'dart:io';

import 'package:backend/extensions/counter_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/counter_repository.dart';
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
  final storeId = context.request.uri.queryParameters['storeId'];
  if (storeId != null && storeId.isNotEmpty && !storeId.isUUID()) {
    return badRequest(message: 'Invalid store id.');
  }

  final (pageError, page) = context.parsePage();
  if (pageError != null) return pageError;

  final (sizeError, size) = context.parseSize();
  if (sizeError != null) return sizeError;

  final repo = context.read<CounterRepository>();
  final tokenPayload = context.tokenPayload;

  try {
    final total = await repo.count(
      merchantId: tokenPayload.sub,
      storeId: storeId,
    );

    final offset = (page - 1) * size;
    final counterRows = await repo.getAll(
      storeId: storeId,
      merchantId: tokenPayload.sub,
      limit: size,
      offset: offset,
    );

    final counters = counterRows.map((s) => s.toCounter()).toList();
    final totalPages = (total / size).ceil();

    return success(
      data: {
        'currentPage': page,
        'pageSize': size,
        'totalItems': total,
        'totalPages': totalPages,
        'counters': counters,
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPost(RequestContext context) async {
  final storeIdError = context.validateStoreId();
  if (storeIdError != null) return storeIdError;

  final repo = context.read<CounterRepository>();
  final tokenPayload = context.tokenPayload;

  try {
    final body = await context.validateBody(CounterValidator.create);
    final input = CounterCreate.fromJson(body);

    final counterRow = await repo.create(
      merchantId: tokenPayload.sub,
      storeId: context.storeId,
      name: input.name.trim(),
      description: input.description,
      imageUrl: input.imageUrl,
    );

    return success(
      statusCode: HttpStatus.created,
      data: {'counter': counterRow.toCounter()},
    );
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return tryConstraintError(e) ?? error(message: e.toString());
  }
}
