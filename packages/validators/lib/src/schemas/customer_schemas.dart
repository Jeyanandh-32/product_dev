part of '../schemas.dart';

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
