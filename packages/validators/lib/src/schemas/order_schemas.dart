part of '../schemas.dart';

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

  @Field(description: 'Whether to apply customer wallet balance')
  bool? get useWallet;

  @DoubleField(minimum: 0, description: 'Wallet deduction amount in rupees')
  double? get walletDeduction;

  @Field(description: 'Products list')
  List<$OrderProduct> get products;
}

@Schema()
abstract class $OrderUpdate {
  @StringField(description: 'Order status')
  String? get status;

  @StringField(description: 'Payment status')
  String? get paymentStatus;

  @StringField(description: 'Payment method')
  String? get paymentMethod;
}
