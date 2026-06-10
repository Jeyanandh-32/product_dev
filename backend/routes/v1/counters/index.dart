import 'dart:io';

import 'package:backend/extensions/counter_dto_extension.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/counter_repository.dart';
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

  final repo = context.read<CounterRepository>();
  final tokenPayload = context.read<TokenPayload>();
  final merchantId = tokenPayload.sub;

  try {
    final counterDtos = await repo.getAll(
      storeId: storeId,
      merchantId: merchantId,
    );

    final counters = counterDtos.map((s) => s.toCounter()).toList();

    return success(
      data: {
        'counters': counters,
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

  final repo = context.read<CounterRepository>();
  final tokenPayload = context.read<TokenPayload>();
  final merchantId = tokenPayload.sub;

  final jsonBody = await context.request.json();

  if (jsonBody is! Map<String, Object?>) return inValidBody();

  final body = jsonBody;

  final name = body['name'] as String?;

  final errorMessage = CounterValidator.create(
    name: name,
  );

  if (errorMessage != null) {
    return badRequest(message: errorMessage);
  }

  try {
    final counterDto = await repo.create(
      merchantId: merchantId,
      storeId: storeId,
      name: name!.trim(),
    );

    return success(
      statusCode: HttpStatus.created,
      data: {
        'counter': counterDto.toCounter(),
      },
    );
  } catch (e) {
    if (e.toString().contains('unique_store_counter_name')) {
      return badRequest(
        message: 'You already have a counter with this name in this store.',
      );
    }
    if (e.toString().contains('counters_pkey')) {
      return badRequest(
        message: 'Something went wrong. Please try again.',
      );
    }
    return error(message: e.toString());
  }
}
