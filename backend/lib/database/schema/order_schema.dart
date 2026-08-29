part of '../schema.dart';

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

  @DefaultValue(0)
  int get walletDeduction;

  @DefaultValue(0)
  int get platformFee;

  @References(table: 'customers', field: 'id', onDelete: .setNull)
  String? get customerId;
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
