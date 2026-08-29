part of '../schema.dart';

@PrimaryKey(['id'])
abstract final class CustomerRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  String get name;

  @Unique.field()
  String get mobileNumber;

  String get pinHash;

  @DefaultValue.now
  DateTime get createdAt;

  @DefaultValue.now
  DateTime get updatedAt;
}

@PrimaryKey(['customerId', 'storeId'])
abstract final class CustomerRecentStoresRow extends Row {
  @References(
    table: 'customers',
    field: 'id',
    onDelete: .cascade,
  )
  String get customerId;

  @References(
    table: 'stores',
    field: 'id',
    onDelete: .cascade,
  )
  String get storeId;

  @DefaultValue.now
  DateTime get lastVisitedAt;
}

@PrimaryKey(['customerId', 'storeId'])
abstract final class CustomerStoreWalletRow extends Row {
  @References(
    table: 'customers',
    field: 'id',
    onDelete: .cascade,
  )
  String get customerId;

  @References(
    table: 'stores',
    field: 'id',
    onDelete: .cascade,
  )
  String get storeId;

  @DefaultValue(0)
  int get walletBalance;

  @DefaultValue.now
  DateTime get createdAt;

  @DefaultValue.now
  DateTime get updatedAt;
}

@PrimaryKey(['id'])
abstract final class CustomerWalletTransactionRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  @References(
    table: 'customers',
    field: 'id',
    onDelete: .cascade,
  )
  String get customerId;

  @References(
    table: 'stores',
    field: 'id',
    onDelete: .cascade,
  )
  String get storeId;

  int get amount;

  String get type; // 'top_up', 'order_debit', 'refund_credit'

  String? get reference;

  @DefaultValue('completed')
  String get status;

  @DefaultValue.now
  DateTime get createdAt;
}
