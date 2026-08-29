// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubscriptionTransaction {

 String get id; String get storeId; SubscriptionPlanCode get planCode; int get amountInPaise; String get currency; SubscriptionPaymentMethod get paymentMethod; PaymentStatus get status; String? get reference; DateTime? get createdAt;
/// Create a copy of SubscriptionTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionTransactionCopyWith<SubscriptionTransaction> get copyWith => _$SubscriptionTransactionCopyWithImpl<SubscriptionTransaction>(this as SubscriptionTransaction, _$identity);

  /// Serializes this SubscriptionTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.planCode, planCode) || other.planCode == planCode)&&(identical(other.amountInPaise, amountInPaise) || other.amountInPaise == amountInPaise)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.status, status) || other.status == status)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,planCode,amountInPaise,currency,paymentMethod,status,reference,createdAt);

@override
String toString() {
  return 'SubscriptionTransaction(id: $id, storeId: $storeId, planCode: $planCode, amountInPaise: $amountInPaise, currency: $currency, paymentMethod: $paymentMethod, status: $status, reference: $reference, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SubscriptionTransactionCopyWith<$Res>  {
  factory $SubscriptionTransactionCopyWith(SubscriptionTransaction value, $Res Function(SubscriptionTransaction) _then) = _$SubscriptionTransactionCopyWithImpl;
@useResult
$Res call({
 String id, String storeId, SubscriptionPlanCode planCode, int amountInPaise, String currency, SubscriptionPaymentMethod paymentMethod, PaymentStatus status, String? reference, DateTime? createdAt
});




}
/// @nodoc
class _$SubscriptionTransactionCopyWithImpl<$Res>
    implements $SubscriptionTransactionCopyWith<$Res> {
  _$SubscriptionTransactionCopyWithImpl(this._self, this._then);

  final SubscriptionTransaction _self;
  final $Res Function(SubscriptionTransaction) _then;

/// Create a copy of SubscriptionTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storeId = null,Object? planCode = null,Object? amountInPaise = null,Object? currency = null,Object? paymentMethod = null,Object? status = null,Object? reference = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,planCode: null == planCode ? _self.planCode : planCode // ignore: cast_nullable_to_non_nullable
as SubscriptionPlanCode,amountInPaise: null == amountInPaise ? _self.amountInPaise : amountInPaise // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as SubscriptionPaymentMethod,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscriptionTransaction].
extension SubscriptionTransactionPatterns on SubscriptionTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscriptionTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscriptionTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscriptionTransaction value)  $default,){
final _that = this;
switch (_that) {
case _SubscriptionTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscriptionTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _SubscriptionTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String storeId,  SubscriptionPlanCode planCode,  int amountInPaise,  String currency,  SubscriptionPaymentMethod paymentMethod,  PaymentStatus status,  String? reference,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscriptionTransaction() when $default != null:
return $default(_that.id,_that.storeId,_that.planCode,_that.amountInPaise,_that.currency,_that.paymentMethod,_that.status,_that.reference,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String storeId,  SubscriptionPlanCode planCode,  int amountInPaise,  String currency,  SubscriptionPaymentMethod paymentMethod,  PaymentStatus status,  String? reference,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _SubscriptionTransaction():
return $default(_that.id,_that.storeId,_that.planCode,_that.amountInPaise,_that.currency,_that.paymentMethod,_that.status,_that.reference,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String storeId,  SubscriptionPlanCode planCode,  int amountInPaise,  String currency,  SubscriptionPaymentMethod paymentMethod,  PaymentStatus status,  String? reference,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SubscriptionTransaction() when $default != null:
return $default(_that.id,_that.storeId,_that.planCode,_that.amountInPaise,_that.currency,_that.paymentMethod,_that.status,_that.reference,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubscriptionTransaction implements SubscriptionTransaction {
  const _SubscriptionTransaction({required this.id, required this.storeId, required this.planCode, required this.amountInPaise, this.currency = 'INR', required this.paymentMethod, required this.status, this.reference, this.createdAt});
  factory _SubscriptionTransaction.fromJson(Map<String, dynamic> json) => _$SubscriptionTransactionFromJson(json);

@override final  String id;
@override final  String storeId;
@override final  SubscriptionPlanCode planCode;
@override final  int amountInPaise;
@override@JsonKey() final  String currency;
@override final  SubscriptionPaymentMethod paymentMethod;
@override final  PaymentStatus status;
@override final  String? reference;
@override final  DateTime? createdAt;

/// Create a copy of SubscriptionTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionTransactionCopyWith<_SubscriptionTransaction> get copyWith => __$SubscriptionTransactionCopyWithImpl<_SubscriptionTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubscriptionTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.planCode, planCode) || other.planCode == planCode)&&(identical(other.amountInPaise, amountInPaise) || other.amountInPaise == amountInPaise)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.status, status) || other.status == status)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,planCode,amountInPaise,currency,paymentMethod,status,reference,createdAt);

@override
String toString() {
  return 'SubscriptionTransaction(id: $id, storeId: $storeId, planCode: $planCode, amountInPaise: $amountInPaise, currency: $currency, paymentMethod: $paymentMethod, status: $status, reference: $reference, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionTransactionCopyWith<$Res> implements $SubscriptionTransactionCopyWith<$Res> {
  factory _$SubscriptionTransactionCopyWith(_SubscriptionTransaction value, $Res Function(_SubscriptionTransaction) _then) = __$SubscriptionTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String storeId, SubscriptionPlanCode planCode, int amountInPaise, String currency, SubscriptionPaymentMethod paymentMethod, PaymentStatus status, String? reference, DateTime? createdAt
});




}
/// @nodoc
class __$SubscriptionTransactionCopyWithImpl<$Res>
    implements _$SubscriptionTransactionCopyWith<$Res> {
  __$SubscriptionTransactionCopyWithImpl(this._self, this._then);

  final _SubscriptionTransaction _self;
  final $Res Function(_SubscriptionTransaction) _then;

/// Create a copy of SubscriptionTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storeId = null,Object? planCode = null,Object? amountInPaise = null,Object? currency = null,Object? paymentMethod = null,Object? status = null,Object? reference = freezed,Object? createdAt = freezed,}) {
  return _then(_SubscriptionTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,planCode: null == planCode ? _self.planCode : planCode // ignore: cast_nullable_to_non_nullable
as SubscriptionPlanCode,amountInPaise: null == amountInPaise ? _self.amountInPaise : amountInPaise // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as SubscriptionPaymentMethod,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
