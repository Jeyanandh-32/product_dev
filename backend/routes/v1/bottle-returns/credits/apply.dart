import 'dart:io';

import 'package:backend/extensions/request_context_extension.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

/// POST /v1/bottle-returns/credits/apply
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final body = await context.validateBody(BottleReturnValidator.applyCredit);
    final input = BottleReturnCreditApply.fromJson(body);
    final merchantId = input.merchantId;
    final customerPhone = input.customerPhone;
    final amount = input.amount;
    final storeId = input.storeId;
    final orderId = input.orderId;

    final repo = context.bottleReturnRepo;
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
        body: {
          'success': false,
          'message': 'Insufficient credit balance to apply discount.',
        },
      );
    }

    return Response.json(
      body: {
        'success': true,
        'data': {'success': true, 'amountApplied': amount},
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  }
}
