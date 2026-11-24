// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'interests_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InterestsState {

/// `null` until the categories have been loaded.
 List<InterestCategory>? get categories; AppError? get loadError; Set<String> get selectedIds; bool get isSubmitting; AppError? get submitError;
/// Create a copy of InterestsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InterestsStateCopyWith<InterestsState> get copyWith => _$InterestsStateCopyWithImpl<InterestsState>(this as InterestsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InterestsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InterestsState&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&(identical(other.loadError, _this.loadError) || other.loadError == _this.loadError)&&const DeepCollectionEquality().equals(other.selectedIds, _this.selectedIds)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.submitError, _this.submitError) || other.submitError == _this.submitError));
}


@override
int get hashCode {
  final _this = this as InterestsState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.categories),_this.loadError,const DeepCollectionEquality().hash(_this.selectedIds),_this.isSubmitting,_this.submitError);
}

@override
String toString() {
  final _this = this as InterestsState;
  return 'InterestsState(categories: ${_this.categories}, loadError: ${_this.loadError}, selectedIds: ${_this.selectedIds}, isSubmitting: ${_this.isSubmitting}, submitError: ${_this.submitError})';
}


}

/// @nodoc
abstract mixin class $InterestsStateCopyWith<$Res>  {
  factory $InterestsStateCopyWith(InterestsState value, $Res Function(InterestsState) _then) = _$InterestsStateCopyWithImpl;
@useResult
$Res call({
 List<InterestCategory>? categories, AppError? loadError, Set<String> selectedIds, bool isSubmitting, AppError? submitError
});




}
/// @nodoc
class _$InterestsStateCopyWithImpl<$Res>
    implements $InterestsStateCopyWith<$Res> {
  _$InterestsStateCopyWithImpl(this._self, this._then);

  final InterestsState _self;
  final $Res Function(InterestsState) _then;

/// Create a copy of InterestsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categories = freezed,Object? loadError = freezed,Object? selectedIds = null,Object? isSubmitting = null,Object? submitError = freezed,}) {
  return _then(InterestsState(
categories: freezed == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<InterestCategory>?,loadError: freezed == loadError ? _self.loadError : loadError // ignore: cast_nullable_to_non_nullable
as AppError?,selectedIds: null == selectedIds ? _self.selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitError: freezed == submitError ? _self.submitError : submitError // ignore: cast_nullable_to_non_nullable
as AppError?,
  ));
}

}


/// Adds pattern-matching-related methods to [InterestsState].
extension InterestsStatePatterns on InterestsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InterestsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InterestsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InterestsState value)  $default,){
final _that = this;
switch (_that) {
case _InterestsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InterestsState value)?  $default,){
final _that = this;
switch (_that) {
case _InterestsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<InterestCategory>? categories,  AppError? loadError,  Set<String> selectedIds,  bool isSubmitting,  AppError? submitError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InterestsState() when $default != null:
return $default(_that.categories,_that.loadError,_that.selectedIds,_that.isSubmitting,_that.submitError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<InterestCategory>? categories,  AppError? loadError,  Set<String> selectedIds,  bool isSubmitting,  AppError? submitError)  $default,) {final _that = this;
switch (_that) {
case _InterestsState():
return $default(_that.categories,_that.loadError,_that.selectedIds,_that.isSubmitting,_that.submitError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<InterestCategory>? categories,  AppError? loadError,  Set<String> selectedIds,  bool isSubmitting,  AppError? submitError)?  $default,) {final _that = this;
switch (_that) {
case _InterestsState() when $default != null:
return $default(_that.categories,_that.loadError,_that.selectedIds,_that.isSubmitting,_that.submitError);case _:
  return null;

}
}

}

/// @nodoc


class _InterestsState extends InterestsState {
  const _InterestsState({ List<InterestCategory>? categories, this.loadError,  Set<String> selectedIds = const <String>{}, this.isSubmitting = false, this.submitError}): _categories = categories,_selectedIds = selectedIds,super._();
  

/// `null` until the categories have been loaded.
 final  List<InterestCategory>? _categories;
/// `null` until the categories have been loaded.
@override List<InterestCategory>? get categories {
  final value = _categories;
  if (value == null) return null;
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  AppError? loadError;
 final  Set<String> _selectedIds;
@override@JsonKey() Set<String> get selectedIds {
  if (_selectedIds is EqualUnmodifiableSetView) return _selectedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedIds);
}

@override@JsonKey() final  bool isSubmitting;
@override final  AppError? submitError;

/// Create a copy of InterestsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InterestsStateCopyWith<_InterestsState> get copyWith => __$InterestsStateCopyWithImpl<_InterestsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InterestsState&&const DeepCollectionEquality().equals(other.categories, _categories)&&(identical(other.loadError, loadError) || other.loadError == loadError)&&const DeepCollectionEquality().equals(other.selectedIds, _selectedIds)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.submitError, submitError) || other.submitError == submitError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories),loadError,const DeepCollectionEquality().hash(_selectedIds),isSubmitting,submitError);
}

@override
String toString() {
    return 'InterestsState(categories: $categories, loadError: $loadError, selectedIds: $selectedIds, isSubmitting: $isSubmitting, submitError: $submitError)';
}


}

/// @nodoc
abstract mixin class _$InterestsStateCopyWith<$Res> implements $InterestsStateCopyWith<$Res> {
  factory _$InterestsStateCopyWith(_InterestsState value, $Res Function(_InterestsState) _then) = __$InterestsStateCopyWithImpl;
@override @useResult
$Res call({
 List<InterestCategory>? categories, AppError? loadError, Set<String> selectedIds, bool isSubmitting, AppError? submitError
});




}
/// @nodoc
class __$InterestsStateCopyWithImpl<$Res>
    implements _$InterestsStateCopyWith<$Res> {
  __$InterestsStateCopyWithImpl(this._self, this._then);

  final _InterestsState _self;
  final $Res Function(_InterestsState) _then;

/// Create a copy of InterestsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categories = freezed,Object? loadError = freezed,Object? selectedIds = null,Object? isSubmitting = null,Object? submitError = freezed,}) {
  return _then(_InterestsState(
categories: freezed == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<InterestCategory>?,loadError: freezed == loadError ? _self.loadError : loadError // ignore: cast_nullable_to_non_nullable
as AppError?,selectedIds: null == selectedIds ? _self._selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitError: freezed == submitError ? _self.submitError : submitError // ignore: cast_nullable_to_non_nullable
as AppError?,
  ));
}


}

// dart format on
