import 'dart:io';
import 'package:backend/repositories/bottle_return_repository.dart';
import 'package:dart_frog/dart_frog.dart';

/// POST /v1/bottle-returns/coupons/validate
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final merchantId = body['merchantId'] as String?;
  final code = body['code'] as String?;
  final storeId = body['storeId'] as String?;

  if (merchantId == null || code == null || storeId == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'success': false, 'message': 'Missing required fields for coupon validation.'},
    );
  }

  final repo = context.read<BottleReturnRepository>();
  final coupon = await repo.validatePhysicalCoupon(
    merchantId: merchantId,
    code: code,
    storeId: storeId,
  );

  if (coupon == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'success': false, 'message': 'Coupon is invalid, expired, or already redeemed.'},
    );
  }

  return Response.json(
    body: {
      'success': true,
      'data': {'coupon': coupon.toJson()},
    },
  );
}
