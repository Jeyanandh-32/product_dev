// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_wallet_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerWalletTransaction {

 String get id; String get customerId; double get amount; WalletTransactionType get type; String? get reference; String get status; double get platformFee; double get gatewayCharges; DateTime get createdAt;
/// Create a copy of CustomerWalletTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerWalletTransactionCopyWith<CustomerWalletTransaction> get copyWith => _$CustomerWalletTransactionCopyWithImpl<CustomerWalletTransaction>(this as CustomerWalletTransaction, _$identity);

  /// Serializes this CustomerWalletTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerWalletTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.status, status) || other.status == status)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.gatewayCharges, gatewayCharges) || other.gatewayCharges == gatewayCharges)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,amount,type,reference,status,platformFee,gatewayCharges,createdAt);

@override
String toString() {
  return 'CustomerWalletTransaction(id: $id, customerId: $customerId, amount: $amount, type: $type, reference: $reference, status: $status, platformFee: $platformFee, gatewayCharges: $gatewayCharges, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CustomerWalletTransactionCopyWith<$Res>  {
  factory $CustomerWalletTransactionCopyWith(CustomerWalletTransaction value, $Res Function(CustomerWalletTransaction) _then) = _$CustomerWalletTransactionCopyWithImpl;
@useResult
$Res call({
 String id, String customerId, double amount, WalletTransactionType type, String? reference, String status, double platformFee, double gatewayCharges, DateTime createdAt
});




}
/// @nodoc
class _$CustomerWalletTransactionCopyWithImpl<$Res>
    implements $CustomerWalletTransactionCopyWith<$Res> {
  _$CustomerWalletTransactionCopyWithImpl(this._self, this._then);

  final CustomerWalletTransaction _self;
  final $Res Function(CustomerWalletTransaction) _then;

/// Create a copy of CustomerWalletTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customerId = null,Object? amount = null,Object? type = null,Object? reference = freezed,Object? status = null,Object? platformFee = null,Object? gatewayCharges = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletTransactionType,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,platformFee: null == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as double,gatewayCharges: null == gatewayCharges ? _self.gatewayCharges : gatewayCharges // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerWalletTransaction].
extension CustomerWalletTransactionPatterns on CustomerWalletTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerWalletTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerWalletTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerWalletTransaction value)  $default,){
final _that = this;
switch (_that) {
case _CustomerWalletTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerWalletTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerWalletTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String customerId,  double amount,  WalletTransactionType type,  String? reference,  String status,  double platformFee,  double gatewayCharges,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerWalletTransaction() when $default != null:
return $default(_that.id,_that.customerId,_that.amount,_that.type,_that.reference,_that.status,_that.platformFee,_that.gatewayCharges,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String customerId,  double amount,  WalletTransactionType type,  String? reference,  String status,  double platformFee,  double gatewayCharges,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _CustomerWalletTransaction():
return $default(_that.id,_that.customerId,_that.amount,_that.type,_that.reference,_that.status,_that.platformFee,_that.gatewayCharges,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String customerId,  double amount,  WalletTransactionType type,  String? reference,  String status,  double platformFee,  double gatewayCharges,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CustomerWalletTransaction() when $default != null:
return $default(_that.id,_that.customerId,_that.amount,_that.type,_that.reference,_that.status,_that.platformFee,_that.gatewayCharges,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerWalletTransaction implements CustomerWalletTransaction {
  const _CustomerWalletTransaction({required this.id, required this.customerId, required this.amount, required this.type, this.reference, required this.status, this.platformFee = 0.0, this.gatewayCharges = 0.0, required this.createdAt});
  factory _CustomerWalletTransaction.fromJson(Map<String, dynamic> json) => _$CustomerWalletTransactionFromJson(json);

@override final  String id;
@override final  String customerId;
@override final  double amount;
@override final  WalletTransactionType type;
@override final  String? reference;
@override final  String status;
@override@JsonKey() final  double platformFee;
@override@JsonKey() final  double gatewayCharges;
@override final  DateTime createdAt;

/// Create a copy of CustomerWalletTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerWalletTransactionCopyWith<_CustomerWalletTransaction> get copyWith => __$CustomerWalletTransactionCopyWithImpl<_CustomerWalletTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerWalletTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerWalletTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.status, status) || other.status == status)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.gatewayCharges, gatewayCharges) || other.gatewayCharges == gatewayCharges)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,amount,type,reference,status,platformFee,gatewayCharges,createdAt);

@override
String toString() {
  return 'CustomerWalletTransaction(id: $id, customerId: $customerId, amount: $amount, type: $type, reference: $reference, status: $status, platformFee: $platformFee, gatewayCharges: $gatewayCharges, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CustomerWalletTransactionCopyWith<$Res> implements $CustomerWalletTransactionCopyWith<$Res> {
  factory _$CustomerWalletTransactionCopyWith(_CustomerWalletTransaction value, $Res Function(_CustomerWalletTransaction) _then) = __$CustomerWalletTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String customerId, double amount, WalletTransactionType type, String? reference, String status, double platformFee, double gatewayCharges, DateTime createdAt
});




}
/// @nodoc
class __$CustomerWalletTransactionCopyWithImpl<$Res>
    implements _$CustomerWalletTransactionCopyWith<$Res> {
  __$CustomerWalletTransactionCopyWithImpl(this._self, this._then);

  final _CustomerWalletTransaction _self;
  final $Res Function(_CustomerWalletTransaction) _then;

/// Create a copy of CustomerWalletTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customerId = null,Object? amount = null,Object? type = null,Object? reference = freezed,Object? status = null,Object? platformFee = null,Object? gatewayCharges = null,Object? createdAt = null,}) {
  return _then(_CustomerWalletTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletTransactionType,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,platformFee: null == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as double,gatewayCharges: null == gatewayCharges ? _self.gatewayCharges : gatewayCharges // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
