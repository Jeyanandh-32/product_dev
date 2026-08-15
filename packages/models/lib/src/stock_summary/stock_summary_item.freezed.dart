// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_summary_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StockSummaryItem {

 String get productId; String get productName; String get categoryName; String get counterName; int get openingStock; int get inQuantity; int get outQuantity; int get wastageQuantity; int get adjustmentQuantity; int get closingStock;
/// Create a copy of StockSummaryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockSummaryItemCopyWith<StockSummaryItem> get copyWith => _$StockSummaryItemCopyWithImpl<StockSummaryItem>(this as StockSummaryItem, _$identity);

  /// Serializes this StockSummaryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockSummaryItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.counterName, counterName) || other.counterName == counterName)&&(identical(other.openingStock, openingStock) || other.openingStock == openingStock)&&(identical(other.inQuantity, inQuantity) || other.inQuantity == inQuantity)&&(identical(other.outQuantity, outQuantity) || other.outQuantity == outQuantity)&&(identical(other.wastageQuantity, wastageQuantity) || other.wastageQuantity == wastageQuantity)&&(identical(other.adjustmentQuantity, adjustmentQuantity) || other.adjustmentQuantity == adjustmentQuantity)&&(identical(other.closingStock, closingStock) || other.closingStock == closingStock));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productName,categoryName,counterName,openingStock,inQuantity,outQuantity,wastageQuantity,adjustmentQuantity,closingStock);

@override
String toString() {
  return 'StockSummaryItem(productId: $productId, productName: $productName, categoryName: $categoryName, counterName: $counterName, openingStock: $openingStock, inQuantity: $inQuantity, outQuantity: $outQuantity, wastageQuantity: $wastageQuantity, adjustmentQuantity: $adjustmentQuantity, closingStock: $closingStock)';
}


}

/// @nodoc
abstract mixin class $StockSummaryItemCopyWith<$Res>  {
  factory $StockSummaryItemCopyWith(StockSummaryItem value, $Res Function(StockSummaryItem) _then) = _$StockSummaryItemCopyWithImpl;
@useResult
$Res call({
 String productId, String productName, String categoryName, String counterName, int openingStock, int inQuantity, int outQuantity, int wastageQuantity, int adjustmentQuantity, int closingStock
});




}
/// @nodoc
class _$StockSummaryItemCopyWithImpl<$Res>
    implements $StockSummaryItemCopyWith<$Res> {
  _$StockSummaryItemCopyWithImpl(this._self, this._then);

  final StockSummaryItem _self;
  final $Res Function(StockSummaryItem) _then;

/// Create a copy of StockSummaryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? categoryName = null,Object? counterName = null,Object? openingStock = null,Object? inQuantity = null,Object? outQuantity = null,Object? wastageQuantity = null,Object? adjustmentQuantity = null,Object? closingStock = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,counterName: null == counterName ? _self.counterName : counterName // ignore: cast_nullable_to_non_nullable
as String,openingStock: null == openingStock ? _self.openingStock : openingStock // ignore: cast_nullable_to_non_nullable
as int,inQuantity: null == inQuantity ? _self.inQuantity : inQuantity // ignore: cast_nullable_to_non_nullable
as int,outQuantity: null == outQuantity ? _self.outQuantity : outQuantity // ignore: cast_nullable_to_non_nullable
as int,wastageQuantity: null == wastageQuantity ? _self.wastageQuantity : wastageQuantity // ignore: cast_nullable_to_non_nullable
as int,adjustmentQuantity: null == adjustmentQuantity ? _self.adjustmentQuantity : adjustmentQuantity // ignore: cast_nullable_to_non_nullable
as int,closingStock: null == closingStock ? _self.closingStock : closingStock // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StockSummaryItem].
extension StockSummaryItemPatterns on StockSummaryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockSummaryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockSummaryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockSummaryItem value)  $default,){
final _that = this;
switch (_that) {
case _StockSummaryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockSummaryItem value)?  $default,){
final _that = this;
switch (_that) {
case _StockSummaryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String productName,  String categoryName,  String counterName,  int openingStock,  int inQuantity,  int outQuantity,  int wastageQuantity,  int adjustmentQuantity,  int closingStock)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockSummaryItem() when $default != null:
return $default(_that.productId,_that.productName,_that.categoryName,_that.counterName,_that.openingStock,_that.inQuantity,_that.outQuantity,_that.wastageQuantity,_that.adjustmentQuantity,_that.closingStock);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String productName,  String categoryName,  String counterName,  int openingStock,  int inQuantity,  int outQuantity,  int wastageQuantity,  int adjustmentQuantity,  int closingStock)  $default,) {final _that = this;
switch (_that) {
case _StockSummaryItem():
return $default(_that.productId,_that.productName,_that.categoryName,_that.counterName,_that.openingStock,_that.inQuantity,_that.outQuantity,_that.wastageQuantity,_that.adjustmentQuantity,_that.closingStock);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String productName,  String categoryName,  String counterName,  int openingStock,  int inQuantity,  int outQuantity,  int wastageQuantity,  int adjustmentQuantity,  int closingStock)?  $default,) {final _that = this;
switch (_that) {
case _StockSummaryItem() when $default != null:
return $default(_that.productId,_that.productName,_that.categoryName,_that.counterName,_that.openingStock,_that.inQuantity,_that.outQuantity,_that.wastageQuantity,_that.adjustmentQuantity,_that.closingStock);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockSummaryItem implements StockSummaryItem {
  const _StockSummaryItem({required this.productId, required this.productName, required this.categoryName, required this.counterName, required this.openingStock, required this.inQuantity, required this.outQuantity, required this.wastageQuantity, required this.adjustmentQuantity, required this.closingStock});
  factory _StockSummaryItem.fromJson(Map<String, dynamic> json) => _$StockSummaryItemFromJson(json);

@override final  String productId;
@override final  String productName;
@override final  String categoryName;
@override final  String counterName;
@override final  int openingStock;
@override final  int inQuantity;
@override final  int outQuantity;
@override final  int wastageQuantity;
@override final  int adjustmentQuantity;
@override final  int closingStock;

/// Create a copy of StockSummaryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockSummaryItemCopyWith<_StockSummaryItem> get copyWith => __$StockSummaryItemCopyWithImpl<_StockSummaryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockSummaryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockSummaryItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.counterName, counterName) || other.counterName == counterName)&&(identical(other.openingStock, openingStock) || other.openingStock == openingStock)&&(identical(other.inQuantity, inQuantity) || other.inQuantity == inQuantity)&&(identical(other.outQuantity, outQuantity) || other.outQuantity == outQuantity)&&(identical(other.wastageQuantity, wastageQuantity) || other.wastageQuantity == wastageQuantity)&&(identical(other.adjustmentQuantity, adjustmentQuantity) || other.adjustmentQuantity == adjustmentQuantity)&&(identical(other.closingStock, closingStock) || other.closingStock == closingStock));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productName,categoryName,counterName,openingStock,inQuantity,outQuantity,wastageQuantity,adjustmentQuantity,closingStock);

@override
String toString() {
  return 'StockSummaryItem(productId: $productId, productName: $productName, categoryName: $categoryName, counterName: $counterName, openingStock: $openingStock, inQuantity: $inQuantity, outQuantity: $outQuantity, wastageQuantity: $wastageQuantity, adjustmentQuantity: $adjustmentQuantity, closingStock: $closingStock)';
}


}

/// @nodoc
abstract mixin class _$StockSummaryItemCopyWith<$Res> implements $StockSummaryItemCopyWith<$Res> {
  factory _$StockSummaryItemCopyWith(_StockSummaryItem value, $Res Function(_StockSummaryItem) _then) = __$StockSummaryItemCopyWithImpl;
@override @useResult
$Res call({
 String productId, String productName, String categoryName, String counterName, int openingStock, int inQuantity, int outQuantity, int wastageQuantity, int adjustmentQuantity, int closingStock
});




}
/// @nodoc
class __$StockSummaryItemCopyWithImpl<$Res>
    implements _$StockSummaryItemCopyWith<$Res> {
  __$StockSummaryItemCopyWithImpl(this._self, this._then);

  final _StockSummaryItem _self;
  final $Res Function(_StockSummaryItem) _then;

/// Create a copy of StockSummaryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? categoryName = null,Object? counterName = null,Object? openingStock = null,Object? inQuantity = null,Object? outQuantity = null,Object? wastageQuantity = null,Object? adjustmentQuantity = null,Object? closingStock = null,}) {
  return _then(_StockSummaryItem(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,counterName: null == counterName ? _self.counterName : counterName // ignore: cast_nullable_to_non_nullable
as String,openingStock: null == openingStock ? _self.openingStock : openingStock // ignore: cast_nullable_to_non_nullable
as int,inQuantity: null == inQuantity ? _self.inQuantity : inQuantity // ignore: cast_nullable_to_non_nullable
as int,outQuantity: null == outQuantity ? _self.outQuantity : outQuantity // ignore: cast_nullable_to_non_nullable
as int,wastageQuantity: null == wastageQuantity ? _self.wastageQuantity : wastageQuantity // ignore: cast_nullable_to_non_nullable
as int,adjustmentQuantity: null == adjustmentQuantity ? _self.adjustmentQuantity : adjustmentQuantity // ignore: cast_nullable_to_non_nullable
as int,closingStock: null == closingStock ? _self.closingStock : closingStock // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
