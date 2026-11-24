// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phone_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PhoneState {

 bool get isSubmitting;/// The input failed local validation; no request was made.
 bool get isInvalidNumber;/// The request failed.
 AppError? get error;/// Set once the code has been sent: the screen moves on to Code.
 OtpChallenge? get sentChallenge;
/// Create a copy of PhoneState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhoneStateCopyWith<PhoneState> get copyWith => _$PhoneStateCopyWithImpl<PhoneState>(this as PhoneState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PhoneState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneState&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.isInvalidNumber, _this.isInvalidNumber) || other.isInvalidNumber == _this.isInvalidNumber)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.sentChallenge, _this.sentChallenge) || other.sentChallenge == _this.sentChallenge));
}


@override
int get hashCode {
  final _this = this as PhoneState;
  return Object.hash(runtimeType,_this.isSubmitting,_this.isInvalidNumber,_this.error,_this.sentChallenge);
}

@override
String toString() {
  final _this = this as PhoneState;
  return 'PhoneState(isSubmitting: ${_this.isSubmitting}, isInvalidNumber: ${_this.isInvalidNumber}, error: ${_this.error}, sentChallenge: ${_this.sentChallenge})';
}


}

/// @nodoc
abstract mixin class $PhoneStateCopyWith<$Res>  {
  factory $PhoneStateCopyWith(PhoneState value, $Res Function(PhoneState) _then) = _$PhoneStateCopyWithImpl;
@useResult
$Res call({
 bool isSubmitting, bool isInvalidNumber, AppError? error, OtpChallenge? sentChallenge
});


$OtpChallengeCopyWith<$Res>? get sentChallenge;

}
/// @nodoc
class _$PhoneStateCopyWithImpl<$Res>
    implements $PhoneStateCopyWith<$Res> {
  _$PhoneStateCopyWithImpl(this._self, this._then);

  final PhoneState _self;
  final $Res Function(PhoneState) _then;

/// Create a copy of PhoneState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSubmitting = null,Object? isInvalidNumber = null,Object? error = freezed,Object? sentChallenge = freezed,}) {
  return _then(PhoneState(
isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isInvalidNumber: null == isInvalidNumber ? _self.isInvalidNumber : isInvalidNumber // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppError?,sentChallenge: freezed == sentChallenge ? _self.sentChallenge : sentChallenge // ignore: cast_nullable_to_non_nullable
as OtpChallenge?,
  ));
}
/// Create a copy of PhoneState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OtpChallengeCopyWith<$Res>? get sentChallenge {
    if (_self.sentChallenge == null) {
    return null;
  }

  return $OtpChallengeCopyWith<$Res>(_self.sentChallenge!, (value) {
    return _then(_self.copyWith(sentChallenge: value));
  });
}
}


/// Adds pattern-matching-related methods to [PhoneState].
extension PhoneStatePatterns on PhoneState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhoneState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhoneState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhoneState value)  $default,){
final _that = this;
switch (_that) {
case _PhoneState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhoneState value)?  $default,){
final _that = this;
switch (_that) {
case _PhoneState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSubmitting,  bool isInvalidNumber,  AppError? error,  OtpChallenge? sentChallenge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhoneState() when $default != null:
return $default(_that.isSubmitting,_that.isInvalidNumber,_that.error,_that.sentChallenge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSubmitting,  bool isInvalidNumber,  AppError? error,  OtpChallenge? sentChallenge)  $default,) {final _that = this;
switch (_that) {
case _PhoneState():
return $default(_that.isSubmitting,_that.isInvalidNumber,_that.error,_that.sentChallenge);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSubmitting,  bool isInvalidNumber,  AppError? error,  OtpChallenge? sentChallenge)?  $default,) {final _that = this;
switch (_that) {
case _PhoneState() when $default != null:
return $default(_that.isSubmitting,_that.isInvalidNumber,_that.error,_that.sentChallenge);case _:
  return null;

}
}

}

/// @nodoc


class _PhoneState implements PhoneState {
  const _PhoneState({this.isSubmitting = false, this.isInvalidNumber = false, this.error, this.sentChallenge});
  

@override@JsonKey() final  bool isSubmitting;
/// The input failed local validation; no request was made.
@override@JsonKey() final  bool isInvalidNumber;
/// The request failed.
@override final  AppError? error;
/// Set once the code has been sent: the screen moves on to Code.
@override final  OtpChallenge? sentChallenge;

/// Create a copy of PhoneState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhoneStateCopyWith<_PhoneState> get copyWith => __$PhoneStateCopyWithImpl<_PhoneState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhoneState&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isInvalidNumber, isInvalidNumber) || other.isInvalidNumber == isInvalidNumber)&&(identical(other.error, error) || other.error == error)&&(identical(other.sentChallenge, sentChallenge) || other.sentChallenge == sentChallenge));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isSubmitting,isInvalidNumber,error,sentChallenge);
}

@override
String toString() {
    return 'PhoneState(isSubmitting: $isSubmitting, isInvalidNumber: $isInvalidNumber, error: $error, sentChallenge: $sentChallenge)';
}


}

/// @nodoc
abstract mixin class _$PhoneStateCopyWith<$Res> implements $PhoneStateCopyWith<$Res> {
  factory _$PhoneStateCopyWith(_PhoneState value, $Res Function(_PhoneState) _then) = __$PhoneStateCopyWithImpl;
@override @useResult
$Res call({
 bool isSubmitting, bool isInvalidNumber, AppError? error, OtpChallenge? sentChallenge
});


@override $OtpChallengeCopyWith<$Res>? get sentChallenge;

}
/// @nodoc
class __$PhoneStateCopyWithImpl<$Res>
    implements _$PhoneStateCopyWith<$Res> {
  __$PhoneStateCopyWithImpl(this._self, this._then);

  final _PhoneState _self;
  final $Res Function(_PhoneState) _then;

/// Create a copy of PhoneState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSubmitting = null,Object? isInvalidNumber = null,Object? error = freezed,Object? sentChallenge = freezed,}) {
  return _then(_PhoneState(
isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isInvalidNumber: null == isInvalidNumber ? _self.isInvalidNumber : isInvalidNumber // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppError?,sentChallenge: freezed == sentChallenge ? _self.sentChallenge : sentChallenge // ignore: cast_nullable_to_non_nullable
as OtpChallenge?,
  ));
}

/// Create a copy of PhoneState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OtpChallengeCopyWith<$Res>? get sentChallenge {
    if (_self.sentChallenge == null) {
    return null;
  }

  return $OtpChallengeCopyWith<$Res>(_self.sentChallenge!, (value) {
    return _then(_self.copyWith(sentChallenge: value));
  });
}
}

// dart format on
