// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoreDto {

 String get id; String get merchantId; String get name;@JsonKey(fromJson: _fromJson) DateTime get createdAt;@JsonKey(fromJson: _fromJson) DateTime get updatedAt; bool get isActive; String? get storeType;
/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreDtoCopyWith<StoreDto> get copyWith => _$StoreDtoCopyWithImpl<StoreDto>(this as StoreDto, _$identity);

  /// Serializes this StoreDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreDto&&(identical(other.id, id) || other.id == id)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.storeType, storeType) || other.storeType == storeType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,merchantId,name,createdAt,updatedAt,isActive,storeType);

@override
String toString() {
  return 'StoreDto(id: $id, merchantId: $merchantId, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, storeType: $storeType)';
}


}

/// @nodoc
abstract mixin class $StoreDtoCopyWith<$Res>  {
  factory $StoreDtoCopyWith(StoreDto value, $Res Function(StoreDto) _then) = _$StoreDtoCopyWithImpl;
@useResult
$Res call({
 String id, String merchantId, String name,@JsonKey(fromJson: _fromJson) DateTime createdAt,@JsonKey(fromJson: _fromJson) DateTime updatedAt, bool isActive, String? storeType
});




}
/// @nodoc
class _$StoreDtoCopyWithImpl<$Res>
    implements $StoreDtoCopyWith<$Res> {
  _$StoreDtoCopyWithImpl(this._self, this._then);

  final StoreDto _self;
  final $Res Function(StoreDto) _then;

/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? merchantId = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,Object? isActive = null,Object? storeType = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,storeType: freezed == storeType ? _self.storeType : storeType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreDto].
extension StoreDtoPatterns on StoreDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreDto value)  $default,){
final _that = this;
switch (_that) {
case _StoreDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreDto value)?  $default,){
final _that = this;
switch (_that) {
case _StoreDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String merchantId,  String name, @JsonKey(fromJson: _fromJson)  DateTime createdAt, @JsonKey(fromJson: _fromJson)  DateTime updatedAt,  bool isActive,  String? storeType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreDto() when $default != null:
return $default(_that.id,_that.merchantId,_that.name,_that.createdAt,_that.updatedAt,_that.isActive,_that.storeType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String merchantId,  String name, @JsonKey(fromJson: _fromJson)  DateTime createdAt, @JsonKey(fromJson: _fromJson)  DateTime updatedAt,  bool isActive,  String? storeType)  $default,) {final _that = this;
switch (_that) {
case _StoreDto():
return $default(_that.id,_that.merchantId,_that.name,_that.createdAt,_that.updatedAt,_that.isActive,_that.storeType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String merchantId,  String name, @JsonKey(fromJson: _fromJson)  DateTime createdAt, @JsonKey(fromJson: _fromJson)  DateTime updatedAt,  bool isActive,  String? storeType)?  $default,) {final _that = this;
switch (_that) {
case _StoreDto() when $default != null:
return $default(_that.id,_that.merchantId,_that.name,_that.createdAt,_that.updatedAt,_that.isActive,_that.storeType);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: .snake)
class _StoreDto implements StoreDto {
  const _StoreDto({required this.id, required this.merchantId, required this.name, @JsonKey(fromJson: _fromJson) required this.createdAt, @JsonKey(fromJson: _fromJson) required this.updatedAt, required this.isActive, this.storeType});
  factory _StoreDto.fromJson(Map<String, dynamic> json) => _$StoreDtoFromJson(json);

@override final  String id;
@override final  String merchantId;
@override final  String name;
@override@JsonKey(fromJson: _fromJson) final  DateTime createdAt;
@override@JsonKey(fromJson: _fromJson) final  DateTime updatedAt;
@override final  bool isActive;
@override final  String? storeType;

/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreDtoCopyWith<_StoreDto> get copyWith => __$StoreDtoCopyWithImpl<_StoreDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreDto&&(identical(other.id, id) || other.id == id)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.storeType, storeType) || other.storeType == storeType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,merchantId,name,createdAt,updatedAt,isActive,storeType);

@override
String toString() {
  return 'StoreDto(id: $id, merchantId: $merchantId, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, storeType: $storeType)';
}


}

/// @nodoc
abstract mixin class _$StoreDtoCopyWith<$Res> implements $StoreDtoCopyWith<$Res> {
  factory _$StoreDtoCopyWith(_StoreDto value, $Res Function(_StoreDto) _then) = __$StoreDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String merchantId, String name,@JsonKey(fromJson: _fromJson) DateTime createdAt,@JsonKey(fromJson: _fromJson) DateTime updatedAt, bool isActive, String? storeType
});




}
/// @nodoc
class __$StoreDtoCopyWithImpl<$Res>
    implements _$StoreDtoCopyWith<$Res> {
  __$StoreDtoCopyWithImpl(this._self, this._then);

  final _StoreDto _self;
  final $Res Function(_StoreDto) _then;

/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? merchantId = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,Object? isActive = null,Object? storeType = freezed,}) {
  return _then(_StoreDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,storeType: freezed == storeType ? _self.storeType : storeType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
