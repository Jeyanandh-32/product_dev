import 'dart:io';

import 'package:backend/extensions/request_context_extension.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

/// POST /v1/bottle-returns/coupons/validate
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final body = await context.validateBody(
      BottleReturnValidator.validateCoupon,
    );
    final input = BottleReturnCouponValidate.fromJson(body);
    final merchantId = input.merchantId;
    final code = input.code;
    final storeId = input.storeId;

    final repo = context.bottleReturnRepo;
    final coupon = await repo.validatePhysicalCoupon(
      merchantId: merchantId,
      code: code,
      storeId: storeId,
    );

    if (coupon == null) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'success': false,
          'message': 'Coupon is invalid, expired, or already redeemed.',
        },
      );
    }

    return Response.json(
      body: {
        'success': true,
        'data': {'coupon': coupon.toJson()},
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  }
}
