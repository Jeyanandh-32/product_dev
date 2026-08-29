part of '../schema.dart';

@PrimaryKey(['code'])
abstract final class SubscriptionPlanRow extends Row {
  String get code;
  String get name;
  int get priceInPaise;
  @DefaultValue('INR')
  String get currency;
  @DefaultValue(30)
  int get durationDays;
  @DefaultValue('[]')
  String get features;
  @DefaultValue.now
  DateTime get createdAt;
  @DefaultValue.now
  DateTime get updatedAt;
}

@PrimaryKey(['id'])
abstract final class StoreSubscriptionRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;
  @References(table: 'stores', field: 'id', onDelete: .cascade)
  String get storeId;
  @References(table: 'subscriptionPlans', field: 'code')
  String get planCode;
  @DefaultValue('trial')
  String get status;
  DateTime get startsAt;
  DateTime get endsAt;
  DateTime? get graceEndsAt;
  @DefaultValue(true)
  bool get autoRenew;
  @DefaultValue.now
  DateTime get createdAt;
  @DefaultValue.now
  DateTime get updatedAt;
}

@PrimaryKey(['id'])
abstract final class SubscriptionTransactionRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;
  @References(table: 'stores', field: 'id', onDelete: .cascade)
  String get storeId;
  @References(table: 'subscriptionPlans', field: 'code')
  String get planCode;
  int get amountInPaise;
  @DefaultValue('INR')
  String get currency;
  @DefaultValue('simulated')
  String get paymentMethod;
  @DefaultValue('completed')
  String get status;
  String? get reference;
  @DefaultValue.now
  DateTime get createdAt;
}
