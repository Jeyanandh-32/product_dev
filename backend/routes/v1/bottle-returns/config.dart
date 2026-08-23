import 'dart:io';
import 'package:backend/repositories/bottle_return_repository.dart';
import 'package:dart_frog/dart_frog.dart';

/// GET/POST /v1/bottle-returns/config
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _handleGet(context),
    HttpMethod.post => _handlePost(context),
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

Future<Response> _handlePost(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final storeId = body['storeId'] as String?;
  final isEnabled = body['isEnabled'] as bool? ?? true;
  final rewardAmount = (body['rewardAmountInRupees'] as num?)?.toInt() ?? 10;

  if (storeId == null || storeId.trim().isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'success': false, 'message': 'Missing storeId parameter.'},
    );
  }

  if (rewardAmount <= 0) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'success': false, 'message': 'Reward amount must be greater than 0.'},
    );
  }

  final repo = context.read<BottleReturnRepository>();
  final config = await repo.saveConfig(
    storeId: storeId.trim(),
    isEnabled: isEnabled,
    rewardAmountInRupees: rewardAmount,
  );

  return Response.json(
    body: {
      'success': true,
      'data': {'config': config.toJson()},
    },
  );
}
