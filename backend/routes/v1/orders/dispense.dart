import 'dart:io';
import 'package:backend/repositories/bottle_return_dispenser_handler.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

/// POST /v1/orders/dispense
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final orderReference = body['orderReference'] as String?;

  if (orderReference == null || orderReference.trim().isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'success': false, 'message': 'Missing orderReference in payload.'},
    );
  }

  final handler = context.read<BottleReturnDispenserHandler>();
  final result = await handler.getDispenserOrderPayload(orderReference);

  return switch (result) {
    DispenserOrderNotFound() => Response.json(
        statusCode: HttpStatus.notFound,
        body: {'success': false, 'message': 'Order not found for given reference.'},
      ),
    DispenserOrderAlreadyCompleted() => Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'success': false, 'message': 'Order has already been completed and dispensed.'},
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
              'bottleTokens': bottleTokens.map((BottleQrToken t) => t.toJson()).toList(),
          },
        },
      ),
  };
}
