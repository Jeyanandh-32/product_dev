// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_phonepe_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StorePhonePeConfig {

 String get id; String get storeId; bool get isEnabled; PaymentGatewayEnv get env; String? get clientId; String? get clientVersion; String? get clientSecret; String? get saltKey; int get saltIndex; bool get enableUpi; bool get enableCards; bool get enableNetBanking; bool get enableEmi; bool get enableWallets; String? get allowedUpiApps; WebhookAuthType get webhookAuthType; String? get webhookSecretKey; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of StorePhonePeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorePhonePeConfigCopyWith<StorePhonePeConfig> get copyWith => _$StorePhonePeConfigCopyWithImpl<StorePhonePeConfig>(this as StorePhonePeConfig, _$identity);

  /// Serializes this StorePhonePeConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorePhonePeConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.env, env) || other.env == env)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientVersion, clientVersion) || other.clientVersion == clientVersion)&&(identical(other.clientSecret, clientSecret) || other.clientSecret == clientSecret)&&(identical(other.saltKey, saltKey) || other.saltKey == saltKey)&&(identical(other.saltIndex, saltIndex) || other.saltIndex == saltIndex)&&(identical(other.enableUpi, enableUpi) || other.enableUpi == enableUpi)&&(identical(other.enableCards, enableCards) || other.enableCards == enableCards)&&(identical(other.enableNetBanking, enableNetBanking) || other.enableNetBanking == enableNetBanking)&&(identical(other.enableEmi, enableEmi) || other.enableEmi == enableEmi)&&(identical(other.enableWallets, enableWallets) || other.enableWallets == enableWallets)&&(identical(other.allowedUpiApps, allowedUpiApps) || other.allowedUpiApps == allowedUpiApps)&&(identical(other.webhookAuthType, webhookAuthType) || other.webhookAuthType == webhookAuthType)&&(identical(other.webhookSecretKey, webhookSecretKey) || other.webhookSecretKey == webhookSecretKey)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,storeId,isEnabled,env,clientId,clientVersion,clientSecret,saltKey,saltIndex,enableUpi,enableCards,enableNetBanking,enableEmi,enableWallets,allowedUpiApps,webhookAuthType,webhookSecretKey,createdAt,updatedAt]);

@override
String toString() {
  return 'StorePhonePeConfig(id: $id, storeId: $storeId, isEnabled: $isEnabled, env: $env, clientId: $clientId, clientVersion: $clientVersion, clientSecret: $clientSecret, saltKey: $saltKey, saltIndex: $saltIndex, enableUpi: $enableUpi, enableCards: $enableCards, enableNetBanking: $enableNetBanking, enableEmi: $enableEmi, enableWallets: $enableWallets, allowedUpiApps: $allowedUpiApps, webhookAuthType: $webhookAuthType, webhookSecretKey: $webhookSecretKey, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StorePhonePeConfigCopyWith<$Res>  {
  factory $StorePhonePeConfigCopyWith(StorePhonePeConfig value, $Res Function(StorePhonePeConfig) _then) = _$StorePhonePeConfigCopyWithImpl;
@useResult
$Res call({
 String id, String storeId, bool isEnabled, PaymentGatewayEnv env, String? clientId, String? clientVersion, String? clientSecret, String? saltKey, int saltIndex, bool enableUpi, bool enableCards, bool enableNetBanking, bool enableEmi, bool enableWallets, String? allowedUpiApps, WebhookAuthType webhookAuthType, String? webhookSecretKey, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$StorePhonePeConfigCopyWithImpl<$Res>
    implements $StorePhonePeConfigCopyWith<$Res> {
  _$StorePhonePeConfigCopyWithImpl(this._self, this._then);

  final StorePhonePeConfig _self;
  final $Res Function(StorePhonePeConfig) _then;

/// Create a copy of StorePhonePeConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storeId = null,Object? isEnabled = null,Object? env = null,Object? clientId = freezed,Object? clientVersion = freezed,Object? clientSecret = freezed,Object? saltKey = freezed,Object? saltIndex = null,Object? enableUpi = null,Object? enableCards = null,Object? enableNetBanking = null,Object? enableEmi = null,Object? enableWallets = null,Object? allowedUpiApps = freezed,Object? webhookAuthType = null,Object? webhookSecretKey = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,env: null == env ? _self.env : env // ignore: cast_nullable_to_non_nullable
as PaymentGatewayEnv,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,clientVersion: freezed == clientVersion ? _self.clientVersion : clientVersion // ignore: cast_nullable_to_non_nullable
as String?,clientSecret: freezed == clientSecret ? _self.clientSecret : clientSecret // ignore: cast_nullable_to_non_nullable
as String?,saltKey: freezed == saltKey ? _self.saltKey : saltKey // ignore: cast_nullable_to_non_nullable
as String?,saltIndex: null == saltIndex ? _self.saltIndex : saltIndex // ignore: cast_nullable_to_non_nullable
as int,enableUpi: null == enableUpi ? _self.enableUpi : enableUpi // ignore: cast_nullable_to_non_nullable
as bool,enableCards: null == enableCards ? _self.enableCards : enableCards // ignore: cast_nullable_to_non_nullable
as bool,enableNetBanking: null == enableNetBanking ? _self.enableNetBanking : enableNetBanking // ignore: cast_nullable_to_non_nullable
as bool,enableEmi: null == enableEmi ? _self.enableEmi : enableEmi // ignore: cast_nullable_to_non_nullable
as bool,enableWallets: null == enableWallets ? _self.enableWallets : enableWallets // ignore: cast_nullable_to_non_nullable
as bool,allowedUpiApps: freezed == allowedUpiApps ? _self.allowedUpiApps : allowedUpiApps // ignore: cast_nullable_to_non_nullable
as String?,webhookAuthType: null == webhookAuthType ? _self.webhookAuthType : webhookAuthType // ignore: cast_nullable_to_non_nullable
as WebhookAuthType,webhookSecretKey: freezed == webhookSecretKey ? _self.webhookSecretKey : webhookSecretKey // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StorePhonePeConfig].
extension StorePhonePeConfigPatterns on StorePhonePeConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorePhonePeConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorePhonePeConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorePhonePeConfig value)  $default,){
final _that = this;
switch (_that) {
case _StorePhonePeConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorePhonePeConfig value)?  $default,){
final _that = this;
switch (_that) {
case _StorePhonePeConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String storeId,  bool isEnabled,  PaymentGatewayEnv env,  String? clientId,  String? clientVersion,  String? clientSecret,  String? saltKey,  int saltIndex,  bool enableUpi,  bool enableCards,  bool enableNetBanking,  bool enableEmi,  bool enableWallets,  String? allowedUpiApps,  WebhookAuthType webhookAuthType,  String? webhookSecretKey,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorePhonePeConfig() when $default != null:
return $default(_that.id,_that.storeId,_that.isEnabled,_that.env,_that.clientId,_that.clientVersion,_that.clientSecret,_that.saltKey,_that.saltIndex,_that.enableUpi,_that.enableCards,_that.enableNetBanking,_that.enableEmi,_that.enableWallets,_that.allowedUpiApps,_that.webhookAuthType,_that.webhookSecretKey,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String storeId,  bool isEnabled,  PaymentGatewayEnv env,  String? clientId,  String? clientVersion,  String? clientSecret,  String? saltKey,  int saltIndex,  bool enableUpi,  bool enableCards,  bool enableNetBanking,  bool enableEmi,  bool enableWallets,  String? allowedUpiApps,  WebhookAuthType webhookAuthType,  String? webhookSecretKey,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StorePhonePeConfig():
return $default(_that.id,_that.storeId,_that.isEnabled,_that.env,_that.clientId,_that.clientVersion,_that.clientSecret,_that.saltKey,_that.saltIndex,_that.enableUpi,_that.enableCards,_that.enableNetBanking,_that.enableEmi,_that.enableWallets,_that.allowedUpiApps,_that.webhookAuthType,_that.webhookSecretKey,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String storeId,  bool isEnabled,  PaymentGatewayEnv env,  String? clientId,  String? clientVersion,  String? clientSecret,  String? saltKey,  int saltIndex,  bool enableUpi,  bool enableCards,  bool enableNetBanking,  bool enableEmi,  bool enableWallets,  String? allowedUpiApps,  WebhookAuthType webhookAuthType,  String? webhookSecretKey,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StorePhonePeConfig() when $default != null:
return $default(_that.id,_that.storeId,_that.isEnabled,_that.env,_that.clientId,_that.clientVersion,_that.clientSecret,_that.saltKey,_that.saltIndex,_that.enableUpi,_that.enableCards,_that.enableNetBanking,_that.enableEmi,_that.enableWallets,_that.allowedUpiApps,_that.webhookAuthType,_that.webhookSecretKey,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorePhonePeConfig implements StorePhonePeConfig {
  const _StorePhonePeConfig({required this.id, required this.storeId, this.isEnabled = true, this.env = PaymentGatewayEnv.uat, this.clientId, this.clientVersion, this.clientSecret, this.saltKey, this.saltIndex = 1, this.enableUpi = true, this.enableCards = false, this.enableNetBanking = false, this.enableEmi = false, this.enableWallets = false, this.allowedUpiApps, this.webhookAuthType = WebhookAuthType.hmac, this.webhookSecretKey, required this.createdAt, required this.updatedAt});
  factory _StorePhonePeConfig.fromJson(Map<String, dynamic> json) => _$StorePhonePeConfigFromJson(json);

@override final  String id;
@override final  String storeId;
@override@JsonKey() final  bool isEnabled;
@override@JsonKey() final  PaymentGatewayEnv env;
@override final  String? clientId;
@override final  String? clientVersion;
@override final  String? clientSecret;
@override final  String? saltKey;
@override@JsonKey() final  int saltIndex;
@override@JsonKey() final  bool enableUpi;
@override@JsonKey() final  bool enableCards;
@override@JsonKey() final  bool enableNetBanking;
@override@JsonKey() final  bool enableEmi;
@override@JsonKey() final  bool enableWallets;
@override final  String? allowedUpiApps;
@override@JsonKey() final  WebhookAuthType webhookAuthType;
@override final  String? webhookSecretKey;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of StorePhonePeConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorePhonePeConfigCopyWith<_StorePhonePeConfig> get copyWith => __$StorePhonePeConfigCopyWithImpl<_StorePhonePeConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorePhonePeConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorePhonePeConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.env, env) || other.env == env)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientVersion, clientVersion) || other.clientVersion == clientVersion)&&(identical(other.clientSecret, clientSecret) || other.clientSecret == clientSecret)&&(identical(other.saltKey, saltKey) || other.saltKey == saltKey)&&(identical(other.saltIndex, saltIndex) || other.saltIndex == saltIndex)&&(identical(other.enableUpi, enableUpi) || other.enableUpi == enableUpi)&&(identical(other.enableCards, enableCards) || other.enableCards == enableCards)&&(identical(other.enableNetBanking, enableNetBanking) || other.enableNetBanking == enableNetBanking)&&(identical(other.enableEmi, enableEmi) || other.enableEmi == enableEmi)&&(identical(other.enableWallets, enableWallets) || other.enableWallets == enableWallets)&&(identical(other.allowedUpiApps, allowedUpiApps) || other.allowedUpiApps == allowedUpiApps)&&(identical(other.webhookAuthType, webhookAuthType) || other.webhookAuthType == webhookAuthType)&&(identical(other.webhookSecretKey, webhookSecretKey) || other.webhookSecretKey == webhookSecretKey)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,storeId,isEnabled,env,clientId,clientVersion,clientSecret,saltKey,saltIndex,enableUpi,enableCards,enableNetBanking,enableEmi,enableWallets,allowedUpiApps,webhookAuthType,webhookSecretKey,createdAt,updatedAt]);

@override
String toString() {
  return 'StorePhonePeConfig(id: $id, storeId: $storeId, isEnabled: $isEnabled, env: $env, clientId: $clientId, clientVersion: $clientVersion, clientSecret: $clientSecret, saltKey: $saltKey, saltIndex: $saltIndex, enableUpi: $enableUpi, enableCards: $enableCards, enableNetBanking: $enableNetBanking, enableEmi: $enableEmi, enableWallets: $enableWallets, allowedUpiApps: $allowedUpiApps, webhookAuthType: $webhookAuthType, webhookSecretKey: $webhookSecretKey, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StorePhonePeConfigCopyWith<$Res> implements $StorePhonePeConfigCopyWith<$Res> {
  factory _$StorePhonePeConfigCopyWith(_StorePhonePeConfig value, $Res Function(_StorePhonePeConfig) _then) = __$StorePhonePeConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, String storeId, bool isEnabled, PaymentGatewayEnv env, String? clientId, String? clientVersion, String? clientSecret, String? saltKey, int saltIndex, bool enableUpi, bool enableCards, bool enableNetBanking, bool enableEmi, bool enableWallets, String? allowedUpiApps, WebhookAuthType webhookAuthType, String? webhookSecretKey, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$StorePhonePeConfigCopyWithImpl<$Res>
    implements _$StorePhonePeConfigCopyWith<$Res> {
  __$StorePhonePeConfigCopyWithImpl(this._self, this._then);

  final _StorePhonePeConfig _self;
  final $Res Function(_StorePhonePeConfig) _then;

/// Create a copy of StorePhonePeConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storeId = null,Object? isEnabled = null,Object? env = null,Object? clientId = freezed,Object? clientVersion = freezed,Object? clientSecret = freezed,Object? saltKey = freezed,Object? saltIndex = null,Object? enableUpi = null,Object? enableCards = null,Object? enableNetBanking = null,Object? enableEmi = null,Object? enableWallets = null,Object? allowedUpiApps = freezed,Object? webhookAuthType = null,Object? webhookSecretKey = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_StorePhonePeConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,env: null == env ? _self.env : env // ignore: cast_nullable_to_non_nullable
as PaymentGatewayEnv,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,clientVersion: freezed == clientVersion ? _self.clientVersion : clientVersion // ignore: cast_nullable_to_non_nullable
as String?,clientSecret: freezed == clientSecret ? _self.clientSecret : clientSecret // ignore: cast_nullable_to_non_nullable
as String?,saltKey: freezed == saltKey ? _self.saltKey : saltKey // ignore: cast_nullable_to_non_nullable
as String?,saltIndex: null == saltIndex ? _self.saltIndex : saltIndex // ignore: cast_nullable_to_non_nullable
as int,enableUpi: null == enableUpi ? _self.enableUpi : enableUpi // ignore: cast_nullable_to_non_nullable
as bool,enableCards: null == enableCards ? _self.enableCards : enableCards // ignore: cast_nullable_to_non_nullable
as bool,enableNetBanking: null == enableNetBanking ? _self.enableNetBanking : enableNetBanking // ignore: cast_nullable_to_non_nullable
as bool,enableEmi: null == enableEmi ? _self.enableEmi : enableEmi // ignore: cast_nullable_to_non_nullable
as bool,enableWallets: null == enableWallets ? _self.enableWallets : enableWallets // ignore: cast_nullable_to_non_nullable
as bool,allowedUpiApps: freezed == allowedUpiApps ? _self.allowedUpiApps : allowedUpiApps // ignore: cast_nullable_to_non_nullable
as String?,webhookAuthType: null == webhookAuthType ? _self.webhookAuthType : webhookAuthType // ignore: cast_nullable_to_non_nullable
as WebhookAuthType,webhookSecretKey: freezed == webhookSecretKey ? _self.webhookSecretKey : webhookSecretKey // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
