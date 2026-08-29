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
