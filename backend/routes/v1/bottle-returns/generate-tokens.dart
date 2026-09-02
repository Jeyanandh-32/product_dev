import 'dart:io';

import 'package:backend/extensions/request_context_extension.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:validators/validators.dart';

/// POST /v1/bottle-returns/generate-tokens
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final body = await context.validateBody(
      BottleReturnValidator.generateTokens,
    );
    final input = BottleReturnTokensGenerate.fromJson(body);
    final merchantId = input.merchantId;
    final storeId = input.storeId;
    final orderId = input.orderId;
    final rewardModeStr = input.rewardMode ?? 'digital';
    final customerPhone = input.customerPhone;

    final items = input.items.map((BottleReturnTokenItem item) {
      return (
        productId: item.productId,
        quantity: item.quantity,
        isReturnable: item.isReturnableBottle ?? true,
      );
    }).toList();

    final repo = context.bottleReturnRepo;
    final tokens = await repo.generateTokensForOrder(
      merchantId: merchantId,
      storeId: storeId,
      orderId: orderId,
      items: items,
      rewardMode: BottleRewardMode.fromString(rewardModeStr),
      customerPhone: customerPhone,
    );

    return Response.json(
      body: {
        'success': true,
        'data': {
          'tokens': tokens.map((BottleQrToken t) => t.toJson()).toList(),
        },
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  }
}
