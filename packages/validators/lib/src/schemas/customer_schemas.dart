part of '../schemas.dart';

/// Schema definition for customer registration payload.
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

/// Schema definition for customer authentication login payload.
@Schema()
abstract class $CustomerLogin {
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

/// Schema definition for recording a customer store visit.
@Schema()
abstract class $CustomerRecentStoresUpdate {
  @StringField(minLength: 1, description: 'Store ID')
  String get storeId;
}

/// Schema definition for customer wallet balance top-up request.
@Schema()
abstract class $CustomerWalletTopUp {
  @DoubleField(minimum: 1, description: 'Top-up amount in rupees')
  double get amount;

  @StringField(minLength: 1, description: 'Store ID')
  String get storeId;
}

/// Schema definition for customer profile and security PIN updates.
@Schema()
abstract class $CustomerUpdate {
  @StringField(description: 'Full Name')
  String? get name;

  @StringField(description: '10-Digit Mobile Number')
  String? get mobileNumber;

  @StringField(description: 'New PIN')
  String? get pin;

  @StringField(description: 'Current PIN')
  String? get currentPin;
}
