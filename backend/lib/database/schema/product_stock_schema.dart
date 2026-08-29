part of '../schema.dart';

@PrimaryKey(['id'])
@Unique(name: 'uniqueMerchantProductSku', fields: ['merchantId', 'sku'])
@Unique(name: 'uniqueStoreProductName', fields: ['storeId', 'name'])
abstract final class ProductRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  @References(
    table: 'merchants',
    field: 'id',
    onDelete: .cascade,
  )
  String get merchantId;

  @References(table: 'stores', field: 'id', onDelete: .cascade)
  String get storeId;

  String get name;

  String? get sku;

  String? get barcode;

  String? get description;

  String? get imageUrl;

  @References(
    table: 'categories',
    field: 'id',
    onDelete: .setNull,
  )
  String? get categoryId;

  @References(
    table: 'counters',
    field: 'id',
    onDelete: .setNull,
  )
  String? get counterId;

  @DefaultValue(0.00)
  @SqlOverride.field(dialect: 'postgres', columnType: 'NUMERIC(5, 2)')
  double get taxRate;

  @DefaultValue(0)
  int get basePrice;

  @DefaultValue(0)
  int get sellingPrice;

  @DefaultValue(true)
  bool get isActive;

  @DefaultValue.now
  DateTime get createdAt;

  @DefaultValue.now
  DateTime get updatedAt;
}

@PrimaryKey(['id'])
@Unique(name: 'uniqueStoreProductStock', fields: ['storeId', 'productId'])
abstract final class StockRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  @References(
    table: 'products',
    field: 'id',
    onDelete: .cascade,
  )
  String get productId;

  @References(table: 'stores', field: 'id', onDelete: .cascade)
  String get storeId;

  @DefaultValue(0)
  int get quantity;

  @DefaultValue(0)
  int get lowStockThreshold;

  @DefaultValue(false)
  bool get stockMonitor;

  @DefaultValue.now
  DateTime get createdAt;

  @DefaultValue.now
  DateTime get updatedAt;
}

@PrimaryKey(['id'])
abstract final class StockTransactionRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  @References(table: 'products', field: 'id', onDelete: .cascade)
  String get productId;

  @References(table: 'stores', field: 'id', onDelete: .cascade)
  String get storeId;

  String get adjustmentType; // 'add', 'reduce', 'set'

  int get quantity; // amount added, reduced, or set

  String get reason; // 'wastage', 'adjustment', 'restock', 'sale'

  String? get customReason;

  @DefaultValue.now
  DateTime get createdAt;
}
