// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 String get id; String get merchantId; String get name; double get taxRate; double get basePrice; double get sellingPrice; bool get isActive; DateTime get createdAt; DateTime get updatedAt; String? get sku; String? get barcode; String? get description; String? get imageUrl; Stock? get stock; Category? get category; Counter? get counter;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.name, name) || other.name == name)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.category, category) || other.category == category)&&(identical(other.counter, counter) || other.counter == counter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,merchantId,name,taxRate,basePrice,sellingPrice,isActive,createdAt,updatedAt,sku,barcode,description,imageUrl,stock,category,counter);

@override
String toString() {
  return 'Product(id: $id, merchantId: $merchantId, name: $name, taxRate: $taxRate, basePrice: $basePrice, sellingPrice: $sellingPrice, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, sku: $sku, barcode: $barcode, description: $description, imageUrl: $imageUrl, stock: $stock, category: $category, counter: $counter)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String merchantId, String name, double taxRate, double basePrice, double sellingPrice, bool isActive, DateTime createdAt, DateTime updatedAt, String? sku, String? barcode, String? description, String? imageUrl, Stock? stock, Category? category, Counter? counter
});


$StockCopyWith<$Res>? get stock;$CategoryCopyWith<$Res>? get category;$CounterCopyWith<$Res>? get counter;

}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? merchantId = null,Object? name = null,Object? taxRate = null,Object? basePrice = null,Object? sellingPrice = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,Object? sku = freezed,Object? barcode = freezed,Object? description = freezed,Object? imageUrl = freezed,Object? stock = freezed,Object? category = freezed,Object? counter = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as double,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as Stock?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category?,counter: freezed == counter ? _self.counter : counter // ignore: cast_nullable_to_non_nullable
as Counter?,
  ));
}
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockCopyWith<$Res>? get stock {
    if (_self.stock == null) {
    return null;
  }

  return $StockCopyWith<$Res>(_self.stock!, (value) {
    return _then(_self.copyWith(stock: value));
  });
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CounterCopyWith<$Res>? get counter {
    if (_self.counter == null) {
    return null;
  }

  return $CounterCopyWith<$Res>(_self.counter!, (value) {
    return _then(_self.copyWith(counter: value));
  });
}
}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String merchantId,  String name,  double taxRate,  double basePrice,  double sellingPrice,  bool isActive,  DateTime createdAt,  DateTime updatedAt,  String? sku,  String? barcode,  String? description,  String? imageUrl,  Stock? stock,  Category? category,  Counter? counter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.merchantId,_that.name,_that.taxRate,_that.basePrice,_that.sellingPrice,_that.isActive,_that.createdAt,_that.updatedAt,_that.sku,_that.barcode,_that.description,_that.imageUrl,_that.stock,_that.category,_that.counter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String merchantId,  String name,  double taxRate,  double basePrice,  double sellingPrice,  bool isActive,  DateTime createdAt,  DateTime updatedAt,  String? sku,  String? barcode,  String? description,  String? imageUrl,  Stock? stock,  Category? category,  Counter? counter)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.merchantId,_that.name,_that.taxRate,_that.basePrice,_that.sellingPrice,_that.isActive,_that.createdAt,_that.updatedAt,_that.sku,_that.barcode,_that.description,_that.imageUrl,_that.stock,_that.category,_that.counter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String merchantId,  String name,  double taxRate,  double basePrice,  double sellingPrice,  bool isActive,  DateTime createdAt,  DateTime updatedAt,  String? sku,  String? barcode,  String? description,  String? imageUrl,  Stock? stock,  Category? category,  Counter? counter)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.merchantId,_that.name,_that.taxRate,_that.basePrice,_that.sellingPrice,_that.isActive,_that.createdAt,_that.updatedAt,_that.sku,_that.barcode,_that.description,_that.imageUrl,_that.stock,_that.category,_that.counter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product implements Product {
  const _Product({required this.id, required this.merchantId, required this.name, required this.taxRate, required this.basePrice, required this.sellingPrice, required this.isActive, required this.createdAt, required this.updatedAt, this.sku, this.barcode, this.description, this.imageUrl, this.stock, this.category, this.counter});
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  String id;
@override final  String merchantId;
@override final  String name;
@override final  double taxRate;
@override final  double basePrice;
@override final  double sellingPrice;
@override final  bool isActive;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? sku;
@override final  String? barcode;
@override final  String? description;
@override final  String? imageUrl;
@override final  Stock? stock;
@override final  Category? category;
@override final  Counter? counter;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.name, name) || other.name == name)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.category, category) || other.category == category)&&(identical(other.counter, counter) || other.counter == counter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,merchantId,name,taxRate,basePrice,sellingPrice,isActive,createdAt,updatedAt,sku,barcode,description,imageUrl,stock,category,counter);

@override
String toString() {
  return 'Product(id: $id, merchantId: $merchantId, name: $name, taxRate: $taxRate, basePrice: $basePrice, sellingPrice: $sellingPrice, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, sku: $sku, barcode: $barcode, description: $description, imageUrl: $imageUrl, stock: $stock, category: $category, counter: $counter)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String merchantId, String name, double taxRate, double basePrice, double sellingPrice, bool isActive, DateTime createdAt, DateTime updatedAt, String? sku, String? barcode, String? description, String? imageUrl, Stock? stock, Category? category, Counter? counter
});


@override $StockCopyWith<$Res>? get stock;@override $CategoryCopyWith<$Res>? get category;@override $CounterCopyWith<$Res>? get counter;

}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? merchantId = null,Object? name = null,Object? taxRate = null,Object? basePrice = null,Object? sellingPrice = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,Object? sku = freezed,Object? barcode = freezed,Object? description = freezed,Object? imageUrl = freezed,Object? stock = freezed,Object? category = freezed,Object? counter = freezed,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as double,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as Stock?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category?,counter: freezed == counter ? _self.counter : counter // ignore: cast_nullable_to_non_nullable
as Counter?,
  ));
}

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockCopyWith<$Res>? get stock {
    if (_self.stock == null) {
    return null;
  }

  return $StockCopyWith<$Res>(_self.stock!, (value) {
    return _then(_self.copyWith(stock: value));
  });
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CounterCopyWith<$Res>? get counter {
    if (_self.counter == null) {
    return null;
  }

  return $CounterCopyWith<$Res>(_self.counter!, (value) {
    return _then(_self.copyWith(counter: value));
  });
}
}

// dart format on
