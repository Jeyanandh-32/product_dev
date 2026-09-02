import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/subscription_row_extension.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

/// Handler for `GET /v1/stores/:id/subscription`.
Future<Response> onRequest(RequestContext context, String id) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context, id),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context, String storeId) async {
  final storeRepo = context.storeRepo;
  final store = await storeRepo.getById(storeId);
  if (store == null) {
    return notFound(message: 'Store not found.');
  }

  final subRepo = context.subscriptionRepo;
  var subRow = await subRepo.getStoreSubscription(storeId);

  // Auto-provision trial if missing
  subRow ??= await subRepo.provisionTrial(storeId);

  final planCode =
      SubscriptionPlanCode.tryParse(subRow.planCode) ??
      SubscriptionPlanCode.trial;
  final planRow = await subRepo.getPlanByCode(planCode);
  final txRows = await subRepo.getTransactions(storeId);

  final sub = subRow.toStoreSubscription();
  final plan = planRow?.toSubscriptionPlan();
  final txs = txRows
      .map((t) => t.toSubscriptionTransaction().toJson())
      .toList();

  return success(
    data: {
      'subscription': sub.toJson(),
      'plan': plan?.toJson(),
      'transactions': txs,
    },
  );
}
