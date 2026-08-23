import 'dart:io';

import 'package:backend/repositories/bottle_return_product_handler.dart';
import 'package:dart_frog/dart_frog.dart';

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
  final body = await context.request.json() as Map<String, dynamic>;
  final storeId = body['storeId'] as String?;
  final productId = body['productId'] as String?;
  final productIds = (body['productIds'] as List<dynamic>?)?.cast<String>();
  final isReturnable = body['isReturnable'] as bool? ?? true;

  if (storeId == null || storeId.trim().isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'success': false, 'message': 'Missing storeId in payload.'},
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

  if (productId == null || productId.trim().isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Missing productId or productIds in payload.',
      },
    );
  }

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
