import 'dart:io';

import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/bottle_return_product_handler.dart';
import 'package:backend/repositories/bottle_return_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

/// GET/POST /v1/bottle-returns/products
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
      body: {'success': false, 'message': 'Missing storeId query parameter.'},
    );
  }

  final repo = context.read<BottleReturnRepository>();
  final config = await repo.getConfig(storeId.trim());
  if (config == null) {
    return Response.json(
      statusCode: HttpStatus.forbidden,
      body: {
        'success': false,
        'message': 'Store is not provisioned for bottle returns.',
      },
    );
  }

  final handler = context.read<BottleReturnProductHandler>();
  final items = await handler.getProductsForStore(storeId.trim());

  return Response.json(
    body: {
      'success': true,
      'data': items.map((i) => i.toJson()).toList(),
    },
  );
}

Future<Response> _handlePost(RequestContext context) async {
  try {
    final body = await context.validateBody(
      BottleReturnValidator.updateProduct,
    );
    final input = BottleReturnProductUpdate.fromJson(body);
    final storeId = input.storeId;
    final productId = input.productId;
    final productIds = input.productIds;
    final isReturnable = input.isReturnable ?? true;

    final repo = context.read<BottleReturnRepository>();
    final config = await repo.getConfig(storeId.trim());
    if (config == null) {
      return Response.json(
        statusCode: HttpStatus.forbidden,
        body: {
          'success': false,
          'message': 'Store is not provisioned for bottle returns.',
        },
      );
    }

    final handler = context.read<BottleReturnProductHandler>();

    if (productIds != null && productIds.isNotEmpty) {
      await handler.bulkSetProductsReturnable(
        storeId: storeId.trim(),
        productIds: productIds,
        isReturnable: isReturnable,
      );
      return Response.json(
        body: {
          'success': true,
          'message': 'Updated ${productIds.length} products returnable status.',
        },
      );
    }

    if (productId != null && productId.trim().isNotEmpty) {
      await handler.setProductReturnable(
        storeId: storeId.trim(),
        productId: productId.trim(),
        isReturnable: isReturnable,
      );
      return Response.json(
        body: {
          'success': true,
          'message': 'Updated product returnable status.',
        },
      );
    }

    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Missing productId or productIds in payload.',
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  }
}
