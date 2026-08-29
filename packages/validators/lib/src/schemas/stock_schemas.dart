part of '../schemas.dart';

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

@Schema()
abstract class $StockUpdate {
  @IntegerField(minimum: 0, description: 'Stock quantity')
  int? get quantity;

  @IntegerField(minimum: 0, description: 'Low stock threshold')
  int? get lowStockThreshold;

  @Field(description: 'Is stock monitored')
  bool? get stockMonitor;
}
