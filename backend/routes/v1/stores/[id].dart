import 'package:backend/extensions/store_dto_extension.dart';
import 'package:backend/repositories/store_repository.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  return switch (context.request.method) {
    .get => _onGet(context, id),
    .put || .patch => _onPutOrPatch(context, id),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context, String id) async {
  final repo = context.read<StoreRepository>();

  try {
    final storeDto = await repo.getById(id);

    return success(
      data: {
        'store': storeDto?.toStore(),
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPutOrPatch(RequestContext context, String id) async {
  final repo = context.read<StoreRepository>();

  final jsonBody = await context.request.json();

  if (jsonBody is! Map<String, Object?>) return inValidBody();

  final body = jsonBody;

  final name = body['name'] as String?;
  final storeType = body['storeType'] as String?;
  final isActive = body['isActive'] as bool?;

  final errorMessage = StoreValidator.update(
    name: name,
    storeType: storeType,
    isActive: isActive,
  );

  if (errorMessage != null) {
    return badRequest(message: errorMessage);
  }

  try {
    final storeDto = await repo.update(
      id: id,
      name: name?.trim(),
      storeType: storeType?.trim(),
      isActive: isActive,
    );

    return success(
      data: {
        'store': storeDto?.toStore(),
      },
    );
  } catch (e) {
    if (e.toString().contains('unique_merchant_store_name')) {
      return badRequest(
        message: 'You already have a store with this name.',
      );
    }
    return error(message: e.toString());
  }
}
