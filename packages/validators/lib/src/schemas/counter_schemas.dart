part of '../schemas.dart';

/// Schema definition for counter creation request payload.
@Schema()
abstract class $CounterCreate {
  @StringField(minLength: 1, maxLength: 255, description: 'Counter name')
  String get name;

  @StringField(maxLength: 255, description: 'Counter description')
  String? get description;

  @StringField(maxLength: 255, description: 'Counter image URL')
  String? get imageUrl;
}

/// Schema definition for counter update request payload.
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
