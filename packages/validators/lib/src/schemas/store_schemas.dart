part of '../schemas.dart';

/// Schema definition for store creation payload.
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

/// Schema definition for store update payload.
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

/// Schema definition for store PhonePe PG configuration payload.
@Schema()
abstract class $StorePhonePeConfigUpdate {
  @StringField(minLength: 1, description: 'PhonePe Client ID')
  String get clientId;

  @StringField(minLength: 1, description: 'PhonePe Client Secret')
  String get clientSecret;

  @Field(description: 'Is enabled')
  bool? get isEnabled;
}

/// Schema definition for initiating a store subscription payment session.
@Schema()
abstract class $StoreSubscriptionInitiate {
  @StringField(minLength: 1, description: 'Plan code')
  String get planCode;
}

/// Schema definition for verifying a store subscription payment transaction.
@Schema()
abstract class $StoreSubscriptionVerify {
  @StringField(minLength: 1, description: 'Merchant transaction ID')
  String get merchantTransactionId;
}

/// Schema definition for renewing an existing store subscription.
@Schema()
abstract class $StoreSubscriptionRenew {
  @StringField(minLength: 1, description: 'Plan code')
  String get planCode;

  @StringField(description: 'Payment method')
  String? get paymentMethod;

  @StringField(description: 'Payment reference')
  String? get reference;
}
