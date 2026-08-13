import 'package:backend/database/schema.dart';
import 'package:backend/extensions/store_phonepe_config_row_extension.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:typed_sql/typed_sql.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(RequestContext context, String storeId) async {
  if (!storeId.isUUID()) {
    return badRequest(message: 'Invalid store id.');
  }

  return switch (context.request.method) {
    .get => _onGet(context, storeId),
    .put || .patch => _onPutOrPatch(context, storeId),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context, String storeId) async {
  final db = context.read<DatabaseSchema>();

  try {
    final row = await db.storePhonepeConfigs
        .where((c) => c.storeId.equals(toExpr(storeId)))
        .first
        .fetch();

    if (row == null) {
      return success(data: {'config': null});
    }

    return success(data: {'config': row.toStorePhonePeConfig()});
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPutOrPatch(RequestContext context, String storeId) async {
  final db = context.read<DatabaseSchema>();

  try {
    Map<String, dynamic> body;
    try {
      body = await context.request.json() as Map<String, dynamic>;
    } catch (_) {
      return invalidBody();
    }

    final merchantId = (body['merchantId'] as String?)?.trim() ?? '';
    final isEnabled = body['isEnabled'] as bool? ?? true;
    final env = (body['env'] as String?)?.trim().toUpperCase() ?? 'UAT';
    final clientId = body['clientId'] as String?;
    final clientVersion = body['clientVersion'] as String?;
    final clientSecret = body['clientSecret'] as String?;
    final saltKey = body['saltKey'] as String?;
    final saltIndex = body['saltIndex'] as int?;
    final enableUpi = body['enableUpi'] as bool? ?? true;
    final enableCards = body['enableCards'] as bool? ?? true;
    final enableNetBanking = body['enableNetBanking'] as bool? ?? true;
    final enableEmi = body['enableEmi'] as bool? ?? true;
    final enableWallets = body['enableWallets'] as bool? ?? true;
    final allowedUpiApps = body['allowedUpiApps'] as String?;
    final webhookAuthType = (body['webhookAuthType'] as String?) ?? 'HMAC';
    final webhookSecretKey = body['webhookSecretKey'] as String?;

    if (merchantId.isEmpty) {
      return badRequest(message: 'Merchant ID is required.');
    }

    final existing = await db.storePhonepeConfigs
        .where((c) => c.storeId.equals(toExpr(storeId)))
        .first
        .fetch();

    final StorePhonePeConfigRow savedRow;

    if (existing == null) {
      savedRow = await db.storePhonepeConfigs
          .insertValue(
            storeId: storeId,
            isEnabled: isEnabled,
            env: env,
            clientId: clientId,
            clientVersion: clientVersion,
            clientSecret: clientSecret,
            saltKey: saltKey,
            saltIndex: saltIndex,
            enableUpi: enableUpi,
            enableCards: enableCards,
            enableNetBanking: enableNetBanking,
            enableEmi: enableEmi,
            enableWallets: enableWallets,
            allowedUpiApps: allowedUpiApps,
            webhookAuthType: webhookAuthType,
            webhookSecretKey: webhookSecretKey,
          )
          .returnInserted()
          .executeAndFetch();
    } else {
      final updated = await db.storePhonepeConfigs
          .byKey(existing.id)
          .update(
            (c, set) => set(
              isEnabled: toExpr(isEnabled),
              env: toExpr(env),
              clientId: clientId != null ? toExpr(clientId) : c.clientId,
              clientVersion: clientVersion != null ? toExpr(clientVersion) : c.clientVersion,
              clientSecret: clientSecret != null ? toExpr(clientSecret) : c.clientSecret,
              saltKey: saltKey != null ? toExpr(saltKey) : c.saltKey,
              saltIndex: saltIndex != null ? toExpr(saltIndex) : c.saltIndex,
              enableUpi: toExpr(enableUpi),
              enableCards: toExpr(enableCards),
              enableNetBanking: toExpr(enableNetBanking),
              enableEmi: toExpr(enableEmi),
              enableWallets: toExpr(enableWallets),
              allowedUpiApps: allowedUpiApps != null ? toExpr(allowedUpiApps) : c.allowedUpiApps,
              webhookAuthType: toExpr(webhookAuthType),
              webhookSecretKey: webhookSecretKey != null ? toExpr(webhookSecretKey) : c.webhookSecretKey,
              updatedAt: Expr.currentTimestamp,
            ),
          )
          .returnUpdated()
          .executeAndFetch();
      savedRow = updated!;
    }

    return success(data: {'config': savedRow.toStorePhonePeConfig()});
  } catch (e) {
    return error(message: e.toString());
  }
}
