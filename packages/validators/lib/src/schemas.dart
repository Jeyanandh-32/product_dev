import 'package:schemantic/schemantic.dart';
import 'package:validators/src/validation_patterns.dart';

part 'schemas.g.dart';

@Schema()
abstract class $CategoryCreate {
  @StringField(minLength: 1, maxLength: 255, description: 'Category name')
  String get name;

  @StringField(maxLength: 255, description: 'Category description')
  String? get description;

  @StringField(maxLength: 255, description: 'Category image URL')
  String? get imageUrl;
}

@Schema()
abstract class $CategoryUpdate {
  @StringField(minLength: 1, maxLength: 255, description: 'Category name')
  String? get name;

  @Field(description: 'Is active status')
  bool? get isActive;

  @StringField(maxLength: 255, description: 'Category description')
  String? get description;

  @StringField(maxLength: 255, description: 'Category image URL')
  String? get imageUrl;
}

@Schema()
abstract class $CounterCreate {
  @StringField(minLength: 1, maxLength: 255, description: 'Counter name')
  String get name;

  @StringField(maxLength: 255, description: 'Counter description')
  String? get description;

  @StringField(maxLength: 255, description: 'Counter image URL')
  String? get imageUrl;
}

@Schema()
abstract class $CounterUpdate {
  @StringField(minLength: 1, maxLength: 255, description: 'Counter name')
  String? get name;

  @Field(description: 'Is active status')
  bool? get isActive;

  @StringField(maxLength: 255, description: 'Counter description')
  String? get description;

  @StringField(maxLength: 255, description: 'Counter image URL')
  String? get imageUrl;
}

@Schema()
abstract class $MerchantRegister {
  @StringField(minLength: 1, description: 'Merchant name')
  String get name;

  @StringField(minLength: 1, description: 'Business name')
  String get businessName;

  @StringField(
    pattern: ValidationPatterns.whatsapp,
    description: 'Whatsapp number',
  )
  String get whatsappNumber;

  @StringField(
    pattern: r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    description: 'Email address',
  )
  String get email;

  @StringField(pattern: ValidationPatterns.password, description: 'Password')
  String get password;
}

@Schema()
abstract class $MerchantLogin {
  @StringField(
    pattern: r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    description: 'Email address',
  )
  String get email;

  @StringField(pattern: ValidationPatterns.password, description: 'Password')
  String get password;
}

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

@Schema()
abstract class $OrderProduct {
  @StringField(minLength: 1, description: 'Product ID')
  String get productId;

  @IntegerField(minimum: 1, description: 'Quantity')
  int get quantity;

  @DoubleField(minimum: 0, description: 'Discount')
  double? get discount;
}

@Schema()
abstract class $OrderCreate {
  @StringField(description: 'Order source')
  String? get source;

  @StringField(description: 'Order type')
  String? get type;

  @StringField(description: 'Order payment method')
  String? get paymentMethod;

  @DoubleField(minimum: 0, description: 'Discount total')
  double? get discountTotal;

  @Field(description: 'Products list')
  List<$OrderProduct> get products;
}

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

@Schema()
abstract class $StoreCreate {
  @StringField(minLength: 1, description: 'Store name')
  String get name;

  @StringField(description: 'Store type')
  String? get storeType;
}

@Schema()
abstract class $StoreUpdate {
  @StringField(minLength: 1, description: 'Store name')
  String? get name;

  @StringField(description: 'Store type')
  String? get storeType;

  @Field(description: 'Is active status')
  bool? get isActive;
}

@Schema()
abstract class $TerminalCreate {
  @StringField(minLength: 1, description: 'Terminal name')
  String get name;

  @StringField(
    minLength: 6,
    pattern: ValidationPatterns.password,
    description: 'Terminal password',
  )
  String get password;
}

@Schema()
abstract class $TerminalLogin {
  @StringField(minLength: 12, maxLength: 12, description: 'Terminal code')
  String get code;

  @StringField(
    minLength: 6,
    pattern: ValidationPatterns.password,
    description: 'Terminal password',
  )
  String get password;
}

@Schema()
abstract class $TerminalUpdate {
  @StringField(minLength: 1, description: 'Terminal name')
  String? get name;

  @StringField(
    minLength: 6,
    pattern: ValidationPatterns.password,
    description: 'Terminal password',
  )
  String? get password;

  @Field(description: 'Is active status')
  bool? get isActive;
}

@Schema()
abstract class $CustomerRegister {
  @StringField(minLength: 1, maxLength: 255, description: 'Full Name')
  String get name;

  @StringField(
    pattern: ValidationPatterns.whatsapp,
    description: '10-Digit Mobile Number',
  )
  String get mobileNumber;

  @StringField(
    minLength: 6,
    maxLength: 6,
    pattern: r'^[0-9]{6}$',
    description: '6-Digit Security PIN',
  )
  String get pin;
}
