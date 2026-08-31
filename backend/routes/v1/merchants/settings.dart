import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/merchant_settings_repository.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

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
    final body = await context.validateBody(MerchantValidator.updateSettings);
    final input = MerchantSettingsUpdate.fromJson(body);
    final waNotifications = input.waNotifications;
    final lowStockAlerts = input.lowStockAlerts;
    final dailyReports = input.dailyReports;

    final updatedSettings = await repo.updateSettings(
      merchantId: tokenPayload.sub,
      waNotifications: waNotifications,
      lowStockAlerts: lowStockAlerts,
      dailyReports: dailyReports,
    );

    return success(
      data: {'settings': updatedSettings},
    );
  } on ResponseException catch (e) {
    return e.response;
  } on Exception catch (e) {
    return error(message: e.toString());
  }
}
