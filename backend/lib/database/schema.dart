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
  Table<StockTransactionRow> get stockTransactions;
  Table<TerminalRow> get terminals;
  Table<OrderRow> get orders;
  Table<OrderItemRow> get orderItems;
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

@PrimaryKey(['id'])
abstract final class OrderRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  @References(table: 'merchants', field: 'id', onDelete: .cascade)
  String get merchantId;

  @References(table: 'stores', field: 'id', onDelete: .cascade)
  String get storeId;

  @Unique.field()
  String get orderReference;

  int get billNo;

  String get source;

  String get type;

  String get status;

  String get paymentStatus;

  String get paymentMethod;

  int get subtotal;

  int get taxTotal;

  int get grandTotal;

  @References(table: 'terminals', field: 'code', onDelete: .setNull)
  String? get terminalCode;

  @DefaultValue.now
  DateTime get createdAt;

  @DefaultValue.now
  DateTime get updatedAt;

  @DefaultValue(0)
  int get discountTotal;
}

@PrimaryKey(['id'])
abstract final class OrderItemRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  @References(table: 'orders', field: 'id')
  String get orderId;

  @References(table: 'products', field: 'id')
  String get productId;

  @References(table: 'stores', field: 'id')
  String get storeId;

  int get quantity;

  int get unitPrice;

  @SqlOverride.field(dialect: 'postgres', columnType: 'NUMERIC(5, 2)')
  double get taxRate;

  @DefaultValue(0)
  int get discount;
}
