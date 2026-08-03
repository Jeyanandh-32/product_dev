// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profit_loss_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfitLossItem {

 String get productId; String get productName; String get categoryName; String get counterName; int get soldQuantity; double get costPrice; double get collectedPrice; double get profit; double get profitLossPercentage;
/// Create a copy of ProfitLossItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfitLossItemCopyWith<ProfitLossItem> get copyWith => _$ProfitLossItemCopyWithImpl<ProfitLossItem>(this as ProfitLossItem, _$identity);

  /// Serializes this ProfitLossItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfitLossItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.counterName, counterName) || other.counterName == counterName)&&(identical(other.soldQuantity, soldQuantity) || other.soldQuantity == soldQuantity)&&(identical(other.costPrice, costPrice) || other.costPrice == costPrice)&&(identical(other.collectedPrice, collectedPrice) || other.collectedPrice == collectedPrice)&&(identical(other.profit, profit) || other.profit == profit)&&(identical(other.profitLossPercentage, profitLossPercentage) || other.profitLossPercentage == profitLossPercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productName,categoryName,counterName,soldQuantity,costPrice,collectedPrice,profit,profitLossPercentage);

@override
String toString() {
  return 'ProfitLossItem(productId: $productId, productName: $productName, categoryName: $categoryName, counterName: $counterName, soldQuantity: $soldQuantity, costPrice: $costPrice, collectedPrice: $collectedPrice, profit: $profit, profitLossPercentage: $profitLossPercentage)';
}


}

/// @nodoc
abstract mixin class $ProfitLossItemCopyWith<$Res>  {
  factory $ProfitLossItemCopyWith(ProfitLossItem value, $Res Function(ProfitLossItem) _then) = _$ProfitLossItemCopyWithImpl;
@useResult
$Res call({
 String productId, String productName, String categoryName, String counterName, int soldQuantity, double costPrice, double collectedPrice, double profit, double profitLossPercentage
});




}
/// @nodoc
class _$ProfitLossItemCopyWithImpl<$Res>
    implements $ProfitLossItemCopyWith<$Res> {
  _$ProfitLossItemCopyWithImpl(this._self, this._then);

  final ProfitLossItem _self;
  final $Res Function(ProfitLossItem) _then;

/// Create a copy of ProfitLossItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? categoryName = null,Object? counterName = null,Object? soldQuantity = null,Object? costPrice = null,Object? collectedPrice = null,Object? profit = null,Object? profitLossPercentage = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,counterName: null == counterName ? _self.counterName : counterName // ignore: cast_nullable_to_non_nullable
as String,soldQuantity: null == soldQuantity ? _self.soldQuantity : soldQuantity // ignore: cast_nullable_to_non_nullable
as int,costPrice: null == costPrice ? _self.costPrice : costPrice // ignore: cast_nullable_to_non_nullable
as double,collectedPrice: null == collectedPrice ? _self.collectedPrice : collectedPrice // ignore: cast_nullable_to_non_nullable
as double,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double,profitLossPercentage: null == profitLossPercentage ? _self.profitLossPercentage : profitLossPercentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfitLossItem].
extension ProfitLossItemPatterns on ProfitLossItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfitLossItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfitLossItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfitLossItem value)  $default,){
final _that = this;
switch (_that) {
case _ProfitLossItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfitLossItem value)?  $default,){
final _that = this;
switch (_that) {
case _ProfitLossItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String productName,  String categoryName,  String counterName,  int soldQuantity,  double costPrice,  double collectedPrice,  double profit,  double profitLossPercentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfitLossItem() when $default != null:
return $default(_that.productId,_that.productName,_that.categoryName,_that.counterName,_that.soldQuantity,_that.costPrice,_that.collectedPrice,_that.profit,_that.profitLossPercentage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String productName,  String categoryName,  String counterName,  int soldQuantity,  double costPrice,  double collectedPrice,  double profit,  double profitLossPercentage)  $default,) {final _that = this;
switch (_that) {
case _ProfitLossItem():
return $default(_that.productId,_that.productName,_that.categoryName,_that.counterName,_that.soldQuantity,_that.costPrice,_that.collectedPrice,_that.profit,_that.profitLossPercentage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String productName,  String categoryName,  String counterName,  int soldQuantity,  double costPrice,  double collectedPrice,  double profit,  double profitLossPercentage)?  $default,) {final _that = this;
switch (_that) {
case _ProfitLossItem() when $default != null:
return $default(_that.productId,_that.productName,_that.categoryName,_that.counterName,_that.soldQuantity,_that.costPrice,_that.collectedPrice,_that.profit,_that.profitLossPercentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfitLossItem implements ProfitLossItem {
  const _ProfitLossItem({required this.productId, required this.productName, required this.categoryName, required this.counterName, required this.soldQuantity, required this.costPrice, required this.collectedPrice, required this.profit, required this.profitLossPercentage});
  factory _ProfitLossItem.fromJson(Map<String, dynamic> json) => _$ProfitLossItemFromJson(json);

@override final  String productId;
@override final  String productName;
@override final  String categoryName;
@override final  String counterName;
@override final  int soldQuantity;
@override final  double costPrice;
@override final  double collectedPrice;
@override final  double profit;
@override final  double profitLossPercentage;

/// Create a copy of ProfitLossItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfitLossItemCopyWith<_ProfitLossItem> get copyWith => __$ProfitLossItemCopyWithImpl<_ProfitLossItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfitLossItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfitLossItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.counterName, counterName) || other.counterName == counterName)&&(identical(other.soldQuantity, soldQuantity) || other.soldQuantity == soldQuantity)&&(identical(other.costPrice, costPrice) || other.costPrice == costPrice)&&(identical(other.collectedPrice, collectedPrice) || other.collectedPrice == collectedPrice)&&(identical(other.profit, profit) || other.profit == profit)&&(identical(other.profitLossPercentage, profitLossPercentage) || other.profitLossPercentage == profitLossPercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productName,categoryName,counterName,soldQuantity,costPrice,collectedPrice,profit,profitLossPercentage);

@override
String toString() {
  return 'ProfitLossItem(productId: $productId, productName: $productName, categoryName: $categoryName, counterName: $counterName, soldQuantity: $soldQuantity, costPrice: $costPrice, collectedPrice: $collectedPrice, profit: $profit, profitLossPercentage: $profitLossPercentage)';
}


}

/// @nodoc
abstract mixin class _$ProfitLossItemCopyWith<$Res> implements $ProfitLossItemCopyWith<$Res> {
  factory _$ProfitLossItemCopyWith(_ProfitLossItem value, $Res Function(_ProfitLossItem) _then) = __$ProfitLossItemCopyWithImpl;
@override @useResult
$Res call({
 String productId, String productName, String categoryName, String counterName, int soldQuantity, double costPrice, double collectedPrice, double profit, double profitLossPercentage
});




}
/// @nodoc
class __$ProfitLossItemCopyWithImpl<$Res>
    implements _$ProfitLossItemCopyWith<$Res> {
  __$ProfitLossItemCopyWithImpl(this._self, this._then);

  final _ProfitLossItem _self;
  final $Res Function(_ProfitLossItem) _then;

/// Create a copy of ProfitLossItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? categoryName = null,Object? counterName = null,Object? soldQuantity = null,Object? costPrice = null,Object? collectedPrice = null,Object? profit = null,Object? profitLossPercentage = null,}) {
  return _then(_ProfitLossItem(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,counterName: null == counterName ? _self.counterName : counterName // ignore: cast_nullable_to_non_nullable
as String,soldQuantity: null == soldQuantity ? _self.soldQuantity : soldQuantity // ignore: cast_nullable_to_non_nullable
as int,costPrice: null == costPrice ? _self.costPrice : costPrice // ignore: cast_nullable_to_non_nullable
as double,collectedPrice: null == collectedPrice ? _self.collectedPrice : collectedPrice // ignore: cast_nullable_to_non_nullable
as double,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double,profitLossPercentage: null == profitLossPercentage ? _self.profitLossPercentage : profitLossPercentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
