// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'terminal_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TerminalDto {

 String get code; String get merchantId; String get storeId; String get name; String get passwordHash; bool get isActive;@JsonKey(fromJson: dateTimeFromJson) DateTime get createdAt;@JsonKey(fromJson: dateTimeFromJson) DateTime get updatedAt;
/// Create a copy of TerminalDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TerminalDtoCopyWith<TerminalDto> get copyWith => _$TerminalDtoCopyWithImpl<TerminalDto>(this as TerminalDto, _$identity);

  /// Serializes this TerminalDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TerminalDto&&(identical(other.code, code) || other.code == code)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.passwordHash, passwordHash) || other.passwordHash == passwordHash)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,merchantId,storeId,name,passwordHash,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'TerminalDto(code: $code, merchantId: $merchantId, storeId: $storeId, name: $name, passwordHash: $passwordHash, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TerminalDtoCopyWith<$Res>  {
  factory $TerminalDtoCopyWith(TerminalDto value, $Res Function(TerminalDto) _then) = _$TerminalDtoCopyWithImpl;
@useResult
$Res call({
 String code, String merchantId, String storeId, String name, String passwordHash, bool isActive,@JsonKey(fromJson: dateTimeFromJson) DateTime createdAt,@JsonKey(fromJson: dateTimeFromJson) DateTime updatedAt
});




}
/// @nodoc
class _$TerminalDtoCopyWithImpl<$Res>
    implements $TerminalDtoCopyWith<$Res> {
  _$TerminalDtoCopyWithImpl(this._self, this._then);

  final TerminalDto _self;
  final $Res Function(TerminalDto) _then;

/// Create a copy of TerminalDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? merchantId = null,Object? storeId = null,Object? name = null,Object? passwordHash = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,passwordHash: null == passwordHash ? _self.passwordHash : passwordHash // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TerminalDto].
extension TerminalDtoPatterns on TerminalDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TerminalDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TerminalDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TerminalDto value)  $default,){
final _that = this;
switch (_that) {
case _TerminalDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TerminalDto value)?  $default,){
final _that = this;
switch (_that) {
case _TerminalDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String merchantId,  String storeId,  String name,  String passwordHash,  bool isActive, @JsonKey(fromJson: dateTimeFromJson)  DateTime createdAt, @JsonKey(fromJson: dateTimeFromJson)  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TerminalDto() when $default != null:
return $default(_that.code,_that.merchantId,_that.storeId,_that.name,_that.passwordHash,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String merchantId,  String storeId,  String name,  String passwordHash,  bool isActive, @JsonKey(fromJson: dateTimeFromJson)  DateTime createdAt, @JsonKey(fromJson: dateTimeFromJson)  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TerminalDto():
return $default(_that.code,_that.merchantId,_that.storeId,_that.name,_that.passwordHash,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String merchantId,  String storeId,  String name,  String passwordHash,  bool isActive, @JsonKey(fromJson: dateTimeFromJson)  DateTime createdAt, @JsonKey(fromJson: dateTimeFromJson)  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TerminalDto() when $default != null:
return $default(_that.code,_that.merchantId,_that.storeId,_that.name,_that.passwordHash,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: .snake)
class _TerminalDto implements TerminalDto {
  const _TerminalDto({required this.code, required this.merchantId, required this.storeId, required this.name, required this.passwordHash, required this.isActive, @JsonKey(fromJson: dateTimeFromJson) required this.createdAt, @JsonKey(fromJson: dateTimeFromJson) required this.updatedAt});
  factory _TerminalDto.fromJson(Map<String, dynamic> json) => _$TerminalDtoFromJson(json);

@override final  String code;
@override final  String merchantId;
@override final  String storeId;
@override final  String name;
@override final  String passwordHash;
@override final  bool isActive;
@override@JsonKey(fromJson: dateTimeFromJson) final  DateTime createdAt;
@override@JsonKey(fromJson: dateTimeFromJson) final  DateTime updatedAt;

/// Create a copy of TerminalDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TerminalDtoCopyWith<_TerminalDto> get copyWith => __$TerminalDtoCopyWithImpl<_TerminalDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TerminalDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TerminalDto&&(identical(other.code, code) || other.code == code)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.passwordHash, passwordHash) || other.passwordHash == passwordHash)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,merchantId,storeId,name,passwordHash,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'TerminalDto(code: $code, merchantId: $merchantId, storeId: $storeId, name: $name, passwordHash: $passwordHash, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TerminalDtoCopyWith<$Res> implements $TerminalDtoCopyWith<$Res> {
  factory _$TerminalDtoCopyWith(_TerminalDto value, $Res Function(_TerminalDto) _then) = __$TerminalDtoCopyWithImpl;
@override @useResult
$Res call({
 String code, String merchantId, String storeId, String name, String passwordHash, bool isActive,@JsonKey(fromJson: dateTimeFromJson) DateTime createdAt,@JsonKey(fromJson: dateTimeFromJson) DateTime updatedAt
});




}
/// @nodoc
class __$TerminalDtoCopyWithImpl<$Res>
    implements _$TerminalDtoCopyWith<$Res> {
  __$TerminalDtoCopyWithImpl(this._self, this._then);

  final _TerminalDto _self;
  final $Res Function(_TerminalDto) _then;

/// Create a copy of TerminalDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? merchantId = null,Object? storeId = null,Object? name = null,Object? passwordHash = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_TerminalDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,passwordHash: null == passwordHash ? _self.passwordHash : passwordHash // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
