// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'counter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Counter {

 String get id; String get name; String get merchantId; String get storeId; bool get isActive; DateTime get createdAt; DateTime get updatedAt; String? get description; String? get imageUrl;
/// Create a copy of Counter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CounterCopyWith<Counter> get copyWith => _$CounterCopyWithImpl<Counter>(this as Counter, _$identity);

  /// Serializes this Counter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Counter&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,merchantId,storeId,isActive,createdAt,updatedAt,description,imageUrl);

@override
String toString() {
  return 'Counter(id: $id, name: $name, merchantId: $merchantId, storeId: $storeId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $CounterCopyWith<$Res>  {
  factory $CounterCopyWith(Counter value, $Res Function(Counter) _then) = _$CounterCopyWithImpl;
@useResult
$Res call({
 String id, String name, String merchantId, String storeId, bool isActive, DateTime createdAt, DateTime updatedAt, String? description, String? imageUrl
});




}
/// @nodoc
class _$CounterCopyWithImpl<$Res>
    implements $CounterCopyWith<$Res> {
  _$CounterCopyWithImpl(this._self, this._then);

  final Counter _self;
  final $Res Function(Counter) _then;

/// Create a copy of Counter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? merchantId = null,Object? storeId = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Counter].
extension CounterPatterns on Counter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Counter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Counter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Counter value)  $default,){
final _that = this;
switch (_that) {
case _Counter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Counter value)?  $default,){
final _that = this;
switch (_that) {
case _Counter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String merchantId,  String storeId,  bool isActive,  DateTime createdAt,  DateTime updatedAt,  String? description,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Counter() when $default != null:
return $default(_that.id,_that.name,_that.merchantId,_that.storeId,_that.isActive,_that.createdAt,_that.updatedAt,_that.description,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String merchantId,  String storeId,  bool isActive,  DateTime createdAt,  DateTime updatedAt,  String? description,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _Counter():
return $default(_that.id,_that.name,_that.merchantId,_that.storeId,_that.isActive,_that.createdAt,_that.updatedAt,_that.description,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String merchantId,  String storeId,  bool isActive,  DateTime createdAt,  DateTime updatedAt,  String? description,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _Counter() when $default != null:
return $default(_that.id,_that.name,_that.merchantId,_that.storeId,_that.isActive,_that.createdAt,_that.updatedAt,_that.description,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Counter implements Counter {
  const _Counter({required this.id, required this.name, required this.merchantId, required this.storeId, required this.isActive, required this.createdAt, required this.updatedAt, this.description, this.imageUrl});
  factory _Counter.fromJson(Map<String, dynamic> json) => _$CounterFromJson(json);

@override final  String id;
@override final  String name;
@override final  String merchantId;
@override final  String storeId;
@override final  bool isActive;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? description;
@override final  String? imageUrl;

/// Create a copy of Counter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CounterCopyWith<_Counter> get copyWith => __$CounterCopyWithImpl<_Counter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CounterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Counter&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.merchantId, merchantId) || other.merchantId == merchantId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,merchantId,storeId,isActive,createdAt,updatedAt,description,imageUrl);

@override
String toString() {
  return 'Counter(id: $id, name: $name, merchantId: $merchantId, storeId: $storeId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$CounterCopyWith<$Res> implements $CounterCopyWith<$Res> {
  factory _$CounterCopyWith(_Counter value, $Res Function(_Counter) _then) = __$CounterCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String merchantId, String storeId, bool isActive, DateTime createdAt, DateTime updatedAt, String? description, String? imageUrl
});




}
/// @nodoc
class __$CounterCopyWithImpl<$Res>
    implements _$CounterCopyWith<$Res> {
  __$CounterCopyWithImpl(this._self, this._then);

  final _Counter _self;
  final $Res Function(_Counter) _then;

/// Create a copy of Counter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? merchantId = null,Object? storeId = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? imageUrl = freezed,}) {
  return _then(_Counter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,merchantId: null == merchantId ? _self.merchantId : merchantId // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
