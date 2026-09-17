part of '../schemas.dart';

/// Schema definition for merchant account registration.
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

/// Schema definition for merchant credentials authentication login.
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

/// Schema definition for updating merchant notification preferences.
@Schema()
abstract class $MerchantSettingsUpdate {
  @Field(description: 'WhatsApp notifications enabled')
  bool? get waNotifications;

  @Field(description: 'Low stock alerts enabled')
  bool? get lowStockAlerts;

  @Field(description: 'Daily reports enabled')
  bool? get dailyReports;
}

/// Schema definition for updating merchant profile details.
@Schema()
abstract class $MerchantUpdate {
  @StringField(description: 'Merchant name')
  String? get name;

  @StringField(description: 'Business name')
  String? get businessName;

  @StringField(
    pattern: ValidationPatterns.whatsapp,
    description: 'Whatsapp number',
  )
  String? get whatsappNumber;

  @StringField(
    pattern: r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    description: 'Email address',
  )
  String? get email;

  @StringField(description: 'Current password')
  String? get currentPassword;

  @StringField(description: 'New password')
  String? get newPassword;
}
