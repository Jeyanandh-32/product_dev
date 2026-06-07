import 'dart:io';

import 'package:backend/extensions/store_dto_extension.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/store_repository.dart';
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
  final repo = context.read<StoreRepository>();
  final tokenPayload = context.read<TokenPayload>();
  final merchantId = tokenPayload.sub;

  try {
    final storeDtos = await repo.getAll(
      merchantId: merchantId,
    );

    final stores = storeDtos.map((s) => s.toStore()).toList();

    return success(
      statusCode: HttpStatus.created,
      data: {
        'stores': stores,
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPost(RequestContext context) async {
  final repo = context.read<StoreRepository>();
  final tokenPayload = context.read<TokenPayload>();
  final merchantId = tokenPayload.sub;

  final jsonBody = await context.request.json();

  if (jsonBody is! Map<String, Object?>) return inValidBody();

  final body = jsonBody;

  final name = body['name'] as String?;
  final storeType = body['storeType'] as String?;

  final errorMessage = StoreValidator.create(
    name: name,
    storeType: storeType,
  );

  if (errorMessage != null) {
    return badRequest(message: errorMessage);
  }

  try {
    final storeDto = await repo.create(
      merchantId: merchantId,
      name: name!.trim(),
      storeType: storeType?.trim(),
    );

    return success(
      statusCode: HttpStatus.created,
      data: {
        'store': storeDto.toStore(),
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
