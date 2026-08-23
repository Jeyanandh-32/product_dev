import 'dart:io';

import 'package:backend/repositories/bottle_return_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

/// POST /v1/bottle-returns/generate-tokens
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final merchantId = body['merchantId'] as String?;
  final storeId = body['storeId'] as String?;
  final orderId = body['orderId'] as String?;
  final itemsList = body['items'] as List<dynamic>?;
  final rewardModeStr = body['rewardMode'] as String? ?? 'digital';
  final customerPhone = body['customerPhone'] as String?;

  if (merchantId == null ||
      storeId == null ||
      orderId == null ||
      itemsList == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Missing required fields for token generation.',
      },
    );
  }

  final items = itemsList.map((dynamic item) {
    final m = item as Map<String, dynamic>;
    return (
      productId: m['productId'] as String,
      quantity: (m['quantity'] as num).toInt(),
      isReturnable: m['isReturnableBottle'] as bool? ?? true,
    );
  }).toList();

  final repo = context.read<BottleReturnRepository>();
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
      'data': {'tokens': tokens.map((BottleQrToken t) => t.toJson()).toList()},
    },
  );
}
