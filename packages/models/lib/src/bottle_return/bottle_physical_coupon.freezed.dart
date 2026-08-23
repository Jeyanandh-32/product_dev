// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bottle_physical_coupon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BottlePhysicalCoupon {

 String get id; String get code; String get merchantId; String get storeId; int get amount; String get status; DateTime? get redeemedAt; String? get redeemedOrderId; DateTime? get createdAt;
/// Create a copy of BottlePhysicalCoupon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BottlePhysicalCouponCopyWith<BottlePhysicalCoupon> get copyWith => _$BottlePhysicalCouponCopyWithImpl<BottlePhysicalCoupon>(this as BottlePhysicalCoupon, _$identity);

  /// Serializes this BottlePhysicalCoupon to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BottlePhysicalCoupon&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.redeemedAt, redeemedAt) || other.redeemedAt == redeemedAt)&&(identical(other.redeemedOrderId, redeemedOrderId) || other.redeemedOrderId == redeemedOrderId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,merchantId,storeId,amount,status,redeemedAt,redeemedOrderId,createdAt);

@override
String toString() {
  return 'BottlePhysicalCoupon(id: $id, code: $code, merchantId: $merchantId, storeId: $storeId, amount: $amount, status: $status, redeemedAt: $redeemedAt, redeemedOrderId: $redeemedOrderId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BottlePhysicalCouponCopyWith<$Res>  {
  factory $BottlePhysicalCouponCopyWith(BottlePhysicalCoupon value, $Res Function(BottlePhysicalCoupon) _then) = _$BottlePhysicalCouponCopyWithImpl;
@useResult
$Res call({
 String id, String code, String merchantId, String storeId, int amount, String status, DateTime? redeemedAt, String? redeemedOrderId, DateTime? createdAt
});




}
/// @nodoc
class _$BottlePhysicalCouponCopyWithImpl<$Res>
    implements $BottlePhysicalCouponCopyWith<$Res> {
  _$BottlePhysicalCouponCopyWithImpl(this._self, this._then);

  final BottlePhysicalCoupon _self;
  final $Res Function(BottlePhysicalCoupon) _then;

/// Create a copy of BottlePhysicalCoupon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? merchantId = null,Object? storeId = null,Object? amount = null,Object? status = null,Object? redeemedAt = freezed,Object? redeemedOrderId = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,redeemedAt: freezed == redeemedAt ? _self.redeemedAt : redeemedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,redeemedOrderId: freezed == redeemedOrderId ? _self.redeemedOrderId : redeemedOrderId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BottlePhysicalCoupon].
extension BottlePhysicalCouponPatterns on BottlePhysicalCoupon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BottlePhysicalCoupon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BottlePhysicalCoupon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BottlePhysicalCoupon value)  $default,){
final _that = this;
switch (_that) {
case _BottlePhysicalCoupon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BottlePhysicalCoupon value)?  $default,){
final _that = this;
switch (_that) {
case _BottlePhysicalCoupon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String merchantId,  String storeId,  int amount,  String status,  DateTime? redeemedAt,  String? redeemedOrderId,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BottlePhysicalCoupon() when $default != null:
return $default(_that.id,_that.code,_that.merchantId,_that.storeId,_that.amount,_that.status,_that.redeemedAt,_that.redeemedOrderId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String merchantId,  String storeId,  int amount,  String status,  DateTime? redeemedAt,  String? redeemedOrderId,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _BottlePhysicalCoupon():
return $default(_that.id,_that.code,_that.merchantId,_that.storeId,_that.amount,_that.status,_that.redeemedAt,_that.redeemedOrderId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String merchantId,  String storeId,  int amount,  String status,  DateTime? redeemedAt,  String? redeemedOrderId,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BottlePhysicalCoupon() when $default != null:
return $default(_that.id,_that.code,_that.merchantId,_that.storeId,_that.amount,_that.status,_that.redeemedAt,_that.redeemedOrderId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BottlePhysicalCoupon implements BottlePhysicalCoupon {
  const _BottlePhysicalCoupon({required this.id, required this.code, required this.merchantId, required this.storeId, required this.amount, this.status = 'active', this.redeemedAt, this.redeemedOrderId, this.createdAt});
  factory _BottlePhysicalCoupon.fromJson(Map<String, dynamic> json) => _$BottlePhysicalCouponFromJson(json);

@override final  String id;
@override final  String code;
@override final  String merchantId;
@override final  String storeId;
@override final  int amount;
@override@JsonKey() final  String status;
@override final  DateTime? redeemedAt;
@override final  String? redeemedOrderId;
@override final  DateTime? createdAt;

/// Create a copy of BottlePhysicalCoupon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BottlePhysicalCouponCopyWith<_BottlePhysicalCoupon> get copyWith => __$BottlePhysicalCouponCopyWithImpl<_BottlePhysicalCoupon>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BottlePhysicalCouponToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BottlePhysicalCoupon&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.redeemedAt, redeemedAt) || other.redeemedAt == redeemedAt)&&(identical(other.redeemedOrderId, redeemedOrderId) || other.redeemedOrderId == redeemedOrderId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,merchantId,storeId,amount,status,redeemedAt,redeemedOrderId,createdAt);

@override
String toString() {
  return 'BottlePhysicalCoupon(id: $id, code: $code, merchantId: $merchantId, storeId: $storeId, amount: $amount, status: $status, redeemedAt: $redeemedAt, redeemedOrderId: $redeemedOrderId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BottlePhysicalCouponCopyWith<$Res> implements $BottlePhysicalCouponCopyWith<$Res> {
  factory _$BottlePhysicalCouponCopyWith(_BottlePhysicalCoupon value, $Res Function(_BottlePhysicalCoupon) _then) = __$BottlePhysicalCouponCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String merchantId, String storeId, int amount, String status, DateTime? redeemedAt, String? redeemedOrderId, DateTime? createdAt
});




}
/// @nodoc
class __$BottlePhysicalCouponCopyWithImpl<$Res>
    implements _$BottlePhysicalCouponCopyWith<$Res> {
  __$BottlePhysicalCouponCopyWithImpl(this._self, this._then);

  final _BottlePhysicalCoupon _self;
  final $Res Function(_BottlePhysicalCoupon) _then;

/// Create a copy of BottlePhysicalCoupon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? merchantId = null,Object? storeId = null,Object? amount = null,Object? status = null,Object? redeemedAt = freezed,Object? redeemedOrderId = freezed,Object? createdAt = freezed,}) {
  return _then(_BottlePhysicalCoupon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,redeemedAt: freezed == redeemedAt ? _self.redeemedAt : redeemedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,redeemedOrderId: freezed == redeemedOrderId ? _self.redeemedOrderId : redeemedOrderId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
