part of '../schema.dart';

/// Constructs a [MerchantRow] instance.
MerchantRow constructMerchantRow({
  required String id,
  required String name,
  required String businessName,
  required String whatsappNumber,
  required String email,
  required String passwordHash,
  required DateTime createdAt,
  required DateTime updatedAt,
}) => _$MerchantRow._(id, name, businessName, whatsappNumber, email, passwordHash, createdAt, updatedAt);

/// Constructs a [MerchantSettingsRow] instance.
MerchantSettingsRow constructMerchantSettingsRow({
  required String merchantId,
  required bool waNotifications,
  required bool lowStockAlerts,
  required bool dailyReports,
  required DateTime createdAt,
  required DateTime updatedAt,
}) => _$MerchantSettingsRow._(merchantId, waNotifications, lowStockAlerts, dailyReports, createdAt, updatedAt);
