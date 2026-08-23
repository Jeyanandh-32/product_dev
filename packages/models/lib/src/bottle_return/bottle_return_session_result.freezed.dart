// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bottle_return_session_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BottleReturnSessionResult {

 int get totalBottlesReturned; int get totalRewardAmount; BottleRewardMode get rewardMode; String? get customerPhone; BottlePhysicalCoupon? get physicalCoupon; String get message;
/// Create a copy of BottleReturnSessionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BottleReturnSessionResultCopyWith<BottleReturnSessionResult> get copyWith => _$BottleReturnSessionResultCopyWithImpl<BottleReturnSessionResult>(this as BottleReturnSessionResult, _$identity);

  /// Serializes this BottleReturnSessionResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BottleReturnSessionResult&&(identical(other.totalBottlesReturned, totalBottlesReturned) || other.totalBottlesReturned == totalBottlesReturned)&&(identical(other.totalRewardAmount, totalRewardAmount) || other.totalRewardAmount == totalRewardAmount)&&(identical(other.rewardMode, rewardMode) || other.rewardMode == rewardMode)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.physicalCoupon, physicalCoupon) || other.physicalCoupon == physicalCoupon)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalBottlesReturned,totalRewardAmount,rewardMode,customerPhone,physicalCoupon,message);

@override
String toString() {
  return 'BottleReturnSessionResult(totalBottlesReturned: $totalBottlesReturned, totalRewardAmount: $totalRewardAmount, rewardMode: $rewardMode, customerPhone: $customerPhone, physicalCoupon: $physicalCoupon, message: $message)';
}


}

/// @nodoc
abstract mixin class $BottleReturnSessionResultCopyWith<$Res>  {
  factory $BottleReturnSessionResultCopyWith(BottleReturnSessionResult value, $Res Function(BottleReturnSessionResult) _then) = _$BottleReturnSessionResultCopyWithImpl;
@useResult
$Res call({
 int totalBottlesReturned, int totalRewardAmount, BottleRewardMode rewardMode, String? customerPhone, BottlePhysicalCoupon? physicalCoupon, String message
});


$BottlePhysicalCouponCopyWith<$Res>? get physicalCoupon;

}
/// @nodoc
class _$BottleReturnSessionResultCopyWithImpl<$Res>
    implements $BottleReturnSessionResultCopyWith<$Res> {
  _$BottleReturnSessionResultCopyWithImpl(this._self, this._then);

  final BottleReturnSessionResult _self;
  final $Res Function(BottleReturnSessionResult) _then;

/// Create a copy of BottleReturnSessionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalBottlesReturned = null,Object? totalRewardAmount = null,Object? rewardMode = null,Object? customerPhone = freezed,Object? physicalCoupon = freezed,Object? message = null,}) {
  return _then(_self.copyWith(
totalBottlesReturned: null == totalBottlesReturned ? _self.totalBottlesReturned : totalBottlesReturned // ignore: cast_nullable_to_non_nullable
as int,totalRewardAmount: null == totalRewardAmount ? _self.totalRewardAmount : totalRewardAmount // ignore: cast_nullable_to_non_nullable
as int,rewardMode: null == rewardMode ? _self.rewardMode : rewardMode // ignore: cast_nullable_to_non_nullable
as BottleRewardMode,customerPhone: freezed == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String?,physicalCoupon: freezed == physicalCoupon ? _self.physicalCoupon : physicalCoupon // ignore: cast_nullable_to_non_nullable
as BottlePhysicalCoupon?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of BottleReturnSessionResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BottlePhysicalCouponCopyWith<$Res>? get physicalCoupon {
    if (_self.physicalCoupon == null) {
    return null;
  }

  return $BottlePhysicalCouponCopyWith<$Res>(_self.physicalCoupon!, (value) {
    return _then(_self.copyWith(physicalCoupon: value));
  });
}
}


/// Adds pattern-matching-related methods to [BottleReturnSessionResult].
extension BottleReturnSessionResultPatterns on BottleReturnSessionResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BottleReturnSessionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BottleReturnSessionResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BottleReturnSessionResult value)  $default,){
final _that = this;
switch (_that) {
case _BottleReturnSessionResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BottleReturnSessionResult value)?  $default,){
final _that = this;
switch (_that) {
case _BottleReturnSessionResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalBottlesReturned,  int totalRewardAmount,  BottleRewardMode rewardMode,  String? customerPhone,  BottlePhysicalCoupon? physicalCoupon,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BottleReturnSessionResult() when $default != null:
return $default(_that.totalBottlesReturned,_that.totalRewardAmount,_that.rewardMode,_that.customerPhone,_that.physicalCoupon,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalBottlesReturned,  int totalRewardAmount,  BottleRewardMode rewardMode,  String? customerPhone,  BottlePhysicalCoupon? physicalCoupon,  String message)  $default,) {final _that = this;
switch (_that) {
case _BottleReturnSessionResult():
return $default(_that.totalBottlesReturned,_that.totalRewardAmount,_that.rewardMode,_that.customerPhone,_that.physicalCoupon,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalBottlesReturned,  int totalRewardAmount,  BottleRewardMode rewardMode,  String? customerPhone,  BottlePhysicalCoupon? physicalCoupon,  String message)?  $default,) {final _that = this;
switch (_that) {
case _BottleReturnSessionResult() when $default != null:
return $default(_that.totalBottlesReturned,_that.totalRewardAmount,_that.rewardMode,_that.customerPhone,_that.physicalCoupon,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BottleReturnSessionResult implements BottleReturnSessionResult {
  const _BottleReturnSessionResult({required this.totalBottlesReturned, required this.totalRewardAmount, required this.rewardMode, this.customerPhone, this.physicalCoupon, required this.message});
  factory _BottleReturnSessionResult.fromJson(Map<String, dynamic> json) => _$BottleReturnSessionResultFromJson(json);

@override final  int totalBottlesReturned;
@override final  int totalRewardAmount;
@override final  BottleRewardMode rewardMode;
@override final  String? customerPhone;
@override final  BottlePhysicalCoupon? physicalCoupon;
@override final  String message;

/// Create a copy of BottleReturnSessionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BottleReturnSessionResultCopyWith<_BottleReturnSessionResult> get copyWith => __$BottleReturnSessionResultCopyWithImpl<_BottleReturnSessionResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BottleReturnSessionResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BottleReturnSessionResult&&(identical(other.totalBottlesReturned, totalBottlesReturned) || other.totalBottlesReturned == totalBottlesReturned)&&(identical(other.totalRewardAmount, totalRewardAmount) || other.totalRewardAmount == totalRewardAmount)&&(identical(other.rewardMode, rewardMode) || other.rewardMode == rewardMode)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.physicalCoupon, physicalCoupon) || other.physicalCoupon == physicalCoupon)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalBottlesReturned,totalRewardAmount,rewardMode,customerPhone,physicalCoupon,message);

@override
String toString() {
  return 'BottleReturnSessionResult(totalBottlesReturned: $totalBottlesReturned, totalRewardAmount: $totalRewardAmount, rewardMode: $rewardMode, customerPhone: $customerPhone, physicalCoupon: $physicalCoupon, message: $message)';
}


}

/// @nodoc
abstract mixin class _$BottleReturnSessionResultCopyWith<$Res> implements $BottleReturnSessionResultCopyWith<$Res> {
  factory _$BottleReturnSessionResultCopyWith(_BottleReturnSessionResult value, $Res Function(_BottleReturnSessionResult) _then) = __$BottleReturnSessionResultCopyWithImpl;
@override @useResult
$Res call({
 int totalBottlesReturned, int totalRewardAmount, BottleRewardMode rewardMode, String? customerPhone, BottlePhysicalCoupon? physicalCoupon, String message
});


@override $BottlePhysicalCouponCopyWith<$Res>? get physicalCoupon;

}
/// @nodoc
class __$BottleReturnSessionResultCopyWithImpl<$Res>
    implements _$BottleReturnSessionResultCopyWith<$Res> {
  __$BottleReturnSessionResultCopyWithImpl(this._self, this._then);

  final _BottleReturnSessionResult _self;
  final $Res Function(_BottleReturnSessionResult) _then;

/// Create a copy of BottleReturnSessionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalBottlesReturned = null,Object? totalRewardAmount = null,Object? rewardMode = null,Object? customerPhone = freezed,Object? physicalCoupon = freezed,Object? message = null,}) {
  return _then(_BottleReturnSessionResult(
totalBottlesReturned: null == totalBottlesReturned ? _self.totalBottlesReturned : totalBottlesReturned // ignore: cast_nullable_to_non_nullable
as int,totalRewardAmount: null == totalRewardAmount ? _self.totalRewardAmount : totalRewardAmount // ignore: cast_nullable_to_non_nullable
as int,rewardMode: null == rewardMode ? _self.rewardMode : rewardMode // ignore: cast_nullable_to_non_nullable
as BottleRewardMode,customerPhone: freezed == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String?,physicalCoupon: freezed == physicalCoupon ? _self.physicalCoupon : physicalCoupon // ignore: cast_nullable_to_non_nullable
as BottlePhysicalCoupon?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of BottleReturnSessionResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BottlePhysicalCouponCopyWith<$Res>? get physicalCoupon {
    if (_self.physicalCoupon == null) {
    return null;
  }

  return $BottlePhysicalCouponCopyWith<$Res>(_self.physicalCoupon!, (value) {
    return _then(_self.copyWith(physicalCoupon: value));
  });
}
}

// dart format on
