part of '../schema.dart';

@PrimaryKey(['code'])
@Unique(name: 'uniqueStoreTerminalName', fields: ['storeId', 'name'])
abstract final class TerminalRow extends Row {
  @SqlOverride.field(dialect: 'postgres', columnType: 'VARCHAR(12)')
  String get code;

  @References(
    table: 'merchants',
    field: 'id',
    onDelete: .cascade,
  )
  String get merchantId;

  @References(table: 'stores', field: 'id', onDelete: .cascade)
  String get storeId;

  String get name;

  String get passwordHash;

  @DefaultValue(true)
  bool get isActive;

  @DefaultValue.now
  DateTime get createdAt;

  @DefaultValue.now
  DateTime get updatedAt;
}
