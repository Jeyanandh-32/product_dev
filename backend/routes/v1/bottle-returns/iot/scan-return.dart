import 'dart:io';

import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/bottle_return_session_handler.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

/// POST /v1/bottle-returns/iot/scan-return
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final body = await context.validateBody(BottleReturnValidator.scanReturn);
    final input = BottleReturnIotScan.fromJson(body);
    final tokenStrings = input.tokenStrings;
    final storeId = input.storeId;
    final merchantId = input.merchantId;

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
  } on ResponseException catch (e) {
    return e.response;
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
