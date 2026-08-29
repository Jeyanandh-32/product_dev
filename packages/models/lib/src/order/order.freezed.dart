// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Order {

 String get id; String get merchantId; String get storeId; String get orderReference; int get billNo; OrderSource get source; OrderType get type; OrderStatus get status;@JsonKey(unknownEnumValue: PaymentStatus.pending) PaymentStatus get paymentStatus; PaymentMethod get paymentMethod; double get subtotal; double get discountTotal; double get walletDeduction; double get taxTotal; double get grandTotal; double get platformFee; String? get terminalCode; Customer? get customer; List<OrderItem> get items; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, id) || other.id == id)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.orderReference, orderReference) || other.orderReference == orderReference)&&(identical(other.billNo, billNo) || other.billNo == billNo)&&(identical(other.source, source) || other.source == source)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discountTotal, discountTotal) || other.discountTotal == discountTotal)&&(identical(other.walletDeduction, walletDeduction) || other.walletDeduction == walletDeduction)&&(identical(other.taxTotal, taxTotal) || other.taxTotal == taxTotal)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.terminalCode, terminalCode) || other.terminalCode == terminalCode)&&(identical(other.customer, customer) || other.customer == customer)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,merchantId,storeId,orderReference,billNo,source,type,status,paymentStatus,paymentMethod,subtotal,discountTotal,walletDeduction,taxTotal,grandTotal,platformFee,terminalCode,customer,const DeepCollectionEquality().hash(items),createdAt,updatedAt]);

@override
String toString() {
  return 'Order(id: $id, merchantId: $merchantId, storeId: $storeId, orderReference: $orderReference, billNo: $billNo, source: $source, type: $type, status: $status, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, subtotal: $subtotal, discountTotal: $discountTotal, walletDeduction: $walletDeduction, taxTotal: $taxTotal, grandTotal: $grandTotal, platformFee: $platformFee, terminalCode: $terminalCode, customer: $customer, items: $items, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 String id, String merchantId, String storeId, String orderReference, int billNo, OrderSource source, OrderType type, OrderStatus status,@JsonKey(unknownEnumValue: PaymentStatus.pending) PaymentStatus paymentStatus, PaymentMethod paymentMethod, double subtotal, double discountTotal, double walletDeduction, double taxTotal, double grandTotal, double platformFee, String? terminalCode, Customer? customer, List<OrderItem> items, DateTime createdAt, DateTime updatedAt
});


$CustomerCopyWith<$Res>? get customer;

}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? merchantId = null,Object? storeId = null,Object? orderReference = null,Object? billNo = null,Object? source = null,Object? type = null,Object? status = null,Object? paymentStatus = null,Object? paymentMethod = null,Object? subtotal = null,Object? discountTotal = null,Object? walletDeduction = null,Object? taxTotal = null,Object? grandTotal = null,Object? platformFee = null,Object? terminalCode = freezed,Object? customer = freezed,Object? items = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,orderReference: null == orderReference ? _self.orderReference : orderReference // ignore: cast_nullable_to_non_nullable
as String,billNo: null == billNo ? _self.billNo : billNo // ignore: cast_nullable_to_non_nullable
as int,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as OrderSource,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OrderType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,discountTotal: null == discountTotal ? _self.discountTotal : discountTotal // ignore: cast_nullable_to_non_nullable
as double,walletDeduction: null == walletDeduction ? _self.walletDeduction : walletDeduction // ignore: cast_nullable_to_non_nullable
as double,taxTotal: null == taxTotal ? _self.taxTotal : taxTotal // ignore: cast_nullable_to_non_nullable
as double,grandTotal: null == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as double,platformFee: null == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as double,terminalCode: freezed == terminalCode ? _self.terminalCode : terminalCode // ignore: cast_nullable_to_non_nullable
as String?,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as Customer?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $CustomerCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}


/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String merchantId,  String storeId,  String orderReference,  int billNo,  OrderSource source,  OrderType type,  OrderStatus status, @JsonKey(unknownEnumValue: PaymentStatus.pending)  PaymentStatus paymentStatus,  PaymentMethod paymentMethod,  double subtotal,  double discountTotal,  double walletDeduction,  double taxTotal,  double grandTotal,  double platformFee,  String? terminalCode,  Customer? customer,  List<OrderItem> items,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.merchantId,_that.storeId,_that.orderReference,_that.billNo,_that.source,_that.type,_that.status,_that.paymentStatus,_that.paymentMethod,_that.subtotal,_that.discountTotal,_that.walletDeduction,_that.taxTotal,_that.grandTotal,_that.platformFee,_that.terminalCode,_that.customer,_that.items,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String merchantId,  String storeId,  String orderReference,  int billNo,  OrderSource source,  OrderType type,  OrderStatus status, @JsonKey(unknownEnumValue: PaymentStatus.pending)  PaymentStatus paymentStatus,  PaymentMethod paymentMethod,  double subtotal,  double discountTotal,  double walletDeduction,  double taxTotal,  double grandTotal,  double platformFee,  String? terminalCode,  Customer? customer,  List<OrderItem> items,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.merchantId,_that.storeId,_that.orderReference,_that.billNo,_that.source,_that.type,_that.status,_that.paymentStatus,_that.paymentMethod,_that.subtotal,_that.discountTotal,_that.walletDeduction,_that.taxTotal,_that.grandTotal,_that.platformFee,_that.terminalCode,_that.customer,_that.items,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String merchantId,  String storeId,  String orderReference,  int billNo,  OrderSource source,  OrderType type,  OrderStatus status, @JsonKey(unknownEnumValue: PaymentStatus.pending)  PaymentStatus paymentStatus,  PaymentMethod paymentMethod,  double subtotal,  double discountTotal,  double walletDeduction,  double taxTotal,  double grandTotal,  double platformFee,  String? terminalCode,  Customer? customer,  List<OrderItem> items,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.merchantId,_that.storeId,_that.orderReference,_that.billNo,_that.source,_that.type,_that.status,_that.paymentStatus,_that.paymentMethod,_that.subtotal,_that.discountTotal,_that.walletDeduction,_that.taxTotal,_that.grandTotal,_that.platformFee,_that.terminalCode,_that.customer,_that.items,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Order implements Order {
  const _Order({required this.id, required this.merchantId, required this.storeId, required this.orderReference, required this.billNo, required this.source, required this.type, required this.status, @JsonKey(unknownEnumValue: PaymentStatus.pending) required this.paymentStatus, required this.paymentMethod, required this.subtotal, this.discountTotal = 0.0, this.walletDeduction = 0.0, required this.taxTotal, required this.grandTotal, this.platformFee = 0.0, this.terminalCode, this.customer, required this.items, required this.createdAt, required this.updatedAt});
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

@override final  String id;
@override final  String merchantId;
@override final  String storeId;
@override final  String orderReference;
@override final  int billNo;
@override final  OrderSource source;
@override final  OrderType type;
@override final  OrderStatus status;
@override@JsonKey(unknownEnumValue: PaymentStatus.pending) final  PaymentStatus paymentStatus;
@override final  PaymentMethod paymentMethod;
@override final  double subtotal;
@override@JsonKey() final  double discountTotal;
@override@JsonKey() final  double walletDeduction;
@override final  double taxTotal;
@override final  double grandTotal;
@override@JsonKey() final  double platformFee;
@override final  String? terminalCode;
@override final  Customer? customer;
@override final  List<OrderItem> items;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.orderReference, orderReference) || other.orderReference == orderReference)&&(identical(other.billNo, billNo) || other.billNo == billNo)&&(identical(other.source, source) || other.source == source)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discountTotal, discountTotal) || other.discountTotal == discountTotal)&&(identical(other.walletDeduction, walletDeduction) || other.walletDeduction == walletDeduction)&&(identical(other.taxTotal, taxTotal) || other.taxTotal == taxTotal)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.terminalCode, terminalCode) || other.terminalCode == terminalCode)&&(identical(other.customer, customer) || other.customer == customer)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,merchantId,storeId,orderReference,billNo,source,type,status,paymentStatus,paymentMethod,subtotal,discountTotal,walletDeduction,taxTotal,grandTotal,platformFee,terminalCode,customer,const DeepCollectionEquality().hash(items),createdAt,updatedAt]);

@override
String toString() {
  return 'Order(id: $id, merchantId: $merchantId, storeId: $storeId, orderReference: $orderReference, billNo: $billNo, source: $source, type: $type, status: $status, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, subtotal: $subtotal, discountTotal: $discountTotal, walletDeduction: $walletDeduction, taxTotal: $taxTotal, grandTotal: $grandTotal, platformFee: $platformFee, terminalCode: $terminalCode, customer: $customer, items: $items, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String merchantId, String storeId, String orderReference, int billNo, OrderSource source, OrderType type, OrderStatus status,@JsonKey(unknownEnumValue: PaymentStatus.pending) PaymentStatus paymentStatus, PaymentMethod paymentMethod, double subtotal, double discountTotal, double walletDeduction, double taxTotal, double grandTotal, double platformFee, String? terminalCode, Customer? customer, List<OrderItem> items, DateTime createdAt, DateTime updatedAt
});


@override $CustomerCopyWith<$Res>? get customer;

}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? merchantId = null,Object? storeId = null,Object? orderReference = null,Object? billNo = null,Object? source = null,Object? type = null,Object? status = null,Object? paymentStatus = null,Object? paymentMethod = null,Object? subtotal = null,Object? discountTotal = null,Object? walletDeduction = null,Object? taxTotal = null,Object? grandTotal = null,Object? platformFee = null,Object? terminalCode = freezed,Object? customer = freezed,Object? items = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,orderReference: null == orderReference ? _self.orderReference : orderReference // ignore: cast_nullable_to_non_nullable
as String,billNo: null == billNo ? _self.billNo : billNo // ignore: cast_nullable_to_non_nullable
as int,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as OrderSource,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OrderType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,discountTotal: null == discountTotal ? _self.discountTotal : discountTotal // ignore: cast_nullable_to_non_nullable
as double,walletDeduction: null == walletDeduction ? _self.walletDeduction : walletDeduction // ignore: cast_nullable_to_non_nullable
as double,taxTotal: null == taxTotal ? _self.taxTotal : taxTotal // ignore: cast_nullable_to_non_nullable
as double,grandTotal: null == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as double,platformFee: null == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as double,terminalCode: freezed == terminalCode ? _self.terminalCode : terminalCode // ignore: cast_nullable_to_non_nullable
as String?,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as Customer?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $CustomerCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}

// dart format on
