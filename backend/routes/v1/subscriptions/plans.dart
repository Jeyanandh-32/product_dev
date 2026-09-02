import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/subscription_row_extension.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';

/// Handler for `GET /v1/subscriptions/plans`.
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final repo = context.subscriptionRepo;
  final rows = await repo.getPlans();
  final plans = rows.map((r) => r.toSubscriptionPlan().toJson()).toList();

  return success(data: {'plans': plans});
}
