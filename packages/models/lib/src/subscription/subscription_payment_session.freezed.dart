// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_payment_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubscriptionPaymentSession {

 String get storeId; String get planCode; String get merchantTransactionId; int get amountInPaise; String get tokenUrl; String? get redirectUrl; String? get orderId;
/// Create a copy of SubscriptionPaymentSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionPaymentSessionCopyWith<SubscriptionPaymentSession> get copyWith => _$SubscriptionPaymentSessionCopyWithImpl<SubscriptionPaymentSession>(this as SubscriptionPaymentSession, _$identity);

  /// Serializes this SubscriptionPaymentSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionPaymentSession&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.planCode, planCode) || other.planCode == planCode)&&(identical(other.merchantTransactionId, merchantTransactionId) || other.merchantTransactionId == merchantTransactionId)&&(identical(other.amountInPaise, amountInPaise) || other.amountInPaise == amountInPaise)&&(identical(other.tokenUrl, tokenUrl) || other.tokenUrl == tokenUrl)&&(identical(other.redirectUrl, redirectUrl) || other.redirectUrl == redirectUrl)&&(identical(other.orderId, orderId) || other.orderId == orderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storeId,planCode,merchantTransactionId,amountInPaise,tokenUrl,redirectUrl,orderId);

@override
String toString() {
  return 'SubscriptionPaymentSession(storeId: $storeId, planCode: $planCode, merchantTransactionId: $merchantTransactionId, amountInPaise: $amountInPaise, tokenUrl: $tokenUrl, redirectUrl: $redirectUrl, orderId: $orderId)';
}


}

/// @nodoc
abstract mixin class $SubscriptionPaymentSessionCopyWith<$Res>  {
  factory $SubscriptionPaymentSessionCopyWith(SubscriptionPaymentSession value, $Res Function(SubscriptionPaymentSession) _then) = _$SubscriptionPaymentSessionCopyWithImpl;
@useResult
$Res call({
 String storeId, String planCode, String merchantTransactionId, int amountInPaise, String tokenUrl, String? redirectUrl, String? orderId
});




}
/// @nodoc
class _$SubscriptionPaymentSessionCopyWithImpl<$Res>
    implements $SubscriptionPaymentSessionCopyWith<$Res> {
  _$SubscriptionPaymentSessionCopyWithImpl(this._self, this._then);

  final SubscriptionPaymentSession _self;
  final $Res Function(SubscriptionPaymentSession) _then;

/// Create a copy of SubscriptionPaymentSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeId = null,Object? planCode = null,Object? merchantTransactionId = null,Object? amountInPaise = null,Object? tokenUrl = null,Object? redirectUrl = freezed,Object? orderId = freezed,}) {
  return _then(_self.copyWith(
storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,planCode: null == planCode ? _self.planCode : planCode // ignore: cast_nullable_to_non_nullable
as String,merchantTransactionId: null == merchantTransactionId ? _self.merchantTransactionId : merchantTransactionId // ignore: cast_nullable_to_non_nullable
as String,amountInPaise: null == amountInPaise ? _self.amountInPaise : amountInPaise // ignore: cast_nullable_to_non_nullable
as int,tokenUrl: null == tokenUrl ? _self.tokenUrl : tokenUrl // ignore: cast_nullable_to_non_nullable
as String,redirectUrl: freezed == redirectUrl ? _self.redirectUrl : redirectUrl // ignore: cast_nullable_to_non_nullable
as String?,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscriptionPaymentSession].
extension SubscriptionPaymentSessionPatterns on SubscriptionPaymentSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscriptionPaymentSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscriptionPaymentSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscriptionPaymentSession value)  $default,){
final _that = this;
switch (_that) {
case _SubscriptionPaymentSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscriptionPaymentSession value)?  $default,){
final _that = this;
switch (_that) {
case _SubscriptionPaymentSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String storeId,  String planCode,  String merchantTransactionId,  int amountInPaise,  String tokenUrl,  String? redirectUrl,  String? orderId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscriptionPaymentSession() when $default != null:
return $default(_that.storeId,_that.planCode,_that.merchantTransactionId,_that.amountInPaise,_that.tokenUrl,_that.redirectUrl,_that.orderId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String storeId,  String planCode,  String merchantTransactionId,  int amountInPaise,  String tokenUrl,  String? redirectUrl,  String? orderId)  $default,) {final _that = this;
switch (_that) {
case _SubscriptionPaymentSession():
return $default(_that.storeId,_that.planCode,_that.merchantTransactionId,_that.amountInPaise,_that.tokenUrl,_that.redirectUrl,_that.orderId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String storeId,  String planCode,  String merchantTransactionId,  int amountInPaise,  String tokenUrl,  String? redirectUrl,  String? orderId)?  $default,) {final _that = this;
switch (_that) {
case _SubscriptionPaymentSession() when $default != null:
return $default(_that.storeId,_that.planCode,_that.merchantTransactionId,_that.amountInPaise,_that.tokenUrl,_that.redirectUrl,_that.orderId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubscriptionPaymentSession implements SubscriptionPaymentSession {
  const _SubscriptionPaymentSession({required this.storeId, required this.planCode, required this.merchantTransactionId, required this.amountInPaise, required this.tokenUrl, this.redirectUrl, this.orderId});
  factory _SubscriptionPaymentSession.fromJson(Map<String, dynamic> json) => _$SubscriptionPaymentSessionFromJson(json);

@override final  String storeId;
@override final  String planCode;
@override final  String merchantTransactionId;
@override final  int amountInPaise;
@override final  String tokenUrl;
@override final  String? redirectUrl;
@override final  String? orderId;

/// Create a copy of SubscriptionPaymentSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionPaymentSessionCopyWith<_SubscriptionPaymentSession> get copyWith => __$SubscriptionPaymentSessionCopyWithImpl<_SubscriptionPaymentSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubscriptionPaymentSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionPaymentSession&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.planCode, planCode) || other.planCode == planCode)&&(identical(other.merchantTransactionId, merchantTransactionId) || other.merchantTransactionId == merchantTransactionId)&&(identical(other.amountInPaise, amountInPaise) || other.amountInPaise == amountInPaise)&&(identical(other.tokenUrl, tokenUrl) || other.tokenUrl == tokenUrl)&&(identical(other.redirectUrl, redirectUrl) || other.redirectUrl == redirectUrl)&&(identical(other.orderId, orderId) || other.orderId == orderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storeId,planCode,merchantTransactionId,amountInPaise,tokenUrl,redirectUrl,orderId);

@override
String toString() {
  return 'SubscriptionPaymentSession(storeId: $storeId, planCode: $planCode, merchantTransactionId: $merchantTransactionId, amountInPaise: $amountInPaise, tokenUrl: $tokenUrl, redirectUrl: $redirectUrl, orderId: $orderId)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionPaymentSessionCopyWith<$Res> implements $SubscriptionPaymentSessionCopyWith<$Res> {
  factory _$SubscriptionPaymentSessionCopyWith(_SubscriptionPaymentSession value, $Res Function(_SubscriptionPaymentSession) _then) = __$SubscriptionPaymentSessionCopyWithImpl;
@override @useResult
$Res call({
 String storeId, String planCode, String merchantTransactionId, int amountInPaise, String tokenUrl, String? redirectUrl, String? orderId
});




}
/// @nodoc
class __$SubscriptionPaymentSessionCopyWithImpl<$Res>
    implements _$SubscriptionPaymentSessionCopyWith<$Res> {
  __$SubscriptionPaymentSessionCopyWithImpl(this._self, this._then);

  final _SubscriptionPaymentSession _self;
  final $Res Function(_SubscriptionPaymentSession) _then;

/// Create a copy of SubscriptionPaymentSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeId = null,Object? planCode = null,Object? merchantTransactionId = null,Object? amountInPaise = null,Object? tokenUrl = null,Object? redirectUrl = freezed,Object? orderId = freezed,}) {
  return _then(_SubscriptionPaymentSession(
storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,planCode: null == planCode ? _self.planCode : planCode // ignore: cast_nullable_to_non_nullable
as String,merchantTransactionId: null == merchantTransactionId ? _self.merchantTransactionId : merchantTransactionId // ignore: cast_nullable_to_non_nullable
as String,amountInPaise: null == amountInPaise ? _self.amountInPaise : amountInPaise // ignore: cast_nullable_to_non_nullable
as int,tokenUrl: null == tokenUrl ? _self.tokenUrl : tokenUrl // ignore: cast_nullable_to_non_nullable
as String,redirectUrl: freezed == redirectUrl ? _self.redirectUrl : redirectUrl // ignore: cast_nullable_to_non_nullable
as String?,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
