import 'dart:io';

import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/bottle_return_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

/// POST /v1/bottle-returns/coupons/redeem
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final body = await context.validateBody(BottleReturnValidator.redeemCoupon);
    final input = BottleReturnCouponRedeem.fromJson(body);
    final merchantId = input.merchantId;
    final code = input.code;
    final storeId = input.storeId;
    final orderId = input.orderId;

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
  } on ResponseException catch (e) {
    return e.response;
  }
}
