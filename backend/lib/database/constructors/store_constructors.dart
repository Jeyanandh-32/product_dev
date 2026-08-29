part of '../schema.dart';

/// Constructs a [StoreRow] instance.
StoreRow constructStoreRow({
  required String id,
  required String merchantId,
  required String name,
  required bool isActive,
  required bool isOnlineEnabled,
  required DateTime createdAt,
  required DateTime updatedAt,
  String? storeType,
  String? activePaymentProvider,
  String? slug,
}) => _$StoreRow._(id, merchantId, name, storeType, isActive, isOnlineEnabled, activePaymentProvider, slug, createdAt, updatedAt);

/// Constructs a [StorePhonePeConfigRow] instance.
StorePhonePeConfigRow constructStorePhonePeConfigRow({
  required String id,
  required String storeId,
  required bool isEnabled,
  required String env,
  required int saltIndex,
  required bool enableUpi,
  required bool enableCards,
  required bool enableNetBanking,
  required bool enableEmi,
  required bool enableWallets,
  required String webhookAuthType,
  required DateTime createdAt,
  required DateTime updatedAt,
  String? clientId,
  String? clientVersion,
  String? clientSecret,
  String? saltKey,
  String? allowedUpiApps,
  String? webhookSecretKey,
}) => _$StorePhonePeConfigRow._(id, storeId, isEnabled, env, clientId, clientVersion, clientSecret, saltKey, saltIndex, enableUpi, enableCards, enableNetBanking, enableEmi, enableWallets, allowedUpiApps, webhookAuthType, webhookSecretKey, createdAt, updatedAt);
