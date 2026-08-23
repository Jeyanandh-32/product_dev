import 'dart:io';
import 'package:backend/repositories/bottle_return_repository.dart';
import 'package:dart_frog/dart_frog.dart';

/// POST /v1/bottle-returns/credits/apply
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final merchantId = body['merchantId'] as String?;
  final customerPhone = body['customerPhone'] as String?;
  final amount = (body['amount'] as num?)?.toInt();
  final storeId = body['storeId'] as String?;
  final orderId = body['orderId'] as String?;

  if (merchantId == null || customerPhone == null || amount == null || storeId == null || amount <= 0) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'success': false, 'message': 'Missing or invalid fields for credit application.'},
    );
  }

  final repo = context.read<BottleReturnRepository>();
  final success = await repo.applyCreditDeduction(
    merchantId: merchantId,
    customerPhone: customerPhone,
    amount: amount,
    storeId: storeId,
    orderId: orderId,
  );

  if (!success) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'success': false, 'message': 'Insufficient credit balance to apply discount.'},
    );
  }

  return Response.json(
    body: {
      'success': true,
      'data': {'success': true, 'amountApplied': amount},
    },
  );
}
