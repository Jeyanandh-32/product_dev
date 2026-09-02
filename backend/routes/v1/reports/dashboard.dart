import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    .get => _onGet(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final storeIdError = context.validateStoreId();
  if (storeIdError != null) return storeIdError;

  final queryParams = context.request.uri.queryParameters;
  final fromDateStr = queryParams['fromDate'];
  final toDateStr = queryParams['toDate'];

  final fromDate = fromDateStr != null && fromDateStr.isNotEmpty
      ? DateTime.tryParse(fromDateStr)?.toUtc()
      : null;
  DateTime? toDate;
  if (toDateStr != null && toDateStr.isNotEmpty) {
    final parsed = DateTime.tryParse(toDateStr);
    if (parsed != null) {
      toDate = DateTime.utc(
        parsed.year,
        parsed.month,
        parsed.day,
        23,
        59,
        59,
        999,
      );
    }
  }

  final orderRepo = context.orderRepo;
  final tokenPayload = context.tokenPayload;

  try {
    final analytics = await orderRepo.getDashboardAnalytics(
      merchantId: tokenPayload.sub,
      storeId: context.storeId,
      fromDate: fromDate,
      toDate: toDate,
    );

    return success(data: analytics);
  } catch (e) {
    return error(message: e.toString());
  }
}
