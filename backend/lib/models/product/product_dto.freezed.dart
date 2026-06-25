// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductDto {

 String get id; String get merchantId; String get name;@JsonKey(fromJson: doubleFromJson) double get taxRate; int get basePrice; int get sellingPrice; bool get isActive;@JsonKey(fromJson: dateTimeFromJson) DateTime get createdAt;@JsonKey(fromJson: dateTimeFromJson) DateTime get updatedAt; String? get sku; String? get barcode; String? get description; String? get imageUrl; StockDto? get stock; CategoryDto? get category; CounterDto? get counter;
/// Create a copy of ProductDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDtoCopyWith<ProductDto> get copyWith => _$ProductDtoCopyWithImpl<ProductDto>(this as ProductDto, _$identity);

  /// Serializes this ProductDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDto&&(identical(other.id, id) || other.id == id)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.name, name) || other.name == name)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.category, category) || other.category == category)&&(identical(other.counter, counter) || other.counter == counter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,merchantId,name,taxRate,basePrice,sellingPrice,isActive,createdAt,updatedAt,sku,barcode,description,imageUrl,stock,category,counter);

@override
String toString() {
  return 'ProductDto(id: $id, merchantId: $merchantId, name: $name, taxRate: $taxRate, basePrice: $basePrice, sellingPrice: $sellingPrice, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, sku: $sku, barcode: $barcode, description: $description, imageUrl: $imageUrl, stock: $stock, category: $category, counter: $counter)';
}


}

/// @nodoc
abstract mixin class $ProductDtoCopyWith<$Res>  {
  factory $ProductDtoCopyWith(ProductDto value, $Res Function(ProductDto) _then) = _$ProductDtoCopyWithImpl;
@useResult
$Res call({
 String id, String merchantId, String name,@JsonKey(fromJson: doubleFromJson) double taxRate, int basePrice, int sellingPrice, bool isActive,@JsonKey(fromJson: dateTimeFromJson) DateTime createdAt,@JsonKey(fromJson: dateTimeFromJson) DateTime updatedAt, String? sku, String? barcode, String? description, String? imageUrl, StockDto? stock, CategoryDto? category, CounterDto? counter
});


$StockDtoCopyWith<$Res>? get stock;$CategoryDtoCopyWith<$Res>? get category;$CounterDtoCopyWith<$Res>? get counter;

}
/// @nodoc
class _$ProductDtoCopyWithImpl<$Res>
    implements $ProductDtoCopyWith<$Res> {
  _$ProductDtoCopyWithImpl(this._self, this._then);

  final ProductDto _self;
  final $Res Function(ProductDto) _then;

/// Create a copy of ProductDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? merchantId = null,Object? name = null,Object? taxRate = null,Object? basePrice = null,Object? sellingPrice = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,Object? sku = freezed,Object? barcode = freezed,Object? description = freezed,Object? imageUrl = freezed,Object? stock = freezed,Object? category = freezed,Object? counter = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as int,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as StockDto?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryDto?,counter: freezed == counter ? _self.counter : counter // ignore: cast_nullable_to_non_nullable
as CounterDto?,
  ));
}
/// Create a copy of ProductDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockDtoCopyWith<$Res>? get stock {
    if (_self.stock == null) {
    return null;
  }

  return $StockDtoCopyWith<$Res>(_self.stock!, (value) {
    return _then(_self.copyWith(stock: value));
  });
}/// Create a copy of ProductDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryDtoCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryDtoCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of ProductDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CounterDtoCopyWith<$Res>? get counter {
    if (_self.counter == null) {
    return null;
  }

  return $CounterDtoCopyWith<$Res>(_self.counter!, (value) {
    return _then(_self.copyWith(counter: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductDto].
extension ProductDtoPatterns on ProductDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductDto value)  $default,){
final _that = this;
switch (_that) {
case _ProductDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProductDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String merchantId,  String name, @JsonKey(fromJson: doubleFromJson)  double taxRate,  int basePrice,  int sellingPrice,  bool isActive, @JsonKey(fromJson: dateTimeFromJson)  DateTime createdAt, @JsonKey(fromJson: dateTimeFromJson)  DateTime updatedAt,  String? sku,  String? barcode,  String? description,  String? imageUrl,  StockDto? stock,  CategoryDto? category,  CounterDto? counter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String merchantId,  String name, @JsonKey(fromJson: doubleFromJson)  double taxRate,  int basePrice,  int sellingPrice,  bool isActive, @JsonKey(fromJson: dateTimeFromJson)  DateTime createdAt, @JsonKey(fromJson: dateTimeFromJson)  DateTime updatedAt,  String? sku,  String? barcode,  String? description,  String? imageUrl,  StockDto? stock,  CategoryDto? category,  CounterDto? counter)  $default,) {final _that = this;
switch (_that) {
case _ProductDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String merchantId,  String name, @JsonKey(fromJson: doubleFromJson)  double taxRate,  int basePrice,  int sellingPrice,  bool isActive, @JsonKey(fromJson: dateTimeFromJson)  DateTime createdAt, @JsonKey(fromJson: dateTimeFromJson)  DateTime updatedAt,  String? sku,  String? barcode,  String? description,  String? imageUrl,  StockDto? stock,  CategoryDto? category,  CounterDto? counter)?  $default,) {final _that = this;
switch (_that) {
case _ProductDto() when $default != null:
return $default(_that.id,_that.merchantId,_that.name,_that.taxRate,_that.basePrice,_that.sellingPrice,_that.isActive,_that.createdAt,_that.updatedAt,_that.sku,_that.barcode,_that.description,_that.imageUrl,_that.stock,_that.category,_that.counter);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: .snake)
class _ProductDto implements ProductDto {
  const _ProductDto({required this.id, required this.merchantId, required this.name, @JsonKey(fromJson: doubleFromJson) required this.taxRate, required this.basePrice, required this.sellingPrice, required this.isActive, @JsonKey(fromJson: dateTimeFromJson) required this.createdAt, @JsonKey(fromJson: dateTimeFromJson) required this.updatedAt, this.sku, this.barcode, this.description, this.imageUrl, this.stock, this.category, this.counter});
  factory _ProductDto.fromJson(Map<String, dynamic> json) => _$ProductDtoFromJson(json);

@override final  String id;
@override final  String merchantId;
@override final  String name;
@override@JsonKey(fromJson: doubleFromJson) final  double taxRate;
@override final  int basePrice;
@override final  int sellingPrice;
@override final  bool isActive;
@override@JsonKey(fromJson: dateTimeFromJson) final  DateTime createdAt;
@override@JsonKey(fromJson: dateTimeFromJson) final  DateTime updatedAt;
@override final  String? sku;
@override final  String? barcode;
@override final  String? description;
@override final  String? imageUrl;
@override final  StockDto? stock;
@override final  CategoryDto? category;
@override final  CounterDto? counter;

/// Create a copy of ProductDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductDtoCopyWith<_ProductDto> get copyWith => __$ProductDtoCopyWithImpl<_ProductDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductDto&&(identical(other.id, id) || other.id == id)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.name, name) || other.name == name)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.category, category) || other.category == category)&&(identical(other.counter, counter) || other.counter == counter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,merchantId,name,taxRate,basePrice,sellingPrice,isActive,createdAt,updatedAt,sku,barcode,description,imageUrl,stock,category,counter);

@override
String toString() {
  return 'ProductDto(id: $id, merchantId: $merchantId, name: $name, taxRate: $taxRate, basePrice: $basePrice, sellingPrice: $sellingPrice, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, sku: $sku, barcode: $barcode, description: $description, imageUrl: $imageUrl, stock: $stock, category: $category, counter: $counter)';
}


}

/// @nodoc
abstract mixin class _$ProductDtoCopyWith<$Res> implements $ProductDtoCopyWith<$Res> {
  factory _$ProductDtoCopyWith(_ProductDto value, $Res Function(_ProductDto) _then) = __$ProductDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String merchantId, String name,@JsonKey(fromJson: doubleFromJson) double taxRate, int basePrice, int sellingPrice, bool isActive,@JsonKey(fromJson: dateTimeFromJson) DateTime createdAt,@JsonKey(fromJson: dateTimeFromJson) DateTime updatedAt, String? sku, String? barcode, String? description, String? imageUrl, StockDto? stock, CategoryDto? category, CounterDto? counter
});


@override $StockDtoCopyWith<$Res>? get stock;@override $CategoryDtoCopyWith<$Res>? get category;@override $CounterDtoCopyWith<$Res>? get counter;

}
/// @nodoc
class __$ProductDtoCopyWithImpl<$Res>
    implements _$ProductDtoCopyWith<$Res> {
  __$ProductDtoCopyWithImpl(this._self, this._then);

  final _ProductDto _self;
  final $Res Function(_ProductDto) _then;

/// Create a copy of ProductDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? merchantId = null,Object? name = null,Object? taxRate = null,Object? basePrice = null,Object? sellingPrice = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,Object? sku = freezed,Object? barcode = freezed,Object? description = freezed,Object? imageUrl = freezed,Object? stock = freezed,Object? category = freezed,Object? counter = freezed,}) {
  return _then(_ProductDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as int,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as StockDto?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryDto?,counter: freezed == counter ? _self.counter : counter // ignore: cast_nullable_to_non_nullable
as CounterDto?,
  ));
}

/// Create a copy of ProductDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockDtoCopyWith<$Res>? get stock {
    if (_self.stock == null) {
    return null;
  }

  return $StockDtoCopyWith<$Res>(_self.stock!, (value) {
    return _then(_self.copyWith(stock: value));
  });
}/// Create a copy of ProductDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryDtoCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryDtoCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of ProductDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CounterDtoCopyWith<$Res>? get counter {
    if (_self.counter == null) {
    return null;
  }

  return $CounterDtoCopyWith<$Res>(_self.counter!, (value) {
    return _then(_self.copyWith(counter: value));
  });
}
}

// dart format on
