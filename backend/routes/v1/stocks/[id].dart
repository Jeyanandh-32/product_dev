import 'dart:io';

import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/stock_row_extension.dart';
import 'package:backend/repositories/stock_repository.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  if (!id.isUUID()) {
    return badRequest(message: 'Invalid stock id.');
  }

  return switch (context.request.method) {
    .put || .patch => _onPutOrPatch(context, id),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onPutOrPatch(RequestContext context, String id) async {
  final repo = context.read<StockRepository>();

  try {
    final body = await context.validateBody(StockValidator.update);
    final input = StockUpdate.fromJson(body);

    final updatedRow = await repo.update(
      id: id,
      quantity: input.quantity,
      lowStockThreshold: input.lowStockThreshold,
      stockMonitor: input.stockMonitor,
      transactionType:
          body['transactionType'] as String? ??
          body['adjustmentType'] as String?,
      amount: body['amount'] as int?,
      reason: body['reason'] as String?,
      customReason: body['customReason'] as String?,
    );

    if (updatedRow == null) {
      return error(
        message: 'Stock not found.',
        statusCode: HttpStatus.notFound,
      );
    }

    return success(
      data: {
        'stock': updatedRow.toStock(),
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return error(message: e.toString());
  }
}
