// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bottle_return_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BottleReturnConfig {

 String get storeId; bool get isEnabled; int get rewardAmountInRupees; String? get iotApiKey; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of BottleReturnConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BottleReturnConfigCopyWith<BottleReturnConfig> get copyWith => _$BottleReturnConfigCopyWithImpl<BottleReturnConfig>(this as BottleReturnConfig, _$identity);

  /// Serializes this BottleReturnConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BottleReturnConfig&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.rewardAmountInRupees, rewardAmountInRupees) || other.rewardAmountInRupees == rewardAmountInRupees)&&(identical(other.iotApiKey, iotApiKey) || other.iotApiKey == iotApiKey)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storeId,isEnabled,rewardAmountInRupees,iotApiKey,createdAt,updatedAt);

@override
String toString() {
  return 'BottleReturnConfig(storeId: $storeId, isEnabled: $isEnabled, rewardAmountInRupees: $rewardAmountInRupees, iotApiKey: $iotApiKey, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $BottleReturnConfigCopyWith<$Res>  {
  factory $BottleReturnConfigCopyWith(BottleReturnConfig value, $Res Function(BottleReturnConfig) _then) = _$BottleReturnConfigCopyWithImpl;
@useResult
$Res call({
 String storeId, bool isEnabled, int rewardAmountInRupees, String? iotApiKey, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$BottleReturnConfigCopyWithImpl<$Res>
    implements $BottleReturnConfigCopyWith<$Res> {
  _$BottleReturnConfigCopyWithImpl(this._self, this._then);

  final BottleReturnConfig _self;
  final $Res Function(BottleReturnConfig) _then;

/// Create a copy of BottleReturnConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeId = null,Object? isEnabled = null,Object? rewardAmountInRupees = null,Object? iotApiKey = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,rewardAmountInRupees: null == rewardAmountInRupees ? _self.rewardAmountInRupees : rewardAmountInRupees // ignore: cast_nullable_to_non_nullable
as int,iotApiKey: freezed == iotApiKey ? _self.iotApiKey : iotApiKey // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BottleReturnConfig].
extension BottleReturnConfigPatterns on BottleReturnConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BottleReturnConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BottleReturnConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BottleReturnConfig value)  $default,){
final _that = this;
switch (_that) {
case _BottleReturnConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BottleReturnConfig value)?  $default,){
final _that = this;
switch (_that) {
case _BottleReturnConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String storeId,  bool isEnabled,  int rewardAmountInRupees,  String? iotApiKey,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BottleReturnConfig() when $default != null:
return $default(_that.storeId,_that.isEnabled,_that.rewardAmountInRupees,_that.iotApiKey,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String storeId,  bool isEnabled,  int rewardAmountInRupees,  String? iotApiKey,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _BottleReturnConfig():
return $default(_that.storeId,_that.isEnabled,_that.rewardAmountInRupees,_that.iotApiKey,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String storeId,  bool isEnabled,  int rewardAmountInRupees,  String? iotApiKey,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _BottleReturnConfig() when $default != null:
return $default(_that.storeId,_that.isEnabled,_that.rewardAmountInRupees,_that.iotApiKey,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BottleReturnConfig implements BottleReturnConfig {
  const _BottleReturnConfig({required this.storeId, this.isEnabled = true, this.rewardAmountInRupees = 10, this.iotApiKey, this.createdAt, this.updatedAt});
  factory _BottleReturnConfig.fromJson(Map<String, dynamic> json) => _$BottleReturnConfigFromJson(json);

@override final  String storeId;
@override@JsonKey() final  bool isEnabled;
@override@JsonKey() final  int rewardAmountInRupees;
@override final  String? iotApiKey;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of BottleReturnConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BottleReturnConfigCopyWith<_BottleReturnConfig> get copyWith => __$BottleReturnConfigCopyWithImpl<_BottleReturnConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BottleReturnConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BottleReturnConfig&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.rewardAmountInRupees, rewardAmountInRupees) || other.rewardAmountInRupees == rewardAmountInRupees)&&(identical(other.iotApiKey, iotApiKey) || other.iotApiKey == iotApiKey)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storeId,isEnabled,rewardAmountInRupees,iotApiKey,createdAt,updatedAt);

@override
String toString() {
  return 'BottleReturnConfig(storeId: $storeId, isEnabled: $isEnabled, rewardAmountInRupees: $rewardAmountInRupees, iotApiKey: $iotApiKey, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BottleReturnConfigCopyWith<$Res> implements $BottleReturnConfigCopyWith<$Res> {
  factory _$BottleReturnConfigCopyWith(_BottleReturnConfig value, $Res Function(_BottleReturnConfig) _then) = __$BottleReturnConfigCopyWithImpl;
@override @useResult
$Res call({
 String storeId, bool isEnabled, int rewardAmountInRupees, String? iotApiKey, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$BottleReturnConfigCopyWithImpl<$Res>
    implements _$BottleReturnConfigCopyWith<$Res> {
  __$BottleReturnConfigCopyWithImpl(this._self, this._then);

  final _BottleReturnConfig _self;
  final $Res Function(_BottleReturnConfig) _then;

/// Create a copy of BottleReturnConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeId = null,Object? isEnabled = null,Object? rewardAmountInRupees = null,Object? iotApiKey = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_BottleReturnConfig(
storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,rewardAmountInRupees: null == rewardAmountInRupees ? _self.rewardAmountInRupees : rewardAmountInRupees // ignore: cast_nullable_to_non_nullable
as int,iotApiKey: freezed == iotApiKey ? _self.iotApiKey : iotApiKey // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
