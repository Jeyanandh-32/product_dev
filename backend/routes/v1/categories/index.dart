import 'dart:io';

import 'package:backend/extensions/category_dto_extension.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/category_repository.dart';
import 'package:backend/utils/request_body.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    HttpMethod.post => _onPost(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final parameters = context.request.uri.queryParameters;
  final storeId = parameters['storeId'];

  if (storeId != null && storeId.isNotEmpty && !storeId.isUUID()) {
    return badRequest(message: 'Invalid store id.');
  }

  final repo = context.read<CategoryRepository>();
  final tokenPayload = context.read<TokenPayload>();
  final merchantId = tokenPayload.sub;

  try {
    final categoryDtos = await repo.getAll(
      storeId: storeId,
      merchantId: merchantId,
    );

    final categories = categoryDtos.map((s) => s.toCategory()).toList();

    return success(
      data: {
        'categories': categories,
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPost(RequestContext context) async {
  final parameters = context.request.uri.queryParameters;
  final storeId = parameters['storeId'];

  if (storeId == null || storeId.isEmpty) {
    return badRequest(message: 'Store Id is required.');
  }
  if (!storeId.isUUID()) {
    return badRequest(message: 'Invalid store id.');
  }

  final repo = context.read<CategoryRepository>();
  final tokenPayload = context.read<TokenPayload>();
  final merchantId = tokenPayload.sub;

  final jsonBody = await context.request.json();

  if (jsonBody is! Map<String, Object?>) return inValidBody();

  final body = jsonBody;

  if (
    hasNonStringValue(body, 'name') ||
    hasNonStringValue(body, 'description') ||
    hasNonStringValue(body, 'imageUrl')
  ) {
    return inValidBody();
  }

  final name = body['name'] as String?;
  final description = readOptionalString(body, 'description');
  final imageUrl = readOptionalString(body, 'imageUrl');

  final errorMessage = CategoryValidator.create(
    name: name,
    description: description,
    imageUrl: imageUrl,
  );

  if (errorMessage != null) {
    return badRequest(message: errorMessage);
  }

  try {
    final categoryDto = await repo.create(
      merchantId: merchantId,
      storeId: storeId,
      name: name!.trim(),
      description: description,
      imageUrl: imageUrl,
    );

    return success(
      statusCode: HttpStatus.created,
      data: {
        'category': categoryDto.toCategory(),
      },
    );
  } catch (e) {
    if (e.toString().contains('unique_store_category_name')) {
      return badRequest(
        message: 'You already have a category with this name in this store.',
      );
    }
    return error(message: e.toString());
  }
}
