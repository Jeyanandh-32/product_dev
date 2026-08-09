import 'package:backend/database/schema.dart';
import 'package:models/models.dart';

extension MerchantSettingsRowExtension on MerchantSettingsRow {
  MerchantSettings toMerchantSettings() => MerchantSettings(
    merchantId: merchantId,
    waNotifications: waNotifications,
    lowStockAlerts: lowStockAlerts,
    dailyReports: dailyReports,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
