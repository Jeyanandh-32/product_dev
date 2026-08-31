import 'dart:io';

import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/bottle_return_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

/// GET/PUT/PATCH /v1/bottle-returns/config
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _handleGet(context),
    HttpMethod.put || HttpMethod.patch => _handlePutOrPatch(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _handleGet(RequestContext context) async {
  final storeId = context.request.uri.queryParameters['storeId'];
  if (storeId == null || storeId.trim().isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'success': false, 'message': 'Missing storeId parameter.'},
    );
  }

  final repo = context.read<BottleReturnRepository>();
  final config = await repo.getConfig(storeId.trim());

  return Response.json(
    body: {
      'success': true,
      'data': {'config': config?.toJson()},
    },
  );
}

Future<Response> _handlePutOrPatch(RequestContext context) async {
  try {
    final body = await context.validateBody(BottleReturnValidator.updateConfig);
    final input = BottleReturnConfigUpdate.fromJson(body);
    final storeId = input.storeId;
    final isEnabled = input.isEnabled ?? true;
    final rewardAmount = input.rewardAmountInRupees ?? 10;

    final repo = context.read<BottleReturnRepository>();
    final existing = await repo.getConfig(storeId.trim());
    if (existing == null) {
      return Response.json(
        statusCode: HttpStatus.forbidden,
        body: {
          'success': false,
          'message': 'Bottle return feature is not provisioned for this store.',
        },
      );
    }

    final config = await repo.saveConfig(
      storeId: storeId.trim(),
      isEnabled: isEnabled,
      rewardAmountInRupees: rewardAmount,
      iotApiKey: input.iotApiKey,
    );

    return Response.json(
      body: {
        'success': true,
        'data': {'config': config.toJson()},
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  }
}
