import 'package:backend/database/schema.dart';

/// Test factory for [MerchantRow].
MerchantRow createMerchantRow({
  String id = 'm-1',
  String name = 'Jack Owner',
  String businessName = 'SuperMart',
  String whatsappNumber = '9876543210',
  String email = 'jack@test.com',
  String passwordHash = 'hash',
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return constructMerchantRow(
    id: id,
    name: name,
    businessName: businessName,
    whatsappNumber: whatsappNumber,
    email: email,
    passwordHash: passwordHash,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
  );
}

/// Test factory for [MerchantSettingsRow].
MerchantSettingsRow createMerchantSettingsRow({
  String merchantId = 'm-1',
  bool waNotifications = true,
  bool lowStockAlerts = true,
  bool dailyReports = false,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return constructMerchantSettingsRow(
    merchantId: merchantId,
    waNotifications: waNotifications,
    lowStockAlerts: lowStockAlerts,
    dailyReports: dailyReports,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
  );
}
