import 'dart:io';

import 'package:backend/database/schema.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/store_row_extension.dart';
import 'package:backend/utils/constraint_errors.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;
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

  final repo = context.storeRepo;
  final tokenPayload = context.tokenPayload;

  try {
    final offset = (page - 1) * size;
    final totalFuture = repo.count(merchantId: tokenPayload.sub);
    final storeRowsFuture = repo.getAll(
      merchantId: tokenPayload.sub,
      limit: size,
      offset: offset,
    );

    final (total, storeRows) = await (totalFuture, storeRowsFuture).wait;

    var configuredStoreIds = <String>{};
    try {
      final bottleRepo = context.bottleReturnRepo;
      final bottleConfigs = await bottleRepo.db.bottleReturnConfigs
          .where((c) => ts.toExpr(true))
          .fetch();
      configuredStoreIds = bottleConfigs.map((c) => c.storeId).toSet();
    } catch (_) {}

    final stores = storeRows
        .map((s) => s.toStore(
              isBottleReturnEnabled: configuredStoreIds.contains(s.id),
            ))
        .toList();
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
  final repo = context.storeRepo;
  final tokenPayload = context.tokenPayload;

  try {
    final body = await context.validateBody(StoreValidator.create);
    final input = StoreCreate.fromJson(body);

    if (input.isOnlineEnabled ?? false) {
      return badRequest(
        message:
            'Cannot create a store with online ordering enabled. Please contact system administrator.',
      );
    }

    final rawStoreType = input.storeType?.trim();
    final storeTypeEnum = rawStoreType != null && rawStoreType.isNotEmpty
        ? StoreType.values.firstWhere(
            (t) => t.name == rawStoreType,
            orElse: () => StoreType.other,
          )
        : null;

    final storeRow = await repo.create(
      merchantId: tokenPayload.sub,
      name: input.name.trim(),
      storeType: storeTypeEnum,
      slug: input.slug?.trim().toLowerCase(),
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
