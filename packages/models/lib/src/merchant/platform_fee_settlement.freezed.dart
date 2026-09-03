// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'platform_fee_settlement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlatformFeeSettlement {

 String get id; String get merchantId; int get amountInPaise; int get ordersCount; String get paymentGateway; String? get paymentTransactionId; String get status; DateTime? get createdAt; DateTime? get settledAt;
/// Create a copy of PlatformFeeSettlement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformFeeSettlementCopyWith<PlatformFeeSettlement> get copyWith => _$PlatformFeeSettlementCopyWithImpl<PlatformFeeSettlement>(this as PlatformFeeSettlement, _$identity);

  /// Serializes this PlatformFeeSettlement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformFeeSettlement&&(identical(other.id, id) || other.id == id)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.amountInPaise, amountInPaise) || other.amountInPaise == amountInPaise)&&(identical(other.ordersCount, ordersCount) || other.ordersCount == ordersCount)&&(identical(other.paymentGateway, paymentGateway) || other.paymentGateway == paymentGateway)&&(identical(other.paymentTransactionId, paymentTransactionId) || other.paymentTransactionId == paymentTransactionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.settledAt, settledAt) || other.settledAt == settledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,merchantId,amountInPaise,ordersCount,paymentGateway,paymentTransactionId,status,createdAt,settledAt);

@override
String toString() {
  return 'PlatformFeeSettlement(id: $id, merchantId: $merchantId, amountInPaise: $amountInPaise, ordersCount: $ordersCount, paymentGateway: $paymentGateway, paymentTransactionId: $paymentTransactionId, status: $status, createdAt: $createdAt, settledAt: $settledAt)';
}


}

/// @nodoc
abstract mixin class $PlatformFeeSettlementCopyWith<$Res>  {
  factory $PlatformFeeSettlementCopyWith(PlatformFeeSettlement value, $Res Function(PlatformFeeSettlement) _then) = _$PlatformFeeSettlementCopyWithImpl;
@useResult
$Res call({
 String id, String merchantId, int amountInPaise, int ordersCount, String paymentGateway, String? paymentTransactionId, String status, DateTime? createdAt, DateTime? settledAt
});




}
/// @nodoc
class _$PlatformFeeSettlementCopyWithImpl<$Res>
    implements $PlatformFeeSettlementCopyWith<$Res> {
  _$PlatformFeeSettlementCopyWithImpl(this._self, this._then);

  final PlatformFeeSettlement _self;
  final $Res Function(PlatformFeeSettlement) _then;

/// Create a copy of PlatformFeeSettlement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? merchantId = null,Object? amountInPaise = null,Object? ordersCount = null,Object? paymentGateway = null,Object? paymentTransactionId = freezed,Object? status = null,Object? createdAt = freezed,Object? settledAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,amountInPaise: null == amountInPaise ? _self.amountInPaise : amountInPaise // ignore: cast_nullable_to_non_nullable
as int,ordersCount: null == ordersCount ? _self.ordersCount : ordersCount // ignore: cast_nullable_to_non_nullable
as int,paymentGateway: null == paymentGateway ? _self.paymentGateway : paymentGateway // ignore: cast_nullable_to_non_nullable
as String,paymentTransactionId: freezed == paymentTransactionId ? _self.paymentTransactionId : paymentTransactionId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,settledAt: freezed == settledAt ? _self.settledAt : settledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlatformFeeSettlement].
extension PlatformFeeSettlementPatterns on PlatformFeeSettlement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlatformFeeSettlement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlatformFeeSettlement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlatformFeeSettlement value)  $default,){
final _that = this;
switch (_that) {
case _PlatformFeeSettlement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlatformFeeSettlement value)?  $default,){
final _that = this;
switch (_that) {
case _PlatformFeeSettlement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String merchantId,  int amountInPaise,  int ordersCount,  String paymentGateway,  String? paymentTransactionId,  String status,  DateTime? createdAt,  DateTime? settledAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlatformFeeSettlement() when $default != null:
return $default(_that.id,_that.merchantId,_that.amountInPaise,_that.ordersCount,_that.paymentGateway,_that.paymentTransactionId,_that.status,_that.createdAt,_that.settledAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String merchantId,  int amountInPaise,  int ordersCount,  String paymentGateway,  String? paymentTransactionId,  String status,  DateTime? createdAt,  DateTime? settledAt)  $default,) {final _that = this;
switch (_that) {
case _PlatformFeeSettlement():
return $default(_that.id,_that.merchantId,_that.amountInPaise,_that.ordersCount,_that.paymentGateway,_that.paymentTransactionId,_that.status,_that.createdAt,_that.settledAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String merchantId,  int amountInPaise,  int ordersCount,  String paymentGateway,  String? paymentTransactionId,  String status,  DateTime? createdAt,  DateTime? settledAt)?  $default,) {final _that = this;
switch (_that) {
case _PlatformFeeSettlement() when $default != null:
return $default(_that.id,_that.merchantId,_that.amountInPaise,_that.ordersCount,_that.paymentGateway,_that.paymentTransactionId,_that.status,_that.createdAt,_that.settledAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlatformFeeSettlement implements PlatformFeeSettlement {
  const _PlatformFeeSettlement({required this.id, required this.merchantId, required this.amountInPaise, this.ordersCount = 0, this.paymentGateway = 'phonepe', this.paymentTransactionId, this.status = 'pending', this.createdAt, this.settledAt});
  factory _PlatformFeeSettlement.fromJson(Map<String, dynamic> json) => _$PlatformFeeSettlementFromJson(json);

@override final  String id;
@override final  String merchantId;
@override final  int amountInPaise;
@override@JsonKey() final  int ordersCount;
@override@JsonKey() final  String paymentGateway;
@override final  String? paymentTransactionId;
@override@JsonKey() final  String status;
@override final  DateTime? createdAt;
@override final  DateTime? settledAt;

/// Create a copy of PlatformFeeSettlement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformFeeSettlementCopyWith<_PlatformFeeSettlement> get copyWith => __$PlatformFeeSettlementCopyWithImpl<_PlatformFeeSettlement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlatformFeeSettlementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformFeeSettlement&&(identical(other.id, id) || other.id == id)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.amountInPaise, amountInPaise) || other.amountInPaise == amountInPaise)&&(identical(other.ordersCount, ordersCount) || other.ordersCount == ordersCount)&&(identical(other.paymentGateway, paymentGateway) || other.paymentGateway == paymentGateway)&&(identical(other.paymentTransactionId, paymentTransactionId) || other.paymentTransactionId == paymentTransactionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.settledAt, settledAt) || other.settledAt == settledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,merchantId,amountInPaise,ordersCount,paymentGateway,paymentTransactionId,status,createdAt,settledAt);

@override
String toString() {
  return 'PlatformFeeSettlement(id: $id, merchantId: $merchantId, amountInPaise: $amountInPaise, ordersCount: $ordersCount, paymentGateway: $paymentGateway, paymentTransactionId: $paymentTransactionId, status: $status, createdAt: $createdAt, settledAt: $settledAt)';
}


}

/// @nodoc
abstract mixin class _$PlatformFeeSettlementCopyWith<$Res> implements $PlatformFeeSettlementCopyWith<$Res> {
  factory _$PlatformFeeSettlementCopyWith(_PlatformFeeSettlement value, $Res Function(_PlatformFeeSettlement) _then) = __$PlatformFeeSettlementCopyWithImpl;
@override @useResult
$Res call({
 String id, String merchantId, int amountInPaise, int ordersCount, String paymentGateway, String? paymentTransactionId, String status, DateTime? createdAt, DateTime? settledAt
});




}
/// @nodoc
class __$PlatformFeeSettlementCopyWithImpl<$Res>
    implements _$PlatformFeeSettlementCopyWith<$Res> {
  __$PlatformFeeSettlementCopyWithImpl(this._self, this._then);

  final _PlatformFeeSettlement _self;
  final $Res Function(_PlatformFeeSettlement) _then;

/// Create a copy of PlatformFeeSettlement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? merchantId = null,Object? amountInPaise = null,Object? ordersCount = null,Object? paymentGateway = null,Object? paymentTransactionId = freezed,Object? status = null,Object? createdAt = freezed,Object? settledAt = freezed,}) {
  return _then(_PlatformFeeSettlement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,amountInPaise: null == amountInPaise ? _self.amountInPaise : amountInPaise // ignore: cast_nullable_to_non_nullable
as int,ordersCount: null == ordersCount ? _self.ordersCount : ordersCount // ignore: cast_nullable_to_non_nullable
as int,paymentGateway: null == paymentGateway ? _self.paymentGateway : paymentGateway // ignore: cast_nullable_to_non_nullable
as String,paymentTransactionId: freezed == paymentTransactionId ? _self.paymentTransactionId : paymentTransactionId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,settledAt: freezed == settledAt ? _self.settledAt : settledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
