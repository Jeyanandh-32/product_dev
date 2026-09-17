part of '../schemas.dart';

/// Schema definition for product creation payload.
@Schema()
abstract class $ProductCreate {
  @StringField(minLength: 1, maxLength: 255, description: 'Product name')
  String get name;

  @StringField(minLength: 1, description: 'Category ID')
  String get categoryId;

  @StringField(minLength: 1, description: 'Counter ID')
  String? get counterId;

  @DoubleField(minimum: 0, description: 'Base price')
  double get basePrice;

  @DoubleField(minimum: 0, description: 'Selling price')
  double get sellingPrice;

  @StringField(maxLength: 100, description: 'SKU')
  String? get sku;

  @StringField(maxLength: 100, description: 'Barcode')
  String? get barcode;

  @StringField(maxLength: 255, description: 'Product description')
  String? get description;

  @StringField(maxLength: 255, description: 'Product image URL')
  String? get imageUrl;

  @DoubleField(minimum: 0, description: 'Tax rate')
  double? get taxRate;
}

/// Schema definition for product update payload.
@Schema()
abstract class $ProductUpdate {
  @StringField(minLength: 1, maxLength: 255, description: 'Product name')
  String? get name;

  @StringField(minLength: 1, description: 'Category ID')
  String? get categoryId;

  @StringField(minLength: 1, description: 'Counter ID')
  String? get counterId;

  @DoubleField(minimum: 0, description: 'Base price')
  double? get basePrice;

  @DoubleField(minimum: 0, description: 'Selling price')
  double? get sellingPrice;

  @StringField(maxLength: 100, description: 'SKU')
  String? get sku;

  @StringField(maxLength: 100, description: 'Barcode')
  String? get barcode;

  @StringField(maxLength: 255, description: 'Product description')
  String? get description;

  @StringField(maxLength: 255, description: 'Product image URL')
  String? get imageUrl;

  @DoubleField(minimum: 0, description: 'Tax rate')
  double? get taxRate;

  @Field(description: 'Is active status')
  bool? get isActive;
}
