import 'dart:io';

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
    HttpMethod.put || HttpMethod.patch => _onPutOrPatch(context, id),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onPutOrPatch(RequestContext context, String id) async {
  final repo = context.read<StockRepository>();

  final jsonBody = await context.request.json();
  if (jsonBody is! Map<String, Object?>) return inValidBody();

  final body = jsonBody;

  final quantityVal = body['quantity'];
  if (quantityVal != null && quantityVal is! int) {
    return badRequest(message: 'quantity must be an integer.');
  }

  final lowStockThresholdVal = body['lowStockThreshold'];
  if (lowStockThresholdVal != null && lowStockThresholdVal is! int) {
    return badRequest(message: 'lowStockThreshold must be an integer.');
  }

  final stockMonitorVal = body['stockMonitor'];
  if (stockMonitorVal != null && stockMonitorVal is! bool) {
    return badRequest(message: 'stockMonitor must be a boolean.');
  }

  final quantity = quantityVal as int?;
  final lowStockThreshold = lowStockThresholdVal as int?;
  final stockMonitor = stockMonitorVal as bool?;

  final quantityPresent = body.containsKey('quantity');
  final lowStockThresholdPresent = body.containsKey('lowStockThreshold');
  final stockMonitorPresent = body.containsKey('stockMonitor');

  final errorMessage = StockValidator.update(
    quantity: quantity,
    lowStockThreshold: lowStockThreshold,
    stockMonitor: stockMonitor,
    quantityPresent: quantityPresent,
    lowStockThresholdPresent: lowStockThresholdPresent,
    stockMonitorPresent: stockMonitorPresent,
  );

  if (errorMessage != null) {
    return badRequest(message: errorMessage);
  }

  try {
    final updatedRow = await repo.update(
      id: id,
      quantity: quantity,
      lowStockThreshold: lowStockThreshold,
      stockMonitor: stockMonitor,
    );

    if (updatedRow == null) {
      return error(message: 'Stock not found.', statusCode: HttpStatus.notFound);
    }

    return success(
      data: {
        'stock': updatedRow.toStock(),
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}
