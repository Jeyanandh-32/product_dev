// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merchant_platform_fee_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MerchantPlatformFeeSummary {

 int get unsettledAmountInPaise; int get unsettledOrdersCount; List<PlatformFeeSettlement> get recentSettlements;
/// Create a copy of MerchantPlatformFeeSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MerchantPlatformFeeSummaryCopyWith<MerchantPlatformFeeSummary> get copyWith => _$MerchantPlatformFeeSummaryCopyWithImpl<MerchantPlatformFeeSummary>(this as MerchantPlatformFeeSummary, _$identity);

  /// Serializes this MerchantPlatformFeeSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MerchantPlatformFeeSummary&&(identical(other.unsettledAmountInPaise, unsettledAmountInPaise) || other.unsettledAmountInPaise == unsettledAmountInPaise)&&(identical(other.unsettledOrdersCount, unsettledOrdersCount) || other.unsettledOrdersCount == unsettledOrdersCount)&&const DeepCollectionEquality().equals(other.recentSettlements, recentSettlements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,unsettledAmountInPaise,unsettledOrdersCount,const DeepCollectionEquality().hash(recentSettlements));

@override
String toString() {
  return 'MerchantPlatformFeeSummary(unsettledAmountInPaise: $unsettledAmountInPaise, unsettledOrdersCount: $unsettledOrdersCount, recentSettlements: $recentSettlements)';
}


}

/// @nodoc
abstract mixin class $MerchantPlatformFeeSummaryCopyWith<$Res>  {
  factory $MerchantPlatformFeeSummaryCopyWith(MerchantPlatformFeeSummary value, $Res Function(MerchantPlatformFeeSummary) _then) = _$MerchantPlatformFeeSummaryCopyWithImpl;
@useResult
$Res call({
 int unsettledAmountInPaise, int unsettledOrdersCount, List<PlatformFeeSettlement> recentSettlements
});




}
/// @nodoc
class _$MerchantPlatformFeeSummaryCopyWithImpl<$Res>
    implements $MerchantPlatformFeeSummaryCopyWith<$Res> {
  _$MerchantPlatformFeeSummaryCopyWithImpl(this._self, this._then);

  final MerchantPlatformFeeSummary _self;
  final $Res Function(MerchantPlatformFeeSummary) _then;

/// Create a copy of MerchantPlatformFeeSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? unsettledAmountInPaise = null,Object? unsettledOrdersCount = null,Object? recentSettlements = null,}) {
  return _then(_self.copyWith(
unsettledAmountInPaise: null == unsettledAmountInPaise ? _self.unsettledAmountInPaise : unsettledAmountInPaise // ignore: cast_nullable_to_non_nullable
as int,unsettledOrdersCount: null == unsettledOrdersCount ? _self.unsettledOrdersCount : unsettledOrdersCount // ignore: cast_nullable_to_non_nullable
as int,recentSettlements: null == recentSettlements ? _self.recentSettlements : recentSettlements // ignore: cast_nullable_to_non_nullable
as List<PlatformFeeSettlement>,
  ));
}

}


/// Adds pattern-matching-related methods to [MerchantPlatformFeeSummary].
extension MerchantPlatformFeeSummaryPatterns on MerchantPlatformFeeSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MerchantPlatformFeeSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MerchantPlatformFeeSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MerchantPlatformFeeSummary value)  $default,){
final _that = this;
switch (_that) {
case _MerchantPlatformFeeSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MerchantPlatformFeeSummary value)?  $default,){
final _that = this;
switch (_that) {
case _MerchantPlatformFeeSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int unsettledAmountInPaise,  int unsettledOrdersCount,  List<PlatformFeeSettlement> recentSettlements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MerchantPlatformFeeSummary() when $default != null:
return $default(_that.unsettledAmountInPaise,_that.unsettledOrdersCount,_that.recentSettlements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int unsettledAmountInPaise,  int unsettledOrdersCount,  List<PlatformFeeSettlement> recentSettlements)  $default,) {final _that = this;
switch (_that) {
case _MerchantPlatformFeeSummary():
return $default(_that.unsettledAmountInPaise,_that.unsettledOrdersCount,_that.recentSettlements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int unsettledAmountInPaise,  int unsettledOrdersCount,  List<PlatformFeeSettlement> recentSettlements)?  $default,) {final _that = this;
switch (_that) {
case _MerchantPlatformFeeSummary() when $default != null:
return $default(_that.unsettledAmountInPaise,_that.unsettledOrdersCount,_that.recentSettlements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MerchantPlatformFeeSummary implements MerchantPlatformFeeSummary {
  const _MerchantPlatformFeeSummary({required this.unsettledAmountInPaise, required this.unsettledOrdersCount, this.recentSettlements = const []});
  factory _MerchantPlatformFeeSummary.fromJson(Map<String, dynamic> json) => _$MerchantPlatformFeeSummaryFromJson(json);

@override final  int unsettledAmountInPaise;
@override final  int unsettledOrdersCount;
@override@JsonKey() final  List<PlatformFeeSettlement> recentSettlements;

/// Create a copy of MerchantPlatformFeeSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MerchantPlatformFeeSummaryCopyWith<_MerchantPlatformFeeSummary> get copyWith => __$MerchantPlatformFeeSummaryCopyWithImpl<_MerchantPlatformFeeSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MerchantPlatformFeeSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MerchantPlatformFeeSummary&&(identical(other.unsettledAmountInPaise, unsettledAmountInPaise) || other.unsettledAmountInPaise == unsettledAmountInPaise)&&(identical(other.unsettledOrdersCount, unsettledOrdersCount) || other.unsettledOrdersCount == unsettledOrdersCount)&&const DeepCollectionEquality().equals(other.recentSettlements, recentSettlements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,unsettledAmountInPaise,unsettledOrdersCount,const DeepCollectionEquality().hash(recentSettlements));

@override
String toString() {
  return 'MerchantPlatformFeeSummary(unsettledAmountInPaise: $unsettledAmountInPaise, unsettledOrdersCount: $unsettledOrdersCount, recentSettlements: $recentSettlements)';
}


}

/// @nodoc
abstract mixin class _$MerchantPlatformFeeSummaryCopyWith<$Res> implements $MerchantPlatformFeeSummaryCopyWith<$Res> {
  factory _$MerchantPlatformFeeSummaryCopyWith(_MerchantPlatformFeeSummary value, $Res Function(_MerchantPlatformFeeSummary) _then) = __$MerchantPlatformFeeSummaryCopyWithImpl;
@override @useResult
$Res call({
 int unsettledAmountInPaise, int unsettledOrdersCount, List<PlatformFeeSettlement> recentSettlements
});




}
/// @nodoc
class __$MerchantPlatformFeeSummaryCopyWithImpl<$Res>
    implements _$MerchantPlatformFeeSummaryCopyWith<$Res> {
  __$MerchantPlatformFeeSummaryCopyWithImpl(this._self, this._then);

  final _MerchantPlatformFeeSummary _self;
  final $Res Function(_MerchantPlatformFeeSummary) _then;

/// Create a copy of MerchantPlatformFeeSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? unsettledAmountInPaise = null,Object? unsettledOrdersCount = null,Object? recentSettlements = null,}) {
  return _then(_MerchantPlatformFeeSummary(
unsettledAmountInPaise: null == unsettledAmountInPaise ? _self.unsettledAmountInPaise : unsettledAmountInPaise // ignore: cast_nullable_to_non_nullable
as int,unsettledOrdersCount: null == unsettledOrdersCount ? _self.unsettledOrdersCount : unsettledOrdersCount // ignore: cast_nullable_to_non_nullable
as int,recentSettlements: null == recentSettlements ? _self.recentSettlements : recentSettlements // ignore: cast_nullable_to_non_nullable
as List<PlatformFeeSettlement>,
  ));
}


}

// dart format on
