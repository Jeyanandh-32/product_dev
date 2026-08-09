import 'package:backend/database/schema.dart';
import 'package:backend/extensions/merchant_settings_row_extension.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

class MerchantSettingsRepository {
  MerchantSettingsRepository({required this._db});

  final ts.Database<DatabaseSchema> _db;

  Future<MerchantSettings> getSettingsByMerchantId(
    String merchantId,
  ) async {
    final row = await _db.merchantSettings.byKey(merchantId).fetch();
    if (row != null) return row.toMerchantSettings();

    final insertedRow = await _db.merchantSettings
        .insertValue(
          merchantId: merchantId,
          waNotifications: true,
          lowStockAlerts: true,
          dailyReports: false,
        )
        .returnInserted()
        .executeAndFetch();

    return insertedRow.toMerchantSettings();
  }

  Future<MerchantSettings> updateSettings({
    required String merchantId,
    bool? waNotifications,
    bool? lowStockAlerts,
    bool? dailyReports,
  }) async {
    final existing = await _db.merchantSettings.byKey(merchantId).fetch();
    if (existing == null) {
      final insertedRow = await _db.merchantSettings
          .insertValue(
            merchantId: merchantId,
            waNotifications: waNotifications ?? true,
            lowStockAlerts: lowStockAlerts ?? true,
            dailyReports: dailyReports ?? false,
          )
          .returnInserted()
          .executeAndFetch();

      return insertedRow.toMerchantSettings();
    }

    final row = await _db.merchantSettings
        .byKey(merchantId)
        .update(
          (s, set) => set(
            waNotifications: waNotifications != null
                ? ts.toExpr(waNotifications)
                : s.waNotifications,
            lowStockAlerts: lowStockAlerts != null
                ? ts.toExpr(lowStockAlerts)
                : s.lowStockAlerts,
            dailyReports: dailyReports != null
                ? ts.toExpr(dailyReports)
                : s.dailyReports,
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returnUpdated()
        .executeAndFetch();

    return (row ?? existing).toMerchantSettings();
  }
}
