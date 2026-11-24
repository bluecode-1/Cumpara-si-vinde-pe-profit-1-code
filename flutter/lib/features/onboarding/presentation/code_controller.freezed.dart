// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'code_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CodeState {

/// E.164 number the code was sent to; empty if there is no challenge.
 String get phone;/// Remaining wait before the code can be re-sent; 0 enables "Resend".
 int get secondsUntilResend; bool get isSubmitting; bool get isResending; AppError? get error;/// Incremented every time the input field must be emptied
/// (after `OTP_INVALID`).
 int get clearInputSignal;
/// Create a copy of CodeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CodeStateCopyWith<CodeState> get copyWith => _$CodeStateCopyWithImpl<CodeState>(this as CodeState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CodeState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CodeState&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.secondsUntilResend, _this.secondsUntilResend) || other.secondsUntilResend == _this.secondsUntilResend)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.isResending, _this.isResending) || other.isResending == _this.isResending)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.clearInputSignal, _this.clearInputSignal) || other.clearInputSignal == _this.clearInputSignal));
}


@override
int get hashCode {
  final _this = this as CodeState;
  return Object.hash(runtimeType,_this.phone,_this.secondsUntilResend,_this.isSubmitting,_this.isResending,_this.error,_this.clearInputSignal);
}

@override
String toString() {
  final _this = this as CodeState;
  return 'CodeState(phone: ${_this.phone}, secondsUntilResend: ${_this.secondsUntilResend}, isSubmitting: ${_this.isSubmitting}, isResending: ${_this.isResending}, error: ${_this.error}, clearInputSignal: ${_this.clearInputSignal})';
}


}

/// @nodoc
abstract mixin class $CodeStateCopyWith<$Res>  {
  factory $CodeStateCopyWith(CodeState value, $Res Function(CodeState) _then) = _$CodeStateCopyWithImpl;
@useResult
$Res call({
 String phone, int secondsUntilResend, bool isSubmitting, bool isResending, AppError? error, int clearInputSignal
});




}
/// @nodoc
class _$CodeStateCopyWithImpl<$Res>
    implements $CodeStateCopyWith<$Res> {
  _$CodeStateCopyWithImpl(this._self, this._then);

  final CodeState _self;
  final $Res Function(CodeState) _then;

/// Create a copy of CodeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phone = null,Object? secondsUntilResend = null,Object? isSubmitting = null,Object? isResending = null,Object? error = freezed,Object? clearInputSignal = null,}) {
  return _then(CodeState(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,secondsUntilResend: null == secondsUntilResend ? _self.secondsUntilResend : secondsUntilResend // ignore: cast_nullable_to_non_nullable
as int,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isResending: null == isResending ? _self.isResending : isResending // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppError?,clearInputSignal: null == clearInputSignal ? _self.clearInputSignal : clearInputSignal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CodeState].
extension CodeStatePatterns on CodeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CodeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CodeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CodeState value)  $default,){
final _that = this;
switch (_that) {
case _CodeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CodeState value)?  $default,){
final _that = this;
switch (_that) {
case _CodeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phone,  int secondsUntilResend,  bool isSubmitting,  bool isResending,  AppError? error,  int clearInputSignal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CodeState() when $default != null:
return $default(_that.phone,_that.secondsUntilResend,_that.isSubmitting,_that.isResending,_that.error,_that.clearInputSignal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phone,  int secondsUntilResend,  bool isSubmitting,  bool isResending,  AppError? error,  int clearInputSignal)  $default,) {final _that = this;
switch (_that) {
case _CodeState():
return $default(_that.phone,_that.secondsUntilResend,_that.isSubmitting,_that.isResending,_that.error,_that.clearInputSignal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phone,  int secondsUntilResend,  bool isSubmitting,  bool isResending,  AppError? error,  int clearInputSignal)?  $default,) {final _that = this;
switch (_that) {
case _CodeState() when $default != null:
return $default(_that.phone,_that.secondsUntilResend,_that.isSubmitting,_that.isResending,_that.error,_that.clearInputSignal);case _:
  return null;

}
}

}

/// @nodoc


class _CodeState extends CodeState {
  const _CodeState({this.phone = '', this.secondsUntilResend = 0, this.isSubmitting = false, this.isResending = false, this.error, this.clearInputSignal = 0}): super._();
  

/// E.164 number the code was sent to; empty if there is no challenge.
@override@JsonKey() final  String phone;
/// Remaining wait before the code can be re-sent; 0 enables "Resend".
@override@JsonKey() final  int secondsUntilResend;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool isResending;
@override final  AppError? error;
/// Incremented every time the input field must be emptied
/// (after `OTP_INVALID`).
@override@JsonKey() final  int clearInputSignal;

/// Create a copy of CodeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CodeStateCopyWith<_CodeState> get copyWith => __$CodeStateCopyWithImpl<_CodeState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CodeState&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.secondsUntilResend, secondsUntilResend) || other.secondsUntilResend == secondsUntilResend)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isResending, isResending) || other.isResending == isResending)&&(identical(other.error, error) || other.error == error)&&(identical(other.clearInputSignal, clearInputSignal) || other.clearInputSignal == clearInputSignal));
}


@override
int get hashCode {
    return Object.hash(runtimeType,phone,secondsUntilResend,isSubmitting,isResending,error,clearInputSignal);
}

@override
String toString() {
    return 'CodeState(phone: $phone, secondsUntilResend: $secondsUntilResend, isSubmitting: $isSubmitting, isResending: $isResending, error: $error, clearInputSignal: $clearInputSignal)';
}


}

/// @nodoc
abstract mixin class _$CodeStateCopyWith<$Res> implements $CodeStateCopyWith<$Res> {
  factory _$CodeStateCopyWith(_CodeState value, $Res Function(_CodeState) _then) = __$CodeStateCopyWithImpl;
@override @useResult
$Res call({
 String phone, int secondsUntilResend, bool isSubmitting, bool isResending, AppError? error, int clearInputSignal
});




}
/// @nodoc
class __$CodeStateCopyWithImpl<$Res>
    implements _$CodeStateCopyWith<$Res> {
  __$CodeStateCopyWithImpl(this._self, this._then);

  final _CodeState _self;
  final $Res Function(_CodeState) _then;

/// Create a copy of CodeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phone = null,Object? secondsUntilResend = null,Object? isSubmitting = null,Object? isResending = null,Object? error = freezed,Object? clearInputSignal = null,}) {
  return _then(_CodeState(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,secondsUntilResend: null == secondsUntilResend ? _self.secondsUntilResend : secondsUntilResend // ignore: cast_nullable_to_non_nullable
as int,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isResending: null == isResending ? _self.isResending : isResending // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppError?,clearInputSignal: null == clearInputSignal ? _self.clearInputSignal : clearInputSignal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
