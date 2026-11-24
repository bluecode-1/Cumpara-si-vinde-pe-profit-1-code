// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'name_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NameState {

 bool get isSubmitting;/// The name failed the 2-40 characters rule; no request was made.
 bool get isInvalidLength; AppError? get error;
/// Create a copy of NameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NameStateCopyWith<NameState> get copyWith => _$NameStateCopyWithImpl<NameState>(this as NameState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as NameState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NameState&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.isInvalidLength, _this.isInvalidLength) || other.isInvalidLength == _this.isInvalidLength)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as NameState;
  return Object.hash(runtimeType,_this.isSubmitting,_this.isInvalidLength,_this.error);
}

@override
String toString() {
  final _this = this as NameState;
  return 'NameState(isSubmitting: ${_this.isSubmitting}, isInvalidLength: ${_this.isInvalidLength}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $NameStateCopyWith<$Res>  {
  factory $NameStateCopyWith(NameState value, $Res Function(NameState) _then) = _$NameStateCopyWithImpl;
@useResult
$Res call({
 bool isSubmitting, bool isInvalidLength, AppError? error
});




}
/// @nodoc
class _$NameStateCopyWithImpl<$Res>
    implements $NameStateCopyWith<$Res> {
  _$NameStateCopyWithImpl(this._self, this._then);

  final NameState _self;
  final $Res Function(NameState) _then;

/// Create a copy of NameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSubmitting = null,Object? isInvalidLength = null,Object? error = freezed,}) {
  return _then(NameState(
isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isInvalidLength: null == isInvalidLength ? _self.isInvalidLength : isInvalidLength // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppError?,
  ));
}

}


/// Adds pattern-matching-related methods to [NameState].
extension NameStatePatterns on NameState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NameState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NameState value)  $default,){
final _that = this;
switch (_that) {
case _NameState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NameState value)?  $default,){
final _that = this;
switch (_that) {
case _NameState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSubmitting,  bool isInvalidLength,  AppError? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NameState() when $default != null:
return $default(_that.isSubmitting,_that.isInvalidLength,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSubmitting,  bool isInvalidLength,  AppError? error)  $default,) {final _that = this;
switch (_that) {
case _NameState():
return $default(_that.isSubmitting,_that.isInvalidLength,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSubmitting,  bool isInvalidLength,  AppError? error)?  $default,) {final _that = this;
switch (_that) {
case _NameState() when $default != null:
return $default(_that.isSubmitting,_that.isInvalidLength,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _NameState implements NameState {
  const _NameState({this.isSubmitting = false, this.isInvalidLength = false, this.error});
  

@override@JsonKey() final  bool isSubmitting;
/// The name failed the 2-40 characters rule; no request was made.
@override@JsonKey() final  bool isInvalidLength;
@override final  AppError? error;

/// Create a copy of NameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NameStateCopyWith<_NameState> get copyWith => __$NameStateCopyWithImpl<_NameState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NameState&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isInvalidLength, isInvalidLength) || other.isInvalidLength == isInvalidLength)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isSubmitting,isInvalidLength,error);
}

@override
String toString() {
    return 'NameState(isSubmitting: $isSubmitting, isInvalidLength: $isInvalidLength, error: $error)';
}


}

/// @nodoc
abstract mixin class _$NameStateCopyWith<$Res> implements $NameStateCopyWith<$Res> {
  factory _$NameStateCopyWith(_NameState value, $Res Function(_NameState) _then) = __$NameStateCopyWithImpl;
@override @useResult
$Res call({
 bool isSubmitting, bool isInvalidLength, AppError? error
});




}
/// @nodoc
class __$NameStateCopyWithImpl<$Res>
    implements _$NameStateCopyWith<$Res> {
  __$NameStateCopyWithImpl(this._self, this._then);

  final _NameState _self;
  final $Res Function(_NameState) _then;

/// Create a copy of NameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSubmitting = null,Object? isInvalidLength = null,Object? error = freezed,}) {
  return _then(_NameState(
isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isInvalidLength: null == isInvalidLength ? _self.isInvalidLength : isInvalidLength // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppError?,
  ));
}


}

// dart format on
