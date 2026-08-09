import 'package:backend/extensions/request_context_extension.dart';

import 'package:backend/repositories/merchant_settings_repository.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    .get => _onGet(context),
    .patch => _onPatch(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final repo = context.read<MerchantSettingsRepository>();
  final tokenPayload = context.tokenPayload;

  try {
    final settings = await repo.getSettingsByMerchantId(tokenPayload.sub);
    return success(
      data: {'settings': settings},
    );
  } on Exception catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPatch(RequestContext context) async {
  final repo = context.read<MerchantSettingsRepository>();
  final tokenPayload = context.tokenPayload;

  try {
    final body = (await context.request.json()) as Map<String, dynamic>;
    final waNotifications = body['waNotifications'] as bool?;
    final lowStockAlerts = body['lowStockAlerts'] as bool?;
    final dailyReports = body['dailyReports'] as bool?;

    final updatedSettings = await repo.updateSettings(
      merchantId: tokenPayload.sub,
      waNotifications: waNotifications,
      lowStockAlerts: lowStockAlerts,
      dailyReports: dailyReports,
    );

    return success(
      data: {'settings': updatedSettings},
    );
  } on Exception catch (e) {
    return error(message: e.toString());
  }
}
