import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/store_row_extension.dart';
import 'package:backend/repositories/store_repository.dart';
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
    HttpMethod.get => _onGet(context, id),
    HttpMethod.put || HttpMethod.patch => _onPutOrPatch(context, id),
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

    final storeRow = await repo.update(
      id: id,
      name: (body['name'] as String?)?.trim(),
      storeType: (body['storeType'] as String?)?.trim(),
      isActive: body['isActive'] as bool?,
      updateStoreType: body.containsKey('storeType'),
    );

    return success(
      data: {
        'store': storeRow?.toStore(),
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    if (e.toString().contains('unique_merchant_store_name')) {
      return badRequest(
        message: 'You already have a store with this name.',
      );
    }
    return error(message: e.toString());
  }
}
