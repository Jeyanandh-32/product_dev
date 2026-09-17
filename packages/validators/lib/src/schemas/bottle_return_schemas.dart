part of '../schemas.dart';

/// Schema definition for updating store bottle return configuration.
@Schema()
abstract class $BottleReturnConfigUpdate {
  @StringField(minLength: 1, description: 'Store ID')
  String get storeId;

  @Field(description: 'Is enabled')
  bool? get isEnabled;

  @IntegerField(minimum: 1, description: 'Reward amount in rupees')
  int? get rewardAmountInRupees;

  @StringField(description: 'IoT API key')
  String? get iotApiKey;
}

/// Schema definition for configuring product returnability status.
@Schema()
abstract class $BottleReturnProductUpdate {
  @StringField(minLength: 1, description: 'Store ID')
  String get storeId;

  @StringField(description: 'Product ID')
  String? get productId;

  @Field(description: 'List of product IDs')
  List<String>? get productIds;

  @Field(description: 'Is returnable')
  bool? get isReturnable;
}

/// Schema definition for applying bottle return credit against an order.
@Schema()
abstract class $BottleReturnCreditApply {
  @StringField(minLength: 1, description: 'Merchant ID')
  String get merchantId;

  @StringField(minLength: 10, description: 'Customer Phone')
  String get customerPhone;

  @IntegerField(minimum: 1, description: 'Amount')
  int get amount;

  @StringField(minLength: 1, description: 'Store ID')
  String get storeId;

  @StringField(description: 'Order ID')
  String? get orderId;
}

/// Schema definition for validating a physical bottle return coupon code.
@Schema()
abstract class $BottleReturnCouponValidate {
  @StringField(minLength: 1, description: 'Merchant ID')
  String get merchantId;

  @StringField(minLength: 1, description: 'Coupon Code')
  String get code;

  @StringField(minLength: 1, description: 'Store ID')
  String get storeId;
}

/// Schema definition for redeeming a bottle return coupon against an order.
@Schema()
abstract class $BottleReturnCouponRedeem {
  @StringField(minLength: 1, description: 'Merchant ID')
  String get merchantId;

  @StringField(minLength: 1, description: 'Coupon Code')
  String get code;

  @StringField(minLength: 1, description: 'Store ID')
  String get storeId;

  @StringField(minLength: 1, description: 'Order ID')
  String get orderId;
}

/// Schema definition for IoT reverse-vending scanner token ingestion.
@Schema()
abstract class $BottleReturnIotScan {
  @StringField(minLength: 1, description: 'Merchant ID')
  String get merchantId;

  @StringField(minLength: 1, description: 'Store ID')
  String get storeId;

  @Field(description: 'Token strings')
  List<String> get tokenStrings;
}

/// Schema definition for IoT sticker dispenser trigger payload.
@Schema()
abstract class $BottleReturnIotDispense {
  @StringField(minLength: 1, description: 'Order reference')
  String get orderReference;
}

/// Schema definition for a line item within a bottle token generation request.
@Schema()
abstract class $BottleReturnTokenItem {
  @StringField(minLength: 1, description: 'Product ID')
  String get productId;

  @IntegerField(minimum: 1, description: 'Quantity')
  int get quantity;

  @Field(description: 'Is returnable bottle')
  bool? get isReturnableBottle;
}

/// Schema definition for generating bottle return tracking tokens.
@Schema()
abstract class $BottleReturnTokensGenerate {
  @StringField(minLength: 1, description: 'Merchant ID')
  String get merchantId;

  @StringField(minLength: 1, description: 'Store ID')
  String get storeId;

  @StringField(minLength: 1, description: 'Order ID')
  String get orderId;

  @StringField(description: 'Reward mode')
  String? get rewardMode;

  @StringField(description: 'Customer phone')
  String? get customerPhone;

  @Field(description: 'Returnable item list')
  List<$BottleReturnTokenItem> get items;
}
