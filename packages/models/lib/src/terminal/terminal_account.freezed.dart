// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'terminal_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TerminalAccount {

 Terminal get terminal; Store? get store; Merchant? get merchant; StoreSubscription? get subscription;
/// Create a copy of TerminalAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TerminalAccountCopyWith<TerminalAccount> get copyWith => _$TerminalAccountCopyWithImpl<TerminalAccount>(this as TerminalAccount, _$identity);

  /// Serializes this TerminalAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TerminalAccount&&(identical(other.terminal, terminal) || other.terminal == terminal)&&(identical(other.store, store) || other.store == store)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.subscription, subscription) || other.subscription == subscription));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,terminal,store,merchant,subscription);

@override
String toString() {
  return 'TerminalAccount(terminal: $terminal, store: $store, merchant: $merchant, subscription: $subscription)';
}


}

/// @nodoc
abstract mixin class $TerminalAccountCopyWith<$Res>  {
  factory $TerminalAccountCopyWith(TerminalAccount value, $Res Function(TerminalAccount) _then) = _$TerminalAccountCopyWithImpl;
@useResult
$Res call({
 Terminal terminal, Store? store, Merchant? merchant, StoreSubscription? subscription
});


$TerminalCopyWith<$Res> get terminal;$StoreCopyWith<$Res>? get store;$MerchantCopyWith<$Res>? get merchant;$StoreSubscriptionCopyWith<$Res>? get subscription;

}
/// @nodoc
class _$TerminalAccountCopyWithImpl<$Res>
    implements $TerminalAccountCopyWith<$Res> {
  _$TerminalAccountCopyWithImpl(this._self, this._then);

  final TerminalAccount _self;
  final $Res Function(TerminalAccount) _then;

/// Create a copy of TerminalAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? terminal = null,Object? store = freezed,Object? merchant = freezed,Object? subscription = freezed,}) {
  return _then(_self.copyWith(
terminal: null == terminal ? _self.terminal : terminal // ignore: cast_nullable_to_non_nullable
as Terminal,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as Store?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as Merchant?,subscription: freezed == subscription ? _self.subscription : subscription // ignore: cast_nullable_to_non_nullable
as StoreSubscription?,
  ));
}
/// Create a copy of TerminalAccount
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TerminalCopyWith<$Res> get terminal {
  
  return $TerminalCopyWith<$Res>(_self.terminal, (value) {
    return _then(_self.copyWith(terminal: value));
  });
}/// Create a copy of TerminalAccount
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoreCopyWith<$Res>? get store {
    if (_self.store == null) {
    return null;
  }

  return $StoreCopyWith<$Res>(_self.store!, (value) {
    return _then(_self.copyWith(store: value));
  });
}/// Create a copy of TerminalAccount
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MerchantCopyWith<$Res>? get merchant {
    if (_self.merchant == null) {
    return null;
  }

  return $MerchantCopyWith<$Res>(_self.merchant!, (value) {
    return _then(_self.copyWith(merchant: value));
  });
}/// Create a copy of TerminalAccount
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoreSubscriptionCopyWith<$Res>? get subscription {
    if (_self.subscription == null) {
    return null;
  }

  return $StoreSubscriptionCopyWith<$Res>(_self.subscription!, (value) {
    return _then(_self.copyWith(subscription: value));
  });
}
}


/// Adds pattern-matching-related methods to [TerminalAccount].
extension TerminalAccountPatterns on TerminalAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TerminalAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TerminalAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TerminalAccount value)  $default,){
final _that = this;
switch (_that) {
case _TerminalAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TerminalAccount value)?  $default,){
final _that = this;
switch (_that) {
case _TerminalAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Terminal terminal,  Store? store,  Merchant? merchant,  StoreSubscription? subscription)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TerminalAccount() when $default != null:
return $default(_that.terminal,_that.store,_that.merchant,_that.subscription);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Terminal terminal,  Store? store,  Merchant? merchant,  StoreSubscription? subscription)  $default,) {final _that = this;
switch (_that) {
case _TerminalAccount():
return $default(_that.terminal,_that.store,_that.merchant,_that.subscription);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Terminal terminal,  Store? store,  Merchant? merchant,  StoreSubscription? subscription)?  $default,) {final _that = this;
switch (_that) {
case _TerminalAccount() when $default != null:
return $default(_that.terminal,_that.store,_that.merchant,_that.subscription);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TerminalAccount implements TerminalAccount {
  const _TerminalAccount({required this.terminal, this.store, this.merchant, this.subscription});
  factory _TerminalAccount.fromJson(Map<String, dynamic> json) => _$TerminalAccountFromJson(json);

@override final  Terminal terminal;
@override final  Store? store;
@override final  Merchant? merchant;
@override final  StoreSubscription? subscription;

/// Create a copy of TerminalAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TerminalAccountCopyWith<_TerminalAccount> get copyWith => __$TerminalAccountCopyWithImpl<_TerminalAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TerminalAccountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TerminalAccount&&(identical(other.terminal, terminal) || other.terminal == terminal)&&(identical(other.store, store) || other.store == store)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.subscription, subscription) || other.subscription == subscription));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,terminal,store,merchant,subscription);

@override
String toString() {
  return 'TerminalAccount(terminal: $terminal, store: $store, merchant: $merchant, subscription: $subscription)';
}


}

/// @nodoc
abstract mixin class _$TerminalAccountCopyWith<$Res> implements $TerminalAccountCopyWith<$Res> {
  factory _$TerminalAccountCopyWith(_TerminalAccount value, $Res Function(_TerminalAccount) _then) = __$TerminalAccountCopyWithImpl;
@override @useResult
$Res call({
 Terminal terminal, Store? store, Merchant? merchant, StoreSubscription? subscription
});


@override $TerminalCopyWith<$Res> get terminal;@override $StoreCopyWith<$Res>? get store;@override $MerchantCopyWith<$Res>? get merchant;@override $StoreSubscriptionCopyWith<$Res>? get subscription;

}
/// @nodoc
class __$TerminalAccountCopyWithImpl<$Res>
    implements _$TerminalAccountCopyWith<$Res> {
  __$TerminalAccountCopyWithImpl(this._self, this._then);

  final _TerminalAccount _self;
  final $Res Function(_TerminalAccount) _then;

/// Create a copy of TerminalAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? terminal = null,Object? store = freezed,Object? merchant = freezed,Object? subscription = freezed,}) {
  return _then(_TerminalAccount(
terminal: null == terminal ? _self.terminal : terminal // ignore: cast_nullable_to_non_nullable
as Terminal,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as Store?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as Merchant?,subscription: freezed == subscription ? _self.subscription : subscription // ignore: cast_nullable_to_non_nullable
as StoreSubscription?,
  ));
}

/// Create a copy of TerminalAccount
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TerminalCopyWith<$Res> get terminal {
  
  return $TerminalCopyWith<$Res>(_self.terminal, (value) {
    return _then(_self.copyWith(terminal: value));
  });
}/// Create a copy of TerminalAccount
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoreCopyWith<$Res>? get store {
    if (_self.store == null) {
    return null;
  }

  return $StoreCopyWith<$Res>(_self.store!, (value) {
    return _then(_self.copyWith(store: value));
  });
}/// Create a copy of TerminalAccount
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MerchantCopyWith<$Res>? get merchant {
    if (_self.merchant == null) {
    return null;
  }

  return $MerchantCopyWith<$Res>(_self.merchant!, (value) {
    return _then(_self.copyWith(merchant: value));
  });
}/// Create a copy of TerminalAccount
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoreSubscriptionCopyWith<$Res>? get subscription {
    if (_self.subscription == null) {
    return null;
  }

  return $StoreSubscriptionCopyWith<$Res>(_self.subscription!, (value) {
    return _then(_self.copyWith(subscription: value));
  });
}
}

// dart format on
