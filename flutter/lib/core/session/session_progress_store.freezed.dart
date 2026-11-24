// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_progress_store.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionProgress {

 String get displayName;/// `null` once onboarding has been completed.
 OnboardingStep? get pendingStep;
/// Create a copy of SessionProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionProgressCopyWith<SessionProgress> get copyWith => _$SessionProgressCopyWithImpl<SessionProgress>(this as SessionProgress, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SessionProgress;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionProgress&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.pendingStep, _this.pendingStep) || other.pendingStep == _this.pendingStep));
}


@override
int get hashCode {
  final _this = this as SessionProgress;
  return Object.hash(runtimeType,_this.displayName,_this.pendingStep);
}

@override
String toString() {
  final _this = this as SessionProgress;
  return 'SessionProgress(displayName: ${_this.displayName}, pendingStep: ${_this.pendingStep})';
}


}

/// @nodoc
abstract mixin class $SessionProgressCopyWith<$Res>  {
  factory $SessionProgressCopyWith(SessionProgress value, $Res Function(SessionProgress) _then) = _$SessionProgressCopyWithImpl;
@useResult
$Res call({
 String displayName, OnboardingStep? pendingStep
});




}
/// @nodoc
class _$SessionProgressCopyWithImpl<$Res>
    implements $SessionProgressCopyWith<$Res> {
  _$SessionProgressCopyWithImpl(this._self, this._then);

  final SessionProgress _self;
  final $Res Function(SessionProgress) _then;

/// Create a copy of SessionProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = null,Object? pendingStep = freezed,}) {
  return _then(SessionProgress(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,pendingStep: freezed == pendingStep ? _self.pendingStep : pendingStep // ignore: cast_nullable_to_non_nullable
as OnboardingStep?,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionProgress].
extension SessionProgressPatterns on SessionProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionProgress value)  $default,){
final _that = this;
switch (_that) {
case _SessionProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionProgress value)?  $default,){
final _that = this;
switch (_that) {
case _SessionProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String displayName,  OnboardingStep? pendingStep)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionProgress() when $default != null:
return $default(_that.displayName,_that.pendingStep);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String displayName,  OnboardingStep? pendingStep)  $default,) {final _that = this;
switch (_that) {
case _SessionProgress():
return $default(_that.displayName,_that.pendingStep);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String displayName,  OnboardingStep? pendingStep)?  $default,) {final _that = this;
switch (_that) {
case _SessionProgress() when $default != null:
return $default(_that.displayName,_that.pendingStep);case _:
  return null;

}
}

}

/// @nodoc


class _SessionProgress implements SessionProgress {
  const _SessionProgress({required this.displayName, this.pendingStep});
  

@override final  String displayName;
/// `null` once onboarding has been completed.
@override final  OnboardingStep? pendingStep;

/// Create a copy of SessionProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionProgressCopyWith<_SessionProgress> get copyWith => __$SessionProgressCopyWithImpl<_SessionProgress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionProgress&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.pendingStep, pendingStep) || other.pendingStep == pendingStep));
}


@override
int get hashCode {
    return Object.hash(runtimeType,displayName,pendingStep);
}

@override
String toString() {
    return 'SessionProgress(displayName: $displayName, pendingStep: $pendingStep)';
}


}

/// @nodoc
abstract mixin class _$SessionProgressCopyWith<$Res> implements $SessionProgressCopyWith<$Res> {
  factory _$SessionProgressCopyWith(_SessionProgress value, $Res Function(_SessionProgress) _then) = __$SessionProgressCopyWithImpl;
@override @useResult
$Res call({
 String displayName, OnboardingStep? pendingStep
});




}
/// @nodoc
class __$SessionProgressCopyWithImpl<$Res>
    implements _$SessionProgressCopyWith<$Res> {
  __$SessionProgressCopyWithImpl(this._self, this._then);

  final _SessionProgress _self;
  final $Res Function(_SessionProgress) _then;

/// Create a copy of SessionProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = null,Object? pendingStep = freezed,}) {
  return _then(_SessionProgress(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,pendingStep: freezed == pendingStep ? _self.pendingStep : pendingStep // ignore: cast_nullable_to_non_nullable
as OnboardingStep?,
  ));
}


}

// dart format on
