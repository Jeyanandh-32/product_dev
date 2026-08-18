import 'package:backend/services/order_query_helper.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    .get => OrderQueryHelper.fetchPaginatedOrders(context),
    _ => methodNotAllowed(),
  };
}
