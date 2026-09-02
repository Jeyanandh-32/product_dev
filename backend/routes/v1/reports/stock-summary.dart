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

  final (pageError, page) = context.parsePage();
  if (pageError != null) return pageError;

  final (sizeError, size) = context.parseSize();
  if (sizeError != null) return sizeError;

  final queryParams = context.request.uri.queryParameters;
  final fromDateStr = queryParams['fromDate'];
  final toDateStr = queryParams['toDate'];
  final searchQuery = queryParams['search'];

  DateTime? fromDate;
  if (fromDateStr != null && fromDateStr.isNotEmpty) {
    final parsed = DateTime.tryParse(fromDateStr);
    if (parsed != null) {
      fromDate = DateTime.utc(parsed.year, parsed.month, parsed.day);
    }
  }

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
  } else if (fromDate != null) {
    toDate = DateTime.utc(
      fromDate.year,
      fromDate.month,
      fromDate.day,
      23,
      59,
      59,
      999,
    );
  }

  final stockRepo = context.stockRepo;
  final tokenPayload = context.tokenPayload;

  try {
    final offset = (page - 1) * size;
    final result = await stockRepo.getStockSummaryReport(
      merchantId: tokenPayload.sub,
      storeId: context.storeId,
      fromDate: fromDate,
      toDate: toDate,
      searchQuery: searchQuery,
      limit: size,
      offset: offset,
    );

    final totalPages = (result.total / size).ceil();

    return success(
      data: {
        'currentPage': page,
        'pageSize': size,
        'totalItems': result.total,
        'totalPages': totalPages == 0 ? 1 : totalPages,
        'summary': {
          'totalOpeningStock': result.totalOpeningStock,
          'totalIn': result.totalIn,
          'totalOut': result.totalOut,
          'totalWastage': result.totalWastage,
          'totalAdjustment': result.totalAdjustment,
          'totalClosingStock': result.totalClosingStock,
        },
        'items': result.items.map((i) => i.toJson()).toList(),
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}
