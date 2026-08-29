part of '../schema.dart';

@PrimaryKey(['id'])
@Unique(name: 'uniqueMerchantStoreName', fields: ['merchantId', 'name'])
abstract final class StoreRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  @References(
    table: 'merchants',
    field: 'id',
    onDelete: .cascade,
  )
  String get merchantId;

  String get name;

  String? get storeType;

  @DefaultValue(true)
  bool get isActive;

  @DefaultValue(false)
  bool get isOnlineEnabled;

  @DefaultValue('phonepe')
  String? get activePaymentProvider;

  @Unique.field()
  String? get slug;

  @DefaultValue.now
  DateTime get createdAt;

  @DefaultValue.now
  DateTime get updatedAt;
}

@PrimaryKey(['id'])
abstract final class StorePhonePeConfigRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  @References(
    table: 'stores',
    field: 'id',
    onDelete: .cascade,
  )
  @Unique.field()
  String get storeId;

  @DefaultValue(true)
  bool get isEnabled;

  @DefaultValue('UAT')
  String get env;

  String? get clientId;
  String? get clientVersion;
  String? get clientSecret;
  String? get saltKey;

  @DefaultValue(1)
  int get saltIndex;

  @DefaultValue(true)
  bool get enableUpi;

  @DefaultValue(false)
  bool get enableCards;

  @DefaultValue(false)
  bool get enableNetBanking;

  @DefaultValue(false)
  bool get enableEmi;

  @DefaultValue(false)
  bool get enableWallets;

  String? get allowedUpiApps;

  @DefaultValue('HMAC')
  String get webhookAuthType;

  String? get webhookSecretKey;

  @DefaultValue.now
  DateTime get createdAt;

  @DefaultValue.now
  DateTime get updatedAt;
}
