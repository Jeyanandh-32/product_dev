import 'dart:io';

import 'package:backend/repositories/bottle_return_repository.dart';
import 'package:dart_frog/dart_frog.dart';

/// POST /v1/bottle-returns/coupons/redeem
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final merchantId = body['merchantId'] as String?;
  final code = body['code'] as String?;
  final storeId = body['storeId'] as String?;
  final orderId = body['orderId'] as String?;

  if (merchantId == null ||
      code == null ||
      storeId == null ||
      orderId == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Missing required fields for coupon redemption.',
      },
    );
  }

  final repo = context.read<BottleReturnRepository>();
  final success = await repo.redeemPhysicalCoupon(
    merchantId: merchantId,
    code: code,
    storeId: storeId,
    orderId: orderId,
  );

  if (!success) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Coupon cannot be redeemed (invalid, expired, or already redeemed).',
      },
    );
  }

  return Response.json(
    body: {
      'success': true,
      'data': {'success': true},
    },
  );
}
