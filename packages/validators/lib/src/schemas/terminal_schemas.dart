part of '../schemas.dart';

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
