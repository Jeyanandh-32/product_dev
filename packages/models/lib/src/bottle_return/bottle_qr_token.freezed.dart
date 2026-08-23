// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bottle_qr_token.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BottleQrToken {

 String get id; String get token; String get merchantId; String get storeId; String get orderId; String get productId; BottleRewardMode get rewardMode; String? get customerPhone; BottleTokenStatus get status; DateTime? get returnedAt; String? get returnedStoreId; DateTime? get createdAt;
/// Create a copy of BottleQrToken
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BottleQrTokenCopyWith<BottleQrToken> get copyWith => _$BottleQrTokenCopyWithImpl<BottleQrToken>(this as BottleQrToken, _$identity);

  /// Serializes this BottleQrToken to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BottleQrToken&&(identical(other.id, id) || other.id == id)&&(identical(other.token, token) || other.token == token)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.rewardMode, rewardMode) || other.rewardMode == rewardMode)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.status, status) || other.status == status)&&(identical(other.returnedAt, returnedAt) || other.returnedAt == returnedAt)&&(identical(other.returnedStoreId, returnedStoreId) || other.returnedStoreId == returnedStoreId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,token,merchantId,storeId,orderId,productId,rewardMode,customerPhone,status,returnedAt,returnedStoreId,createdAt);

@override
String toString() {
  return 'BottleQrToken(id: $id, token: $token, merchantId: $merchantId, storeId: $storeId, orderId: $orderId, productId: $productId, rewardMode: $rewardMode, customerPhone: $customerPhone, status: $status, returnedAt: $returnedAt, returnedStoreId: $returnedStoreId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BottleQrTokenCopyWith<$Res>  {
  factory $BottleQrTokenCopyWith(BottleQrToken value, $Res Function(BottleQrToken) _then) = _$BottleQrTokenCopyWithImpl;
@useResult
$Res call({
 String id, String token, String merchantId, String storeId, String orderId, String productId, BottleRewardMode rewardMode, String? customerPhone, BottleTokenStatus status, DateTime? returnedAt, String? returnedStoreId, DateTime? createdAt
});




}
/// @nodoc
class _$BottleQrTokenCopyWithImpl<$Res>
    implements $BottleQrTokenCopyWith<$Res> {
  _$BottleQrTokenCopyWithImpl(this._self, this._then);

  final BottleQrToken _self;
  final $Res Function(BottleQrToken) _then;

/// Create a copy of BottleQrToken
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? token = null,Object? merchantId = null,Object? storeId = null,Object? orderId = null,Object? productId = null,Object? rewardMode = null,Object? customerPhone = freezed,Object? status = null,Object? returnedAt = freezed,Object? returnedStoreId = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,rewardMode: null == rewardMode ? _self.rewardMode : rewardMode // ignore: cast_nullable_to_non_nullable
as BottleRewardMode,customerPhone: freezed == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BottleTokenStatus,returnedAt: freezed == returnedAt ? _self.returnedAt : returnedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,returnedStoreId: freezed == returnedStoreId ? _self.returnedStoreId : returnedStoreId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BottleQrToken].
extension BottleQrTokenPatterns on BottleQrToken {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BottleQrToken value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BottleQrToken() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BottleQrToken value)  $default,){
final _that = this;
switch (_that) {
case _BottleQrToken():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BottleQrToken value)?  $default,){
final _that = this;
switch (_that) {
case _BottleQrToken() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String token,  String merchantId,  String storeId,  String orderId,  String productId,  BottleRewardMode rewardMode,  String? customerPhone,  BottleTokenStatus status,  DateTime? returnedAt,  String? returnedStoreId,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BottleQrToken() when $default != null:
return $default(_that.id,_that.token,_that.merchantId,_that.storeId,_that.orderId,_that.productId,_that.rewardMode,_that.customerPhone,_that.status,_that.returnedAt,_that.returnedStoreId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String token,  String merchantId,  String storeId,  String orderId,  String productId,  BottleRewardMode rewardMode,  String? customerPhone,  BottleTokenStatus status,  DateTime? returnedAt,  String? returnedStoreId,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _BottleQrToken():
return $default(_that.id,_that.token,_that.merchantId,_that.storeId,_that.orderId,_that.productId,_that.rewardMode,_that.customerPhone,_that.status,_that.returnedAt,_that.returnedStoreId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String token,  String merchantId,  String storeId,  String orderId,  String productId,  BottleRewardMode rewardMode,  String? customerPhone,  BottleTokenStatus status,  DateTime? returnedAt,  String? returnedStoreId,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BottleQrToken() when $default != null:
return $default(_that.id,_that.token,_that.merchantId,_that.storeId,_that.orderId,_that.productId,_that.rewardMode,_that.customerPhone,_that.status,_that.returnedAt,_that.returnedStoreId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BottleQrToken implements BottleQrToken {
  const _BottleQrToken({required this.id, required this.token, required this.merchantId, required this.storeId, required this.orderId, required this.productId, this.rewardMode = BottleRewardMode.digital, this.customerPhone, this.status = BottleTokenStatus.active, this.returnedAt, this.returnedStoreId, this.createdAt});
  factory _BottleQrToken.fromJson(Map<String, dynamic> json) => _$BottleQrTokenFromJson(json);

@override final  String id;
@override final  String token;
@override final  String merchantId;
@override final  String storeId;
@override final  String orderId;
@override final  String productId;
@override@JsonKey() final  BottleRewardMode rewardMode;
@override final  String? customerPhone;
@override@JsonKey() final  BottleTokenStatus status;
@override final  DateTime? returnedAt;
@override final  String? returnedStoreId;
@override final  DateTime? createdAt;

/// Create a copy of BottleQrToken
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BottleQrTokenCopyWith<_BottleQrToken> get copyWith => __$BottleQrTokenCopyWithImpl<_BottleQrToken>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BottleQrTokenToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BottleQrToken&&(identical(other.id, id) || other.id == id)&&(identical(other.token, token) || other.token == token)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.rewardMode, rewardMode) || other.rewardMode == rewardMode)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.status, status) || other.status == status)&&(identical(other.returnedAt, returnedAt) || other.returnedAt == returnedAt)&&(identical(other.returnedStoreId, returnedStoreId) || other.returnedStoreId == returnedStoreId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,token,merchantId,storeId,orderId,productId,rewardMode,customerPhone,status,returnedAt,returnedStoreId,createdAt);

@override
String toString() {
  return 'BottleQrToken(id: $id, token: $token, merchantId: $merchantId, storeId: $storeId, orderId: $orderId, productId: $productId, rewardMode: $rewardMode, customerPhone: $customerPhone, status: $status, returnedAt: $returnedAt, returnedStoreId: $returnedStoreId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BottleQrTokenCopyWith<$Res> implements $BottleQrTokenCopyWith<$Res> {
  factory _$BottleQrTokenCopyWith(_BottleQrToken value, $Res Function(_BottleQrToken) _then) = __$BottleQrTokenCopyWithImpl;
@override @useResult
$Res call({
 String id, String token, String merchantId, String storeId, String orderId, String productId, BottleRewardMode rewardMode, String? customerPhone, BottleTokenStatus status, DateTime? returnedAt, String? returnedStoreId, DateTime? createdAt
});




}
/// @nodoc
class __$BottleQrTokenCopyWithImpl<$Res>
    implements _$BottleQrTokenCopyWith<$Res> {
  __$BottleQrTokenCopyWithImpl(this._self, this._then);

  final _BottleQrToken _self;
  final $Res Function(_BottleQrToken) _then;

/// Create a copy of BottleQrToken
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? token = null,Object? merchantId = null,Object? storeId = null,Object? orderId = null,Object? productId = null,Object? rewardMode = null,Object? customerPhone = freezed,Object? status = null,Object? returnedAt = freezed,Object? returnedStoreId = freezed,Object? createdAt = freezed,}) {
  return _then(_BottleQrToken(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,rewardMode: null == rewardMode ? _self.rewardMode : rewardMode // ignore: cast_nullable_to_non_nullable
as BottleRewardMode,customerPhone: freezed == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BottleTokenStatus,returnedAt: freezed == returnedAt ? _self.returnedAt : returnedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,returnedStoreId: freezed == returnedStoreId ? _self.returnedStoreId : returnedStoreId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
