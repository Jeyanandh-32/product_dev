part of '../schema.dart';

@PrimaryKey(['storeId'])
abstract final class BottleReturnConfigRow extends Row {
  @References(table: 'stores', field: 'id', onDelete: .cascade)
  String get storeId;

  @DefaultValue(true)
  bool get isEnabled;

  @DefaultValue(10)
  int get rewardAmountInRupees;

  String? get iotApiKey;

  @DefaultValue.now
  DateTime get createdAt;

  @DefaultValue.now
  DateTime get updatedAt;
}

@PrimaryKey(['productId'])
abstract final class BottleReturnProductRow extends Row {
  @References(table: 'products', field: 'id', onDelete: .cascade)
  String get productId;

  @References(table: 'stores', field: 'id', onDelete: .cascade)
  String get storeId;

  @DefaultValue(true)
  bool get isReturnable;

  @DefaultValue.now
  DateTime get createdAt;
}
