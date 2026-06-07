// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merchant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Merchant {

 String get id; String get name; String get businessName; String get whatsappNumber; String get email; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Merchant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MerchantCopyWith<Merchant> get copyWith => _$MerchantCopyWithImpl<Merchant>(this as Merchant, _$identity);

  /// Serializes this Merchant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Merchant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.whatsappNumber, whatsappNumber) || other.whatsappNumber == whatsappNumber)&&(identical(other.email, email) || other.email == email)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,businessName,whatsappNumber,email,createdAt,updatedAt);

@override
String toString() {
  return 'Merchant(id: $id, name: $name, businessName: $businessName, whatsappNumber: $whatsappNumber, email: $email, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MerchantCopyWith<$Res>  {
  factory $MerchantCopyWith(Merchant value, $Res Function(Merchant) _then) = _$MerchantCopyWithImpl;
@useResult
$Res call({
 String id, String name, String businessName, String whatsappNumber, String email, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$MerchantCopyWithImpl<$Res>
    implements $MerchantCopyWith<$Res> {
  _$MerchantCopyWithImpl(this._self, this._then);

  final Merchant _self;
  final $Res Function(Merchant) _then;

/// Create a copy of Merchant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? businessName = null,Object? whatsappNumber = null,Object? email = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,whatsappNumber: null == whatsappNumber ? _self.whatsappNumber : whatsappNumber // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Merchant].
extension MerchantPatterns on Merchant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Merchant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Merchant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Merchant value)  $default,){
final _that = this;
switch (_that) {
case _Merchant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Merchant value)?  $default,){
final _that = this;
switch (_that) {
case _Merchant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String businessName,  String whatsappNumber,  String email,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Merchant() when $default != null:
return $default(_that.id,_that.name,_that.businessName,_that.whatsappNumber,_that.email,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String businessName,  String whatsappNumber,  String email,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Merchant():
return $default(_that.id,_that.name,_that.businessName,_that.whatsappNumber,_that.email,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String businessName,  String whatsappNumber,  String email,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Merchant() when $default != null:
return $default(_that.id,_that.name,_that.businessName,_that.whatsappNumber,_that.email,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Merchant implements Merchant {
  const _Merchant({required this.id, required this.name, required this.businessName, required this.whatsappNumber, required this.email, required this.createdAt, required this.updatedAt});
  factory _Merchant.fromJson(Map<String, dynamic> json) => _$MerchantFromJson(json);

@override final  String id;
@override final  String name;
@override final  String businessName;
@override final  String whatsappNumber;
@override final  String email;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Merchant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MerchantCopyWith<_Merchant> get copyWith => __$MerchantCopyWithImpl<_Merchant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MerchantToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Merchant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.whatsappNumber, whatsappNumber) || other.whatsappNumber == whatsappNumber)&&(identical(other.email, email) || other.email == email)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,businessName,whatsappNumber,email,createdAt,updatedAt);

@override
String toString() {
  return 'Merchant(id: $id, name: $name, businessName: $businessName, whatsappNumber: $whatsappNumber, email: $email, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MerchantCopyWith<$Res> implements $MerchantCopyWith<$Res> {
  factory _$MerchantCopyWith(_Merchant value, $Res Function(_Merchant) _then) = __$MerchantCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String businessName, String whatsappNumber, String email, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$MerchantCopyWithImpl<$Res>
    implements _$MerchantCopyWith<$Res> {
  __$MerchantCopyWithImpl(this._self, this._then);

  final _Merchant _self;
  final $Res Function(_Merchant) _then;

/// Create a copy of Merchant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? businessName = null,Object? whatsappNumber = null,Object? email = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Merchant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,whatsappNumber: null == whatsappNumber ? _self.whatsappNumber : whatsappNumber // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
