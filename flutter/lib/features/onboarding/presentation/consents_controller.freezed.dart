// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consents_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConsentsState {

/// Nothing is pre-selected: consent cannot be presumed (GDPR).
 Set<ConsentPurpose> get granted; bool get isSubmitting; AppError? get error;
/// Create a copy of ConsentsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsentsStateCopyWith<ConsentsState> get copyWith => _$ConsentsStateCopyWithImpl<ConsentsState>(this as ConsentsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ConsentsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsentsState&&const DeepCollectionEquality().equals(other.granted, _this.granted)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as ConsentsState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.granted),_this.isSubmitting,_this.error);
}

@override
String toString() {
  final _this = this as ConsentsState;
  return 'ConsentsState(granted: ${_this.granted}, isSubmitting: ${_this.isSubmitting}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $ConsentsStateCopyWith<$Res>  {
  factory $ConsentsStateCopyWith(ConsentsState value, $Res Function(ConsentsState) _then) = _$ConsentsStateCopyWithImpl;
@useResult
$Res call({
 Set<ConsentPurpose> granted, bool isSubmitting, AppError? error
});




}
/// @nodoc
class _$ConsentsStateCopyWithImpl<$Res>
    implements $ConsentsStateCopyWith<$Res> {
  _$ConsentsStateCopyWithImpl(this._self, this._then);

  final ConsentsState _self;
  final $Res Function(ConsentsState) _then;

/// Create a copy of ConsentsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? granted = null,Object? isSubmitting = null,Object? error = freezed,}) {
  return _then(ConsentsState(
granted: null == granted ? _self.granted : granted // ignore: cast_nullable_to_non_nullable
as Set<ConsentPurpose>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppError?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsentsState].
extension ConsentsStatePatterns on ConsentsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsentsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsentsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsentsState value)  $default,){
final _that = this;
switch (_that) {
case _ConsentsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsentsState value)?  $default,){
final _that = this;
switch (_that) {
case _ConsentsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<ConsentPurpose> granted,  bool isSubmitting,  AppError? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsentsState() when $default != null:
return $default(_that.granted,_that.isSubmitting,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<ConsentPurpose> granted,  bool isSubmitting,  AppError? error)  $default,) {final _that = this;
switch (_that) {
case _ConsentsState():
return $default(_that.granted,_that.isSubmitting,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<ConsentPurpose> granted,  bool isSubmitting,  AppError? error)?  $default,) {final _that = this;
switch (_that) {
case _ConsentsState() when $default != null:
return $default(_that.granted,_that.isSubmitting,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ConsentsState extends ConsentsState {
  const _ConsentsState({ Set<ConsentPurpose> granted = const <ConsentPurpose>{}, this.isSubmitting = false, this.error}): _granted = granted,super._();
  

/// Nothing is pre-selected: consent cannot be presumed (GDPR).
 final  Set<ConsentPurpose> _granted;
/// Nothing is pre-selected: consent cannot be presumed (GDPR).
@override@JsonKey() Set<ConsentPurpose> get granted {
  if (_granted is EqualUnmodifiableSetView) return _granted;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_granted);
}

@override@JsonKey() final  bool isSubmitting;
@override final  AppError? error;

/// Create a copy of ConsentsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsentsStateCopyWith<_ConsentsState> get copyWith => __$ConsentsStateCopyWithImpl<_ConsentsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsentsState&&const DeepCollectionEquality().equals(other.granted, _granted)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_granted),isSubmitting,error);
}

@override
String toString() {
    return 'ConsentsState(granted: $granted, isSubmitting: $isSubmitting, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ConsentsStateCopyWith<$Res> implements $ConsentsStateCopyWith<$Res> {
  factory _$ConsentsStateCopyWith(_ConsentsState value, $Res Function(_ConsentsState) _then) = __$ConsentsStateCopyWithImpl;
@override @useResult
$Res call({
 Set<ConsentPurpose> granted, bool isSubmitting, AppError? error
});




}
/// @nodoc
class __$ConsentsStateCopyWithImpl<$Res>
    implements _$ConsentsStateCopyWith<$Res> {
  __$ConsentsStateCopyWithImpl(this._self, this._then);

  final _ConsentsState _self;
  final $Res Function(_ConsentsState) _then;

/// Create a copy of ConsentsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? granted = null,Object? isSubmitting = null,Object? error = freezed,}) {
  return _then(_ConsentsState(
granted: null == granted ? _self._granted : granted // ignore: cast_nullable_to_non_nullable
as Set<ConsentPurpose>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppError?,
  ));
}


}

// dart format on
