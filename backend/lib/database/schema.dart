import 'package:typed_sql/typed_sql.dart';

part 'schema.g.dart';

@SqlOverride.schema(naming: Naming.snake_case)
abstract final class DatabaseSchema extends Schema {
  Table<MerchantRow> get merchants;
  Table<StoreRow> get stores;
  Table<CategoryRow> get categories;
  Table<CounterRow> get counters;
  Table<ProductRow> get products;
  Table<StockRow> get stocks;
  Table<TerminalRow> get terminals;
}

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

@PrimaryKey(['id'])
@Unique(name: 'uniqueMerchantStoreName', fields: ['merchantId', 'name'])
abstract final class StoreRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  @References(table: 'merchants', field: 'id', onDelete: ReferentialAction.cascade)
  String get merchantId;

  String get name;
  
  String? get storeType;

  @DefaultValue(true)
  bool get isActive;

  @DefaultValue.now
  DateTime get createdAt;

  @DefaultValue.now
  DateTime get updatedAt;
}

@PrimaryKey(['id'])
@Unique(name: 'uniqueStoreCategoryName', fields: ['storeId', 'name'])
abstract final class CategoryRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  String get name;

  @References(table: 'merchants', field: 'id', onDelete: ReferentialAction.cascade)
  String get merchantId;

  @References(table: 'stores', field: 'id', onDelete: ReferentialAction.cascade)
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

  @References(table: 'merchants', field: 'id', onDelete: ReferentialAction.cascade)
  String get merchantId;

  @References(table: 'stores', field: 'id', onDelete: ReferentialAction.cascade)
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
@Unique(name: 'uniqueMerchantProductSku', fields: ['merchantId', 'sku'])
@Unique(name: 'uniqueStoreProductName', fields: ['storeId', 'name'])
abstract final class ProductRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  @References(table: 'merchants', field: 'id', onDelete: ReferentialAction.cascade)
  String get merchantId;

  @References(table: 'stores', field: 'id', onDelete: ReferentialAction.cascade)
  String get storeId;

  String get name;

  String? get sku;

  String? get barcode;

  String? get description;

  String? get imageUrl;

  @References(table: 'categories', field: 'id', onDelete: ReferentialAction.setNull)
  String? get categoryId;

  @References(table: 'counters', field: 'id', onDelete: ReferentialAction.setNull)
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

  @References(table: 'products', field: 'id', onDelete: ReferentialAction.cascade)
  String get productId;

  @References(table: 'stores', field: 'id', onDelete: ReferentialAction.cascade)
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

@PrimaryKey(['code'])
@Unique(name: 'uniqueStoreTerminalName', fields: ['storeId', 'name'])
abstract final class TerminalRow extends Row {
  @SqlOverride.field(dialect: 'postgres', columnType: 'VARCHAR(12)')
  String get code;

  @References(table: 'merchants', field: 'id', onDelete: ReferentialAction.cascade)
  String get merchantId;

  @References(table: 'stores', field: 'id', onDelete: ReferentialAction.cascade)
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
