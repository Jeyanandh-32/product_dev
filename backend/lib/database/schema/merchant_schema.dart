part of '../schema.dart';

@PrimaryKey(['id'])
abstract final class MerchantRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  String get name;
  String get businessName;

  @Unique.field()
  String get whatsappNumber;

  @Unique.field()
  String get email;

  String get passwordHash;

  @DefaultValue.now
  DateTime get createdAt;

  @DefaultValue.now
  DateTime get updatedAt;
}

@PrimaryKey(['merchantId'])
abstract final class MerchantSettingsRow extends Row {
  @References(table: 'merchants', field: 'id', onDelete: .cascade)
  String get merchantId;

  @DefaultValue(true)
  bool get waNotifications;

  @DefaultValue(true)
  bool get lowStockAlerts;

  @DefaultValue(false)
  bool get dailyReports;

  @DefaultValue.now
  DateTime get createdAt;

  @DefaultValue.now
  DateTime get updatedAt;
}
