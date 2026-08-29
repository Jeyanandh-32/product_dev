// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoreSubscription {

 String get id; String get storeId; SubscriptionPlanCode get planCode; SubscriptionStatus get status; DateTime get startsAt; DateTime get endsAt; DateTime? get graceEndsAt; bool get autoRenew; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of StoreSubscription
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreSubscriptionCopyWith<StoreSubscription> get copyWith => _$StoreSubscriptionCopyWithImpl<StoreSubscription>(this as StoreSubscription, _$identity);

  /// Serializes this StoreSubscription to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreSubscription&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.planCode, planCode) || other.planCode == planCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.graceEndsAt, graceEndsAt) || other.graceEndsAt == graceEndsAt)&&(identical(other.autoRenew, autoRenew) || other.autoRenew == autoRenew)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,planCode,status,startsAt,endsAt,graceEndsAt,autoRenew,createdAt,updatedAt);

@override
String toString() {
  return 'StoreSubscription(id: $id, storeId: $storeId, planCode: $planCode, status: $status, startsAt: $startsAt, endsAt: $endsAt, graceEndsAt: $graceEndsAt, autoRenew: $autoRenew, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StoreSubscriptionCopyWith<$Res>  {
  factory $StoreSubscriptionCopyWith(StoreSubscription value, $Res Function(StoreSubscription) _then) = _$StoreSubscriptionCopyWithImpl;
@useResult
$Res call({
 String id, String storeId, SubscriptionPlanCode planCode, SubscriptionStatus status, DateTime startsAt, DateTime endsAt, DateTime? graceEndsAt, bool autoRenew, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$StoreSubscriptionCopyWithImpl<$Res>
    implements $StoreSubscriptionCopyWith<$Res> {
  _$StoreSubscriptionCopyWithImpl(this._self, this._then);

  final StoreSubscription _self;
  final $Res Function(StoreSubscription) _then;

/// Create a copy of StoreSubscription
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storeId = null,Object? planCode = null,Object? status = null,Object? startsAt = null,Object? endsAt = null,Object? graceEndsAt = freezed,Object? autoRenew = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,planCode: null == planCode ? _self.planCode : planCode // ignore: cast_nullable_to_non_nullable
as SubscriptionPlanCode,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubscriptionStatus,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,graceEndsAt: freezed == graceEndsAt ? _self.graceEndsAt : graceEndsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,autoRenew: null == autoRenew ? _self.autoRenew : autoRenew // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreSubscription].
extension StoreSubscriptionPatterns on StoreSubscription {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreSubscription value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreSubscription() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreSubscription value)  $default,){
final _that = this;
switch (_that) {
case _StoreSubscription():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreSubscription value)?  $default,){
final _that = this;
switch (_that) {
case _StoreSubscription() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String storeId,  SubscriptionPlanCode planCode,  SubscriptionStatus status,  DateTime startsAt,  DateTime endsAt,  DateTime? graceEndsAt,  bool autoRenew,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreSubscription() when $default != null:
return $default(_that.id,_that.storeId,_that.planCode,_that.status,_that.startsAt,_that.endsAt,_that.graceEndsAt,_that.autoRenew,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String storeId,  SubscriptionPlanCode planCode,  SubscriptionStatus status,  DateTime startsAt,  DateTime endsAt,  DateTime? graceEndsAt,  bool autoRenew,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StoreSubscription():
return $default(_that.id,_that.storeId,_that.planCode,_that.status,_that.startsAt,_that.endsAt,_that.graceEndsAt,_that.autoRenew,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String storeId,  SubscriptionPlanCode planCode,  SubscriptionStatus status,  DateTime startsAt,  DateTime endsAt,  DateTime? graceEndsAt,  bool autoRenew,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StoreSubscription() when $default != null:
return $default(_that.id,_that.storeId,_that.planCode,_that.status,_that.startsAt,_that.endsAt,_that.graceEndsAt,_that.autoRenew,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreSubscription implements StoreSubscription {
  const _StoreSubscription({required this.id, required this.storeId, required this.planCode, required this.status, required this.startsAt, required this.endsAt, this.graceEndsAt, this.autoRenew = true, this.createdAt, this.updatedAt});
  factory _StoreSubscription.fromJson(Map<String, dynamic> json) => _$StoreSubscriptionFromJson(json);

@override final  String id;
@override final  String storeId;
@override final  SubscriptionPlanCode planCode;
@override final  SubscriptionStatus status;
@override final  DateTime startsAt;
@override final  DateTime endsAt;
@override final  DateTime? graceEndsAt;
@override@JsonKey() final  bool autoRenew;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of StoreSubscription
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreSubscriptionCopyWith<_StoreSubscription> get copyWith => __$StoreSubscriptionCopyWithImpl<_StoreSubscription>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreSubscriptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreSubscription&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.planCode, planCode) || other.planCode == planCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.graceEndsAt, graceEndsAt) || other.graceEndsAt == graceEndsAt)&&(identical(other.autoRenew, autoRenew) || other.autoRenew == autoRenew)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,planCode,status,startsAt,endsAt,graceEndsAt,autoRenew,createdAt,updatedAt);

@override
String toString() {
  return 'StoreSubscription(id: $id, storeId: $storeId, planCode: $planCode, status: $status, startsAt: $startsAt, endsAt: $endsAt, graceEndsAt: $graceEndsAt, autoRenew: $autoRenew, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StoreSubscriptionCopyWith<$Res> implements $StoreSubscriptionCopyWith<$Res> {
  factory _$StoreSubscriptionCopyWith(_StoreSubscription value, $Res Function(_StoreSubscription) _then) = __$StoreSubscriptionCopyWithImpl;
@override @useResult
$Res call({
 String id, String storeId, SubscriptionPlanCode planCode, SubscriptionStatus status, DateTime startsAt, DateTime endsAt, DateTime? graceEndsAt, bool autoRenew, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$StoreSubscriptionCopyWithImpl<$Res>
    implements _$StoreSubscriptionCopyWith<$Res> {
  __$StoreSubscriptionCopyWithImpl(this._self, this._then);

  final _StoreSubscription _self;
  final $Res Function(_StoreSubscription) _then;

/// Create a copy of StoreSubscription
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storeId = null,Object? planCode = null,Object? status = null,Object? startsAt = null,Object? endsAt = null,Object? graceEndsAt = freezed,Object? autoRenew = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_StoreSubscription(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,planCode: null == planCode ? _self.planCode : planCode // ignore: cast_nullable_to_non_nullable
as SubscriptionPlanCode,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubscriptionStatus,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,graceEndsAt: freezed == graceEndsAt ? _self.graceEndsAt : graceEndsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,autoRenew: null == autoRenew ? _self.autoRenew : autoRenew // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
