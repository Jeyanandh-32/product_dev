import 'dart:io';

import 'package:backend/extensions/request_context_extension.dart';
import 'package:dart_frog/dart_frog.dart';

/// GET /v1/bottle-returns/credits/balance?phone=...&merchantId=...
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final phone = context.request.uri.queryParameters['phone'];
  final merchantId = context.request.uri.queryParameters['merchantId'];

  if (phone == null ||
      phone.isEmpty ||
      merchantId == null ||
      merchantId.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Missing phone or merchantId parameter.',
      },
    );
  }

  final repo = context.bottleReturnRepo;
  final balance = await repo.getPhoneCreditBalance(
    merchantId: merchantId,
    customerPhone: phone,
  );

  return Response.json(
    body: {
      'success': true,
      'data': {'balance': balance},
    },
  );
}
