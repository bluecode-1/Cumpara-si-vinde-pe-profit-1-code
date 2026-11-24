// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'problem_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProblemDto {

 String get type; String get title; int get status; String get code; String? get detail; Map<String, List<String>>? get errors;
/// Create a copy of ProblemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProblemDtoCopyWith<ProblemDto> get copyWith => _$ProblemDtoCopyWithImpl<ProblemDto>(this as ProblemDto, _$identity);

  /// Serializes this ProblemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProblemDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProblemDto&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.detail, _this.detail) || other.detail == _this.detail)&&const DeepCollectionEquality().equals(other.errors, _this.errors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProblemDto;
  return Object.hash(runtimeType,_this.type,_this.title,_this.status,_this.code,_this.detail,const DeepCollectionEquality().hash(_this.errors));
}

@override
String toString() {
  final _this = this as ProblemDto;
  return 'ProblemDto(type: ${_this.type}, title: ${_this.title}, status: ${_this.status}, code: ${_this.code}, detail: ${_this.detail}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $ProblemDtoCopyWith<$Res>  {
  factory $ProblemDtoCopyWith(ProblemDto value, $Res Function(ProblemDto) _then) = _$ProblemDtoCopyWithImpl;
@useResult
$Res call({
 String type, String title, int status, String code, String? detail, Map<String, List<String>>? errors
});




}
/// @nodoc
class _$ProblemDtoCopyWithImpl<$Res>
    implements $ProblemDtoCopyWith<$Res> {
  _$ProblemDtoCopyWithImpl(this._self, this._then);

  final ProblemDto _self;
  final $Res Function(ProblemDto) _then;

/// Create a copy of ProblemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? title = null,Object? status = null,Object? code = null,Object? detail = freezed,Object? errors = freezed,}) {
  return _then(ProblemDto(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProblemDto].
extension ProblemDtoPatterns on ProblemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProblemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProblemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProblemDto value)  $default,){
final _that = this;
switch (_that) {
case _ProblemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProblemDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProblemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String title,  int status,  String code,  String? detail,  Map<String, List<String>>? errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProblemDto() when $default != null:
return $default(_that.type,_that.title,_that.status,_that.code,_that.detail,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String title,  int status,  String code,  String? detail,  Map<String, List<String>>? errors)  $default,) {final _that = this;
switch (_that) {
case _ProblemDto():
return $default(_that.type,_that.title,_that.status,_that.code,_that.detail,_that.errors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String title,  int status,  String code,  String? detail,  Map<String, List<String>>? errors)?  $default,) {final _that = this;
switch (_that) {
case _ProblemDto() when $default != null:
return $default(_that.type,_that.title,_that.status,_that.code,_that.detail,_that.errors);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProblemDto implements ProblemDto {
  const _ProblemDto({required this.type, required this.title, required this.status, required this.code, this.detail,  Map<String, List<String>>? errors}): _errors = errors;
  factory _ProblemDto.fromJson(Map<String, dynamic> json) => _$ProblemDtoFromJson(json);

@override final  String type;
@override final  String title;
@override final  int status;
@override final  String code;
@override final  String? detail;
 final  Map<String, List<String>>? _errors;
@override Map<String, List<String>>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of ProblemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProblemDtoCopyWith<_ProblemDto> get copyWith => __$ProblemDtoCopyWithImpl<_ProblemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProblemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProblemDto&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.code, code) || other.code == code)&&(identical(other.detail, detail) || other.detail == detail)&&const DeepCollectionEquality().equals(other.errors, _errors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,title,status,code,detail,const DeepCollectionEquality().hash(_errors));
}

@override
String toString() {
    return 'ProblemDto(type: $type, title: $title, status: $status, code: $code, detail: $detail, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$ProblemDtoCopyWith<$Res> implements $ProblemDtoCopyWith<$Res> {
  factory _$ProblemDtoCopyWith(_ProblemDto value, $Res Function(_ProblemDto) _then) = __$ProblemDtoCopyWithImpl;
@override @useResult
$Res call({
 String type, String title, int status, String code, String? detail, Map<String, List<String>>? errors
});




}
/// @nodoc
class __$ProblemDtoCopyWithImpl<$Res>
    implements _$ProblemDtoCopyWith<$Res> {
  __$ProblemDtoCopyWithImpl(this._self, this._then);

  final _ProblemDto _self;
  final $Res Function(_ProblemDto) _then;

/// Create a copy of ProblemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? title = null,Object? status = null,Object? code = null,Object? detail = freezed,Object? errors = freezed,}) {
  return _then(_ProblemDto(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>?,
  ));
}


}

// dart format on
