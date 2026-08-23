import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/store_row_extension.dart';
import 'package:backend/repositories/store_repository.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:typed_sql/typed_sql.dart' hide Database;

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    .get => _onGet(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final (pageError, page) = context.parsePage();
  if (pageError != null) return pageError;

  final (sizeError, size) = context.parseSize();
  if (sizeError != null) return sizeError;

  final repo = context.read<StoreRepository>();

  try {
    final slug = context.request.uri.queryParameters['slug'];
    if (slug != null && slug.isNotEmpty) {
      final storeRow = await repo.getBySlug(slug.trim().toLowerCase());
      if (storeRow == null) {
        return badRequest(message: 'Online store not found.');
      }
      final btlConfig = await Database.db.bottleReturnConfigs
          .where((c) => c.storeId.equals(toExpr(storeRow.id)) & c.isEnabled.equals(toExpr(true)))
          .first
          .fetch();
      return success(data: {'store': storeRow.toStore(isBottleReturnEnabled: btlConfig != null).toJson()});
    }

    final offset = (page - 1) * size;
    final totalFuture = repo.countOnlineStores();
    final storeRowsFuture = repo.getOnlineStores(limit: size, offset: offset);

    final (total, storeRows) = await (totalFuture, storeRowsFuture).wait;

    final btlConfigs = await Database.db.bottleReturnConfigs
        .where((c) => c.isEnabled.equals(toExpr(true)))
        .fetch();
    final configuredStoreIds = btlConfigs.map((c) => c.storeId).toSet();

    final stores = storeRows
        .map((s) => s.toStore(isBottleReturnEnabled: configuredStoreIds.contains(s.id)).toJson())
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
