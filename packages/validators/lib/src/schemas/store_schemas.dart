part of '../schemas.dart';

@Schema()
abstract class $StoreCreate {
  @StringField(minLength: 1, description: 'Store name')
  String get name;

  @StringField(description: 'Store type')
  String? get storeType;

  @Field(description: 'Is online ordering enabled')
  bool? get isOnlineEnabled;

  @StringField(
    pattern: r'^[a-z0-9]+(?:-[a-z0-9]+)*$',
    maxLength: 255,
    description: 'Store URL slug',
  )
  String? get slug;
}

@Schema()
abstract class $StoreUpdate {
  @StringField(minLength: 1, description: 'Store name')
  String? get name;

  @StringField(description: 'Store type')
  String? get storeType;

  @Field(description: 'Is active status')
  bool? get isActive;

  @Field(description: 'Is online ordering enabled')
  bool? get isOnlineEnabled;

  @StringField(
    pattern: r'^[a-z0-9]+(?:-[a-z0-9]+)*$',
    maxLength: 255,
    description: 'Store URL slug',
  )
  String? get slug;
}

@Schema()
abstract class $StorePhonePeConfigUpdate {
  @StringField(minLength: 1, description: 'PhonePe Client ID')
  String get clientId;

  @StringField(minLength: 1, description: 'PhonePe Client Secret')
  String get clientSecret;

  @Field(description: 'Is enabled')
  bool? get isEnabled;
}

@Schema()
abstract class $StoreSubscriptionInitiate {
  @StringField(minLength: 1, description: 'Plan code')
  String get planCode;
}

@Schema()
abstract class $StoreSubscriptionVerify {
  @StringField(minLength: 1, description: 'Merchant transaction ID')
  String get merchantTransactionId;
}

@Schema()
abstract class $StoreSubscriptionRenew {
  @StringField(minLength: 1, description: 'Plan code')
  String get planCode;

  @StringField(description: 'Payment method')
  String? get paymentMethod;

  @StringField(description: 'Payment reference')
  String? get reference;
}
