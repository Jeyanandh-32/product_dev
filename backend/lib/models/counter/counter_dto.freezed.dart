// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'counter_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CounterDto {

 String get id; String get name; String get merchantId; String get storeId; bool get isActive;@JsonKey(fromJson: _fromJson) DateTime get createdAt;@JsonKey(fromJson: _fromJson) DateTime get updatedAt;
/// Create a copy of CounterDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CounterDtoCopyWith<CounterDto> get copyWith => _$CounterDtoCopyWithImpl<CounterDto>(this as CounterDto, _$identity);

  /// Serializes this CounterDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CounterDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,merchantId,storeId,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'CounterDto(id: $id, name: $name, merchantId: $merchantId, storeId: $storeId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CounterDtoCopyWith<$Res>  {
  factory $CounterDtoCopyWith(CounterDto value, $Res Function(CounterDto) _then) = _$CounterDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String merchantId, String storeId, bool isActive,@JsonKey(fromJson: _fromJson) DateTime createdAt,@JsonKey(fromJson: _fromJson) DateTime updatedAt
});




}
/// @nodoc
class _$CounterDtoCopyWithImpl<$Res>
    implements $CounterDtoCopyWith<$Res> {
  _$CounterDtoCopyWithImpl(this._self, this._then);

  final CounterDto _self;
  final $Res Function(CounterDto) _then;

/// Create a copy of CounterDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? merchantId = null,Object? storeId = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CounterDto].
extension CounterDtoPatterns on CounterDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CounterDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CounterDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CounterDto value)  $default,){
final _that = this;
switch (_that) {
case _CounterDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CounterDto value)?  $default,){
final _that = this;
switch (_that) {
case _CounterDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String merchantId,  String storeId,  bool isActive, @JsonKey(fromJson: _fromJson)  DateTime createdAt, @JsonKey(fromJson: _fromJson)  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CounterDto() when $default != null:
return $default(_that.id,_that.name,_that.merchantId,_that.storeId,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String merchantId,  String storeId,  bool isActive, @JsonKey(fromJson: _fromJson)  DateTime createdAt, @JsonKey(fromJson: _fromJson)  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CounterDto():
return $default(_that.id,_that.name,_that.merchantId,_that.storeId,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String merchantId,  String storeId,  bool isActive, @JsonKey(fromJson: _fromJson)  DateTime createdAt, @JsonKey(fromJson: _fromJson)  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CounterDto() when $default != null:
return $default(_that.id,_that.name,_that.merchantId,_that.storeId,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: .snake)
class _CounterDto implements CounterDto {
  const _CounterDto({required this.id, required this.name, required this.merchantId, required this.storeId, required this.isActive, @JsonKey(fromJson: _fromJson) required this.createdAt, @JsonKey(fromJson: _fromJson) required this.updatedAt});
  factory _CounterDto.fromJson(Map<String, dynamic> json) => _$CounterDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String merchantId;
@override final  String storeId;
@override final  bool isActive;
@override@JsonKey(fromJson: _fromJson) final  DateTime createdAt;
@override@JsonKey(fromJson: _fromJson) final  DateTime updatedAt;

/// Create a copy of CounterDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CounterDtoCopyWith<_CounterDto> get copyWith => __$CounterDtoCopyWithImpl<_CounterDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CounterDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CounterDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,merchantId,storeId,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'CounterDto(id: $id, name: $name, merchantId: $merchantId, storeId: $storeId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CounterDtoCopyWith<$Res> implements $CounterDtoCopyWith<$Res> {
  factory _$CounterDtoCopyWith(_CounterDto value, $Res Function(_CounterDto) _then) = __$CounterDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String merchantId, String storeId, bool isActive,@JsonKey(fromJson: _fromJson) DateTime createdAt,@JsonKey(fromJson: _fromJson) DateTime updatedAt
});




}
/// @nodoc
class __$CounterDtoCopyWithImpl<$Res>
    implements _$CounterDtoCopyWith<$Res> {
  __$CounterDtoCopyWithImpl(this._self, this._then);

  final _CounterDto _self;
  final $Res Function(_CounterDto) _then;

/// Create a copy of CounterDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? merchantId = null,Object? storeId = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_CounterDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
