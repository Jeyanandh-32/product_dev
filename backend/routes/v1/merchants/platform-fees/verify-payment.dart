import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/services/platform_fee_reconciler.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';

/// Explicitly verifies pending platform fee settlements for the merchant.
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onPost(RequestContext context) async {
  try {
    final tokenPayload = context.tokenPayload;
    final repo = context.platformFeeRepo;

    final reconciler = PlatformFeeReconciler(
      platformFeeRepo: repo,
      configRepo: context.platformPhonePeConfigRepo,
    );
    await reconciler.reconcileMerchantPendingSettlements(tokenPayload.sub);

    final summary = await repo.getPlatformFeeSummary(tokenPayload.sub);
    return success(data: summary.toJson());
  } on Exception catch (e) {
    return error(message: e.toString());
  }
}
