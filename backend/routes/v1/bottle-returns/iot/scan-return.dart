import 'dart:io';
import 'package:backend/repositories/bottle_return_session_handler.dart';
import 'package:dart_frog/dart_frog.dart';

/// POST /v1/bottle-returns/iot/scan-return
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final tokenStrings =
      (body['tokenStrings'] as List<dynamic>?)?.cast<String>();
  final storeId = body['storeId'] as String?;
  final merchantId = body['merchantId'] as String?;

  if (tokenStrings == null ||
      tokenStrings.isEmpty ||
      storeId == null ||
      merchantId == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Missing tokenStrings, storeId, or merchantId in payload.',
      },
    );
  }

  try {
    final handler = context.read<BottleReturnSessionHandler>();
    final result = await handler.processReturnBatch(
      tokenStrings: tokenStrings,
      storeId: storeId,
      merchantId: merchantId,
    );

    return Response.json(
      body: {
        'success': true,
        'data': {'result': result.toJson()},
      },
    );
  } catch (e) {
    final message = e is ArgumentError
        ? (e.message?.toString() ?? e.toString())
        : e.toString();
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'success': false, 'message': message},
    );
  }
}
