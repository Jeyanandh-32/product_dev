import 'dart:io';

import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/bottle_return_dispenser_handler.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:validators/validators.dart';

/// POST /v1/orders/dispense
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final body = await context.validateBody(
      BottleReturnValidator.dispenseStickers,
    );
    final input = BottleReturnIotDispense.fromJson(body);
    final orderReference = input.orderReference;

    final handler = context.bottleReturnDispenserHandler;
    final result = await handler.getDispenserOrderPayload(orderReference);

    return switch (result) {
      DispenserOrderNotFound() => Response.json(
        statusCode: HttpStatus.notFound,
        body: {
          'success': false,
          'message': 'Order not found for given reference.',
        },
      ),
      DispenserOrderAlreadyCompleted() => Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'success': false,
          'message': 'Order has already been completed and dispensed.',
        },
      ),
      DispenserOrderCancelled() => Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'success': false, 'message': 'Order has been cancelled.'},
      ),
      DispenserOrderSuccess(:final order, :final bottleTokens) => Response.json(
        body: {
          'success': true,
          'data': {
            'order': order.toJson(),
            'orderId': order.id,
            'orderReference': order.orderReference,
            'billNo': order.billNo,
            if (bottleTokens != null && bottleTokens.isNotEmpty)
              'bottleTokens': bottleTokens
                  .map((BottleQrToken t) => t.toJson())
                  .toList(),
          },
        },
      ),
    };
  } on ResponseException catch (e) {
    return e.response;
  }
}
