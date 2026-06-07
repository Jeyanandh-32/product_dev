// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merchant_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MerchantDto {

 String get id; String get name; String get businessName; String get whatsappNumber; String get email; String get passwordHash;@JsonKey(fromJson: _fromJson) DateTime get createdAt;@JsonKey(fromJson: _fromJson) DateTime get updatedAt;
/// Create a copy of MerchantDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MerchantDtoCopyWith<MerchantDto> get copyWith => _$MerchantDtoCopyWithImpl<MerchantDto>(this as MerchantDto, _$identity);

  /// Serializes this MerchantDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MerchantDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.whatsappNumber, whatsappNumber) || other.whatsappNumber == whatsappNumber)&&(identical(other.email, email) || other.email == email)&&(identical(other.passwordHash, passwordHash) || other.passwordHash == passwordHash)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,businessName,whatsappNumber,email,passwordHash,createdAt,updatedAt);

@override
String toString() {
  return 'MerchantDto(id: $id, name: $name, businessName: $businessName, whatsappNumber: $whatsappNumber, email: $email, passwordHash: $passwordHash, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MerchantDtoCopyWith<$Res>  {
  factory $MerchantDtoCopyWith(MerchantDto value, $Res Function(MerchantDto) _then) = _$MerchantDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String businessName, String whatsappNumber, String email, String passwordHash,@JsonKey(fromJson: _fromJson) DateTime createdAt,@JsonKey(fromJson: _fromJson) DateTime updatedAt
});




}
/// @nodoc
class _$MerchantDtoCopyWithImpl<$Res>
    implements $MerchantDtoCopyWith<$Res> {
  _$MerchantDtoCopyWithImpl(this._self, this._then);

  final MerchantDto _self;
  final $Res Function(MerchantDto) _then;

/// Create a copy of MerchantDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? businessName = null,Object? whatsappNumber = null,Object? email = null,Object? passwordHash = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,whatsappNumber: null == whatsappNumber ? _self.whatsappNumber : whatsappNumber // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,passwordHash: null == passwordHash ? _self.passwordHash : passwordHash // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MerchantDto].
extension MerchantDtoPatterns on MerchantDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MerchantDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MerchantDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MerchantDto value)  $default,){
final _that = this;
switch (_that) {
case _MerchantDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MerchantDto value)?  $default,){
final _that = this;
switch (_that) {
case _MerchantDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String businessName,  String whatsappNumber,  String email,  String passwordHash, @JsonKey(fromJson: _fromJson)  DateTime createdAt, @JsonKey(fromJson: _fromJson)  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MerchantDto() when $default != null:
return $default(_that.id,_that.name,_that.businessName,_that.whatsappNumber,_that.email,_that.passwordHash,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String businessName,  String whatsappNumber,  String email,  String passwordHash, @JsonKey(fromJson: _fromJson)  DateTime createdAt, @JsonKey(fromJson: _fromJson)  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MerchantDto():
return $default(_that.id,_that.name,_that.businessName,_that.whatsappNumber,_that.email,_that.passwordHash,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String businessName,  String whatsappNumber,  String email,  String passwordHash, @JsonKey(fromJson: _fromJson)  DateTime createdAt, @JsonKey(fromJson: _fromJson)  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MerchantDto() when $default != null:
return $default(_that.id,_that.name,_that.businessName,_that.whatsappNumber,_that.email,_that.passwordHash,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: .snake)
class _MerchantDto implements MerchantDto {
  const _MerchantDto({required this.id, required this.name, required this.businessName, required this.whatsappNumber, required this.email, required this.passwordHash, @JsonKey(fromJson: _fromJson) required this.createdAt, @JsonKey(fromJson: _fromJson) required this.updatedAt});
  factory _MerchantDto.fromJson(Map<String, dynamic> json) => _$MerchantDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String businessName;
@override final  String whatsappNumber;
@override final  String email;
@override final  String passwordHash;
@override@JsonKey(fromJson: _fromJson) final  DateTime createdAt;
@override@JsonKey(fromJson: _fromJson) final  DateTime updatedAt;

/// Create a copy of MerchantDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MerchantDtoCopyWith<_MerchantDto> get copyWith => __$MerchantDtoCopyWithImpl<_MerchantDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MerchantDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MerchantDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.whatsappNumber, whatsappNumber) || other.whatsappNumber == whatsappNumber)&&(identical(other.email, email) || other.email == email)&&(identical(other.passwordHash, passwordHash) || other.passwordHash == passwordHash)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,businessName,whatsappNumber,email,passwordHash,createdAt,updatedAt);

@override
String toString() {
  return 'MerchantDto(id: $id, name: $name, businessName: $businessName, whatsappNumber: $whatsappNumber, email: $email, passwordHash: $passwordHash, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MerchantDtoCopyWith<$Res> implements $MerchantDtoCopyWith<$Res> {
  factory _$MerchantDtoCopyWith(_MerchantDto value, $Res Function(_MerchantDto) _then) = __$MerchantDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String businessName, String whatsappNumber, String email, String passwordHash,@JsonKey(fromJson: _fromJson) DateTime createdAt,@JsonKey(fromJson: _fromJson) DateTime updatedAt
});




}
/// @nodoc
class __$MerchantDtoCopyWithImpl<$Res>
    implements _$MerchantDtoCopyWith<$Res> {
  __$MerchantDtoCopyWithImpl(this._self, this._then);

  final _MerchantDto _self;
  final $Res Function(_MerchantDto) _then;

/// Create a copy of MerchantDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? businessName = null,Object? whatsappNumber = null,Object? email = null,Object? passwordHash = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_MerchantDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,whatsappNumber: null == whatsappNumber ? _self.whatsappNumber : whatsappNumber // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,passwordHash: null == passwordHash ? _self.passwordHash : passwordHash // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
