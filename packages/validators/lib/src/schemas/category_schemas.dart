part of '../schemas.dart';

/// Schema definition for product category creation payload.
@Schema()
abstract class $CategoryCreate {
  @StringField(minLength: 1, maxLength: 255, description: 'Category name')
  String get name;

  @StringField(maxLength: 255, description: 'Category description')
  String? get description;

  @StringField(maxLength: 255, description: 'Category image URL')
  String? get imageUrl;
}

/// Schema definition for product category update payload.
@Schema()
abstract class $CategoryUpdate {
  @StringField(minLength: 1, maxLength: 255, description: 'Category name')
  String? get name;

  @Field(description: 'Is active status')
  bool? get isActive;

  @StringField(maxLength: 255, description: 'Category description')
  String? get description;

  @StringField(maxLength: 255, description: 'Category image URL')
  String? get imageUrl;
}
