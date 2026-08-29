part of '../schemas.dart';

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
