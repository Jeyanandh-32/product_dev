import 'package:backend/database/schema.dart';

/// Test factory for [StoreRow].
StoreRow createStoreRow({
  String id = 'store-1',
  String merchantId = 'm-1',
  String name = 'Downtown Store',
  String? storeType = 'Grocery',
  bool isActive = true,
  bool isOnlineEnabled = true,
  String? activePaymentProvider = 'phonepe',
  String? slug = 'downtown-store',
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return constructStoreRow(
    id: id,
    merchantId: merchantId,
    name: name,
    isActive: isActive,
    isOnlineEnabled: isOnlineEnabled,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
    storeType: storeType,
    activePaymentProvider: activePaymentProvider,
    slug: slug,
  );
}

/// Test factory for [StorePhonePeConfigRow].
StorePhonePeConfigRow createStorePhonePeConfigRow({
  String id = 'phonepe-cfg-1',
  String storeId = 'store-1',
  bool isEnabled = true,
  String env = 'UAT',
  String? clientId = 'TEST_CLIENT_ID',
  String? clientVersion = 'v1',
  String? clientSecret = 'TEST_CLIENT_SECRET',
  String? saltKey = 'TEST_SALT_KEY',
  int saltIndex = 1,
  bool enableUpi = true,
  bool enableCards = false,
  bool enableNetBanking = false,
  bool enableEmi = false,
  bool enableWallets = false,
  String? allowedUpiApps,
  String webhookAuthType = 'HMAC',
  String? webhookSecretKey = 'TEST_WEBHOOK_SECRET',
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return constructStorePhonePeConfigRow(
    id: id,
    storeId: storeId,
    isEnabled: isEnabled,
    env: env,
    saltIndex: saltIndex,
    enableUpi: enableUpi,
    enableCards: enableCards,
    enableNetBanking: enableNetBanking,
    enableEmi: enableEmi,
    enableWallets: enableWallets,
    webhookAuthType: webhookAuthType,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
    clientId: clientId,
    clientVersion: clientVersion,
    clientSecret: clientSecret,
    saltKey: saltKey,
    allowedUpiApps: allowedUpiApps,
    webhookSecretKey: webhookSecretKey,
  );
}
