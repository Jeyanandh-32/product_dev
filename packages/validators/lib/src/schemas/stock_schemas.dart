part of '../schemas.dart';

/// Schema definition for initial stock record creation payload.
@Schema()
abstract class $StockCreate {
  @StringField(minLength: 1, description: 'Product ID')
  String get productId;

  @StringField(minLength: 1, description: 'Store ID')
  String get storeId;

  @IntegerField(minimum: 0, description: 'Stock quantity')
  int? get quantity;

  @IntegerField(minimum: 0, description: 'Low stock threshold')
  int? get lowStockThreshold;
}

/// Schema definition for product stock adjustment and configuration payload.
@Schema()
abstract class $StockUpdate {
  @IntegerField(minimum: 0, description: 'Stock quantity')
  int? get quantity;

  @IntegerField(minimum: 0, description: 'Low stock threshold')
  int? get lowStockThreshold;

  @Field(description: 'Is stock monitored')
  bool? get stockMonitor;
}
