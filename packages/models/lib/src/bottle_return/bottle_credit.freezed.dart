// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bottle_credit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BottleCredit {

 String get id; String get merchantId; String get customerPhone; int get balance; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of BottleCredit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BottleCreditCopyWith<BottleCredit> get copyWith => _$BottleCreditCopyWithImpl<BottleCredit>(this as BottleCredit, _$identity);

  /// Serializes this BottleCredit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BottleCredit&&(identical(other.id, id) || other.id == id)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,merchantId,customerPhone,balance,createdAt,updatedAt);

@override
String toString() {
  return 'BottleCredit(id: $id, merchantId: $merchantId, customerPhone: $customerPhone, balance: $balance, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $BottleCreditCopyWith<$Res>  {
  factory $BottleCreditCopyWith(BottleCredit value, $Res Function(BottleCredit) _then) = _$BottleCreditCopyWithImpl;
@useResult
$Res call({
 String id, String merchantId, String customerPhone, int balance, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$BottleCreditCopyWithImpl<$Res>
    implements $BottleCreditCopyWith<$Res> {
  _$BottleCreditCopyWithImpl(this._self, this._then);

  final BottleCredit _self;
  final $Res Function(BottleCredit) _then;

/// Create a copy of BottleCredit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? merchantId = null,Object? customerPhone = null,Object? balance = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,customerPhone: null == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BottleCredit].
extension BottleCreditPatterns on BottleCredit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BottleCredit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BottleCredit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BottleCredit value)  $default,){
final _that = this;
switch (_that) {
case _BottleCredit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BottleCredit value)?  $default,){
final _that = this;
switch (_that) {
case _BottleCredit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String merchantId,  String customerPhone,  int balance,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BottleCredit() when $default != null:
return $default(_that.id,_that.merchantId,_that.customerPhone,_that.balance,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String merchantId,  String customerPhone,  int balance,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _BottleCredit():
return $default(_that.id,_that.merchantId,_that.customerPhone,_that.balance,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String merchantId,  String customerPhone,  int balance,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _BottleCredit() when $default != null:
return $default(_that.id,_that.merchantId,_that.customerPhone,_that.balance,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BottleCredit implements BottleCredit {
  const _BottleCredit({required this.id, required this.merchantId, required this.customerPhone, this.balance = 0, this.createdAt, this.updatedAt});
  factory _BottleCredit.fromJson(Map<String, dynamic> json) => _$BottleCreditFromJson(json);

@override final  String id;
@override final  String merchantId;
@override final  String customerPhone;
@override@JsonKey() final  int balance;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of BottleCredit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BottleCreditCopyWith<_BottleCredit> get copyWith => __$BottleCreditCopyWithImpl<_BottleCredit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BottleCreditToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BottleCredit&&(identical(other.id, id) || other.id == id)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,merchantId,customerPhone,balance,createdAt,updatedAt);

@override
String toString() {
  return 'BottleCredit(id: $id, merchantId: $merchantId, customerPhone: $customerPhone, balance: $balance, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BottleCreditCopyWith<$Res> implements $BottleCreditCopyWith<$Res> {
  factory _$BottleCreditCopyWith(_BottleCredit value, $Res Function(_BottleCredit) _then) = __$BottleCreditCopyWithImpl;
@override @useResult
$Res call({
 String id, String merchantId, String customerPhone, int balance, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$BottleCreditCopyWithImpl<$Res>
    implements _$BottleCreditCopyWith<$Res> {
  __$BottleCreditCopyWithImpl(this._self, this._then);

  final _BottleCredit _self;
  final $Res Function(_BottleCredit) _then;

/// Create a copy of BottleCredit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? merchantId = null,Object? customerPhone = null,Object? balance = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_BottleCredit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,customerPhone: null == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
