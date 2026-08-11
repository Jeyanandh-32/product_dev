import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/store_row_extension.dart';
import 'package:backend/repositories/store_repository.dart';
import 'package:backend/utils/constraint_errors.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
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

    return success(
      data: {
        'store': storeRow?.toStore(),
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

    final storeRow = await repo.update(
      id: id,
      name: input.name?.trim(),
      storeType: input.storeType?.trim(),
      isActive: input.isActive,
      isOnlineEnabled: input.isOnlineEnabled,
      slug: input.slug?.trim().toLowerCase(),
      updateStoreType: body.containsKey('storeType'),
      updateSlug: body.containsKey('slug'),
    );

    return success(
      data: {
        'store': storeRow?.toStore(),
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return tryConstraintError(e) ?? error(message: e.toString());
  }
}
