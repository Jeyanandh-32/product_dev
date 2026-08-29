part of '../schema.dart';

@PrimaryKey(['id'])
@Unique(name: 'uniqueStoreCategoryName', fields: ['storeId', 'name'])
abstract final class CategoryRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  String get name;

  @References(
    table: 'merchants',
    field: 'id',
    onDelete: .cascade,
  )
  String get merchantId;

  @References(table: 'stores', field: 'id', onDelete: .cascade)
  String get storeId;

  @DefaultValue(true)
  bool get isActive;

  String? get description;

  String? get imageUrl;

  @DefaultValue.now
  DateTime get createdAt;

  @DefaultValue.now
  DateTime get updatedAt;
}

@PrimaryKey(['id'])
@Unique(name: 'uniqueStoreCounterName', fields: ['storeId', 'name'])
abstract final class CounterRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  String get name;

  @References(
    table: 'merchants',
    field: 'id',
    onDelete: .cascade,
  )
  String get merchantId;

  @References(table: 'stores', field: 'id', onDelete: .cascade)
  String get storeId;

  @DefaultValue(true)
  bool get isActive;

  String? get description;

  String? get imageUrl;

  @DefaultValue.now
  DateTime get createdAt;

  @DefaultValue.now
  DateTime get updatedAt;
}
