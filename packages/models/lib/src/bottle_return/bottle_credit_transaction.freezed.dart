// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bottle_credit_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BottleCreditTransaction {

 String get id; String get merchantId; String get customerPhone; int get amount; String get type; String? get referenceOrderId; String? get storeId; DateTime? get createdAt;
/// Create a copy of BottleCreditTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BottleCreditTransactionCopyWith<BottleCreditTransaction> get copyWith => _$BottleCreditTransactionCopyWithImpl<BottleCreditTransaction>(this as BottleCreditTransaction, _$identity);

  /// Serializes this BottleCreditTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BottleCreditTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.referenceOrderId, referenceOrderId) || other.referenceOrderId == referenceOrderId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,merchantId,customerPhone,amount,type,referenceOrderId,storeId,createdAt);

@override
String toString() {
  return 'BottleCreditTransaction(id: $id, merchantId: $merchantId, customerPhone: $customerPhone, amount: $amount, type: $type, referenceOrderId: $referenceOrderId, storeId: $storeId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BottleCreditTransactionCopyWith<$Res>  {
  factory $BottleCreditTransactionCopyWith(BottleCreditTransaction value, $Res Function(BottleCreditTransaction) _then) = _$BottleCreditTransactionCopyWithImpl;
@useResult
$Res call({
 String id, String merchantId, String customerPhone, int amount, String type, String? referenceOrderId, String? storeId, DateTime? createdAt
});




}
/// @nodoc
class _$BottleCreditTransactionCopyWithImpl<$Res>
    implements $BottleCreditTransactionCopyWith<$Res> {
  _$BottleCreditTransactionCopyWithImpl(this._self, this._then);

  final BottleCreditTransaction _self;
  final $Res Function(BottleCreditTransaction) _then;

/// Create a copy of BottleCreditTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? merchantId = null,Object? customerPhone = null,Object? amount = null,Object? type = null,Object? referenceOrderId = freezed,Object? storeId = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,customerPhone: null == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,referenceOrderId: freezed == referenceOrderId ? _self.referenceOrderId : referenceOrderId // ignore: cast_nullable_to_non_nullable
as String?,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BottleCreditTransaction].
extension BottleCreditTransactionPatterns on BottleCreditTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BottleCreditTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BottleCreditTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BottleCreditTransaction value)  $default,){
final _that = this;
switch (_that) {
case _BottleCreditTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BottleCreditTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _BottleCreditTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String merchantId,  String customerPhone,  int amount,  String type,  String? referenceOrderId,  String? storeId,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BottleCreditTransaction() when $default != null:
return $default(_that.id,_that.merchantId,_that.customerPhone,_that.amount,_that.type,_that.referenceOrderId,_that.storeId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String merchantId,  String customerPhone,  int amount,  String type,  String? referenceOrderId,  String? storeId,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _BottleCreditTransaction():
return $default(_that.id,_that.merchantId,_that.customerPhone,_that.amount,_that.type,_that.referenceOrderId,_that.storeId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String merchantId,  String customerPhone,  int amount,  String type,  String? referenceOrderId,  String? storeId,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BottleCreditTransaction() when $default != null:
return $default(_that.id,_that.merchantId,_that.customerPhone,_that.amount,_that.type,_that.referenceOrderId,_that.storeId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BottleCreditTransaction implements BottleCreditTransaction {
  const _BottleCreditTransaction({required this.id, required this.merchantId, required this.customerPhone, required this.amount, required this.type, this.referenceOrderId, this.storeId, this.createdAt});
  factory _BottleCreditTransaction.fromJson(Map<String, dynamic> json) => _$BottleCreditTransactionFromJson(json);

@override final  String id;
@override final  String merchantId;
@override final  String customerPhone;
@override final  int amount;
@override final  String type;
@override final  String? referenceOrderId;
@override final  String? storeId;
@override final  DateTime? createdAt;

/// Create a copy of BottleCreditTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BottleCreditTransactionCopyWith<_BottleCreditTransaction> get copyWith => __$BottleCreditTransactionCopyWithImpl<_BottleCreditTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BottleCreditTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BottleCreditTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.referenceOrderId, referenceOrderId) || other.referenceOrderId == referenceOrderId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,merchantId,customerPhone,amount,type,referenceOrderId,storeId,createdAt);

@override
String toString() {
  return 'BottleCreditTransaction(id: $id, merchantId: $merchantId, customerPhone: $customerPhone, amount: $amount, type: $type, referenceOrderId: $referenceOrderId, storeId: $storeId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BottleCreditTransactionCopyWith<$Res> implements $BottleCreditTransactionCopyWith<$Res> {
  factory _$BottleCreditTransactionCopyWith(_BottleCreditTransaction value, $Res Function(_BottleCreditTransaction) _then) = __$BottleCreditTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String merchantId, String customerPhone, int amount, String type, String? referenceOrderId, String? storeId, DateTime? createdAt
});




}
/// @nodoc
class __$BottleCreditTransactionCopyWithImpl<$Res>
    implements _$BottleCreditTransactionCopyWith<$Res> {
  __$BottleCreditTransactionCopyWithImpl(this._self, this._then);

  final _BottleCreditTransaction _self;
  final $Res Function(_BottleCreditTransaction) _then;

/// Create a copy of BottleCreditTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? merchantId = null,Object? customerPhone = null,Object? amount = null,Object? type = null,Object? referenceOrderId = freezed,Object? storeId = freezed,Object? createdAt = freezed,}) {
  return _then(_BottleCreditTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,customerPhone: null == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,referenceOrderId: freezed == referenceOrderId ? _self.referenceOrderId : referenceOrderId // ignore: cast_nullable_to_non_nullable
as String?,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
