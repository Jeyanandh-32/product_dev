import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/store_row_extension.dart';
import 'package:backend/repositories/store_repository.dart';
import 'package:backend/utils/constraint_errors.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' hide Database;
import 'package:validators/validators.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  if (!id.isUUID()) {
    return badRequest(message: 'Invalid store id.');
  }

  return switch (context.request.method) {
    .get => _onGet(context, id),
    .put || .patch => _onPutOrPatch(context, id),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context, String id) async {
  final repo = context.read<StoreRepository>();

  try {
    final storeRow = await repo.getById(id);
    if (storeRow == null) {
      return badRequest(message: 'Store not found.');
    }

    final btlConfig = await Database.db.bottleReturnConfigs
        .where((c) => c.storeId.equals(toExpr(id)))
        .first
        .fetch();

    return success(
      data: {
        'store': storeRow.toStore(isBottleReturnEnabled: btlConfig != null),
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPutOrPatch(RequestContext context, String id) async {
  final repo = context.read<StoreRepository>();

  try {
    final body = await context.validateBody(StoreValidator.update);
    final input = StoreUpdate.fromJson(body);

    if (input.isOnlineEnabled ?? false) {
      final configRow = await Database.db.storePhonepeConfigs
          .where(
            (c) =>
                c.storeId.equals(toExpr(id)) & c.isEnabled.equals(toExpr(true)),
          )
          .first
          .fetch();

      final clientId = configRow?.clientId?.trim();
      final clientSecret = configRow?.clientSecret?.trim();
      if (clientId == null ||
          clientId.isEmpty ||
          clientSecret == null ||
          clientSecret.isEmpty) {
        return badRequest(
          message:
              'Cannot enable online ordering for this store. Please contact system administrator.',
        );
      }
    }

    final rawStoreType = input.storeType?.trim();
    final storeTypeEnum = rawStoreType != null && rawStoreType.isNotEmpty
        ? StoreType.values.firstWhere(
            (t) => t.name == rawStoreType,
            orElse: () => StoreType.other,
          )
        : null;

    final storeRow = await repo.update(
      id: id,
      name: input.name?.trim(),
      storeType: storeTypeEnum,
      isActive: input.isActive,
      isOnlineEnabled: input.isOnlineEnabled,
      slug: input.slug?.trim().toLowerCase(),
      updateStoreType: body.containsKey('storeType'),
      updateSlug: body.containsKey('slug'),
    );

    final btlConfig = await Database.db.bottleReturnConfigs
        .where((c) => c.storeId.equals(toExpr(id)))
        .first
        .fetch();

    return success(
      data: {
        'store': storeRow?.toStore(isBottleReturnEnabled: btlConfig != null),
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return tryConstraintError(e) ?? error(message: e.toString());
  }
}
