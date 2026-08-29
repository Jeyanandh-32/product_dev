part of '../schema.dart';

@PrimaryKey(['id'])
abstract final class BottleQrTokenRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  @Unique.field()
  String get token;

  @References(table: 'merchants', field: 'id', onDelete: .cascade)
  String get merchantId;

  @References(table: 'stores', field: 'id', onDelete: .cascade)
  String get storeId;

  @References(table: 'orders', field: 'id', onDelete: .cascade)
  String get orderId;

  @References(table: 'products', field: 'id', onDelete: .cascade)
  String get productId;

  @DefaultValue('digital')
  String get rewardMode;

  String? get customerPhone;

  @DefaultValue('active')
  String get status;

  DateTime? get returnedAt;

  String? get returnedStoreId;

  @DefaultValue.now
  DateTime get createdAt;
}

@PrimaryKey(['id'])
@Unique(
  name: 'uniqueMerchantCustomerPhoneCredit',
  fields: ['merchantId', 'customerPhone'],
)
abstract final class BottleCreditRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  @References(table: 'merchants', field: 'id', onDelete: .cascade)
  String get merchantId;

  String get customerPhone;

  @DefaultValue(0)
  int get balance;

  @DefaultValue.now
  DateTime get createdAt;

  @DefaultValue.now
  DateTime get updatedAt;
}

@PrimaryKey(['id'])
abstract final class BottleCreditTransactionRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  @References(table: 'merchants', field: 'id', onDelete: .cascade)
  String get merchantId;

  String get customerPhone;

  int get amount;

  String get type;

  String? get referenceOrderId;

  String? get storeId;

  @DefaultValue.now
  DateTime get createdAt;
}

@PrimaryKey(['id'])
abstract final class BottlePhysicalCouponRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  @Unique.field()
  String get code;

  @References(table: 'merchants', field: 'id', onDelete: .cascade)
  String get merchantId;

  @References(table: 'stores', field: 'id', onDelete: .cascade)
  String get storeId;

  int get amount;

  @DefaultValue('active')
  String get status;

  DateTime? get redeemedAt;

  String? get redeemedOrderId;

  @DefaultValue.now
  DateTime get createdAt;
}
