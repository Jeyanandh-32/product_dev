// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merchant_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MerchantSettings {

 String get merchantId; bool get waNotifications; bool get lowStockAlerts; bool get dailyReports; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of MerchantSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MerchantSettingsCopyWith<MerchantSettings> get copyWith => _$MerchantSettingsCopyWithImpl<MerchantSettings>(this as MerchantSettings, _$identity);

  /// Serializes this MerchantSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MerchantSettings&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.waNotifications, waNotifications) || other.waNotifications == waNotifications)&&(identical(other.lowStockAlerts, lowStockAlerts) || other.lowStockAlerts == lowStockAlerts)&&(identical(other.dailyReports, dailyReports) || other.dailyReports == dailyReports)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,merchantId,waNotifications,lowStockAlerts,dailyReports,createdAt,updatedAt);

@override
String toString() {
  return 'MerchantSettings(merchantId: $merchantId, waNotifications: $waNotifications, lowStockAlerts: $lowStockAlerts, dailyReports: $dailyReports, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MerchantSettingsCopyWith<$Res>  {
  factory $MerchantSettingsCopyWith(MerchantSettings value, $Res Function(MerchantSettings) _then) = _$MerchantSettingsCopyWithImpl;
@useResult
$Res call({
 String merchantId, bool waNotifications, bool lowStockAlerts, bool dailyReports, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$MerchantSettingsCopyWithImpl<$Res>
    implements $MerchantSettingsCopyWith<$Res> {
  _$MerchantSettingsCopyWithImpl(this._self, this._then);

  final MerchantSettings _self;
  final $Res Function(MerchantSettings) _then;

/// Create a copy of MerchantSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? merchantId = null,Object? waNotifications = null,Object? lowStockAlerts = null,Object? dailyReports = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,waNotifications: null == waNotifications ? _self.waNotifications : waNotifications // ignore: cast_nullable_to_non_nullable
as bool,lowStockAlerts: null == lowStockAlerts ? _self.lowStockAlerts : lowStockAlerts // ignore: cast_nullable_to_non_nullable
as bool,dailyReports: null == dailyReports ? _self.dailyReports : dailyReports // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MerchantSettings].
extension MerchantSettingsPatterns on MerchantSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MerchantSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MerchantSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MerchantSettings value)  $default,){
final _that = this;
switch (_that) {
case _MerchantSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MerchantSettings value)?  $default,){
final _that = this;
switch (_that) {
case _MerchantSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String merchantId,  bool waNotifications,  bool lowStockAlerts,  bool dailyReports,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MerchantSettings() when $default != null:
return $default(_that.merchantId,_that.waNotifications,_that.lowStockAlerts,_that.dailyReports,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String merchantId,  bool waNotifications,  bool lowStockAlerts,  bool dailyReports,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MerchantSettings():
return $default(_that.merchantId,_that.waNotifications,_that.lowStockAlerts,_that.dailyReports,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String merchantId,  bool waNotifications,  bool lowStockAlerts,  bool dailyReports,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MerchantSettings() when $default != null:
return $default(_that.merchantId,_that.waNotifications,_that.lowStockAlerts,_that.dailyReports,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MerchantSettings implements MerchantSettings {
  const _MerchantSettings({required this.merchantId, this.waNotifications = true, this.lowStockAlerts = true, this.dailyReports = false, required this.createdAt, required this.updatedAt});
  factory _MerchantSettings.fromJson(Map<String, dynamic> json) => _$MerchantSettingsFromJson(json);

@override final  String merchantId;
@override@JsonKey() final  bool waNotifications;
@override@JsonKey() final  bool lowStockAlerts;
@override@JsonKey() final  bool dailyReports;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of MerchantSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MerchantSettingsCopyWith<_MerchantSettings> get copyWith => __$MerchantSettingsCopyWithImpl<_MerchantSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MerchantSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MerchantSettings&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.waNotifications, waNotifications) || other.waNotifications == waNotifications)&&(identical(other.lowStockAlerts, lowStockAlerts) || other.lowStockAlerts == lowStockAlerts)&&(identical(other.dailyReports, dailyReports) || other.dailyReports == dailyReports)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,merchantId,waNotifications,lowStockAlerts,dailyReports,createdAt,updatedAt);

@override
String toString() {
  return 'MerchantSettings(merchantId: $merchantId, waNotifications: $waNotifications, lowStockAlerts: $lowStockAlerts, dailyReports: $dailyReports, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MerchantSettingsCopyWith<$Res> implements $MerchantSettingsCopyWith<$Res> {
  factory _$MerchantSettingsCopyWith(_MerchantSettings value, $Res Function(_MerchantSettings) _then) = __$MerchantSettingsCopyWithImpl;
@override @useResult
$Res call({
 String merchantId, bool waNotifications, bool lowStockAlerts, bool dailyReports, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$MerchantSettingsCopyWithImpl<$Res>
    implements _$MerchantSettingsCopyWith<$Res> {
  __$MerchantSettingsCopyWithImpl(this._self, this._then);

  final _MerchantSettings _self;
  final $Res Function(_MerchantSettings) _then;

/// Create a copy of MerchantSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? merchantId = null,Object? waNotifications = null,Object? lowStockAlerts = null,Object? dailyReports = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_MerchantSettings(
merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,waNotifications: null == waNotifications ? _self.waNotifications : waNotifications // ignore: cast_nullable_to_non_nullable
as bool,lowStockAlerts: null == lowStockAlerts ? _self.lowStockAlerts : lowStockAlerts // ignore: cast_nullable_to_non_nullable
as bool,dailyReports: null == dailyReports ? _self.dailyReports : dailyReports // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
