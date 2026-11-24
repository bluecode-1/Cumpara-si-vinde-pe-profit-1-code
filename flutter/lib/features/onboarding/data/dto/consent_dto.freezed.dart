// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consent_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConsentDto {

@JsonKey(unknownEnumValue: ConsentPurposeDto.unknown) ConsentPurposeDto get purpose; bool get granted; String get policyVersion; DateTime get updatedAt;
/// Create a copy of ConsentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsentDtoCopyWith<ConsentDto> get copyWith => _$ConsentDtoCopyWithImpl<ConsentDto>(this as ConsentDto, _$identity);

  /// Serializes this ConsentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConsentDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsentDto&&(identical(other.purpose, _this.purpose) || other.purpose == _this.purpose)&&(identical(other.granted, _this.granted) || other.granted == _this.granted)&&(identical(other.policyVersion, _this.policyVersion) || other.policyVersion == _this.policyVersion)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConsentDto;
  return Object.hash(runtimeType,_this.purpose,_this.granted,_this.policyVersion,_this.updatedAt);
}

@override
String toString() {
  final _this = this as ConsentDto;
  return 'ConsentDto(purpose: ${_this.purpose}, granted: ${_this.granted}, policyVersion: ${_this.policyVersion}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $ConsentDtoCopyWith<$Res>  {
  factory $ConsentDtoCopyWith(ConsentDto value, $Res Function(ConsentDto) _then) = _$ConsentDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: ConsentPurposeDto.unknown) ConsentPurposeDto purpose, bool granted, String policyVersion, DateTime updatedAt
});




}
/// @nodoc
class _$ConsentDtoCopyWithImpl<$Res>
    implements $ConsentDtoCopyWith<$Res> {
  _$ConsentDtoCopyWithImpl(this._self, this._then);

  final ConsentDto _self;
  final $Res Function(ConsentDto) _then;

/// Create a copy of ConsentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? purpose = null,Object? granted = null,Object? policyVersion = null,Object? updatedAt = null,}) {
  return _then(ConsentDto(
purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as ConsentPurposeDto,granted: null == granted ? _self.granted : granted // ignore: cast_nullable_to_non_nullable
as bool,policyVersion: null == policyVersion ? _self.policyVersion : policyVersion // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsentDto].
extension ConsentDtoPatterns on ConsentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsentDto value)  $default,){
final _that = this;
switch (_that) {
case _ConsentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsentDto value)?  $default,){
final _that = this;
switch (_that) {
case _ConsentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: ConsentPurposeDto.unknown)  ConsentPurposeDto purpose,  bool granted,  String policyVersion,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsentDto() when $default != null:
return $default(_that.purpose,_that.granted,_that.policyVersion,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: ConsentPurposeDto.unknown)  ConsentPurposeDto purpose,  bool granted,  String policyVersion,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ConsentDto():
return $default(_that.purpose,_that.granted,_that.policyVersion,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: ConsentPurposeDto.unknown)  ConsentPurposeDto purpose,  bool granted,  String policyVersion,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ConsentDto() when $default != null:
return $default(_that.purpose,_that.granted,_that.policyVersion,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsentDto implements ConsentDto {
  const _ConsentDto({@JsonKey(unknownEnumValue: ConsentPurposeDto.unknown) required this.purpose, required this.granted, required this.policyVersion, required this.updatedAt});
  factory _ConsentDto.fromJson(Map<String, dynamic> json) => _$ConsentDtoFromJson(json);

@override@JsonKey(unknownEnumValue: ConsentPurposeDto.unknown) final  ConsentPurposeDto purpose;
@override final  bool granted;
@override final  String policyVersion;
@override final  DateTime updatedAt;

/// Create a copy of ConsentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsentDtoCopyWith<_ConsentDto> get copyWith => __$ConsentDtoCopyWithImpl<_ConsentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsentDto&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.granted, granted) || other.granted == granted)&&(identical(other.policyVersion, policyVersion) || other.policyVersion == policyVersion)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,purpose,granted,policyVersion,updatedAt);
}

@override
String toString() {
    return 'ConsentDto(purpose: $purpose, granted: $granted, policyVersion: $policyVersion, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ConsentDtoCopyWith<$Res> implements $ConsentDtoCopyWith<$Res> {
  factory _$ConsentDtoCopyWith(_ConsentDto value, $Res Function(_ConsentDto) _then) = __$ConsentDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: ConsentPurposeDto.unknown) ConsentPurposeDto purpose, bool granted, String policyVersion, DateTime updatedAt
});




}
/// @nodoc
class __$ConsentDtoCopyWithImpl<$Res>
    implements _$ConsentDtoCopyWith<$Res> {
  __$ConsentDtoCopyWithImpl(this._self, this._then);

  final _ConsentDto _self;
  final $Res Function(_ConsentDto) _then;

/// Create a copy of ConsentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? purpose = null,Object? granted = null,Object? policyVersion = null,Object? updatedAt = null,}) {
  return _then(_ConsentDto(
purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as ConsentPurposeDto,granted: null == granted ? _self.granted : granted // ignore: cast_nullable_to_non_nullable
as bool,policyVersion: null == policyVersion ? _self.policyVersion : policyVersion // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ConsentUpdateDto {

 ConsentPurposeDto get purpose; bool get granted; String get policyVersion;
/// Create a copy of ConsentUpdateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsentUpdateDtoCopyWith<ConsentUpdateDto> get copyWith => _$ConsentUpdateDtoCopyWithImpl<ConsentUpdateDto>(this as ConsentUpdateDto, _$identity);

  /// Serializes this ConsentUpdateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConsentUpdateDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsentUpdateDto&&(identical(other.purpose, _this.purpose) || other.purpose == _this.purpose)&&(identical(other.granted, _this.granted) || other.granted == _this.granted)&&(identical(other.policyVersion, _this.policyVersion) || other.policyVersion == _this.policyVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConsentUpdateDto;
  return Object.hash(runtimeType,_this.purpose,_this.granted,_this.policyVersion);
}

@override
String toString() {
  final _this = this as ConsentUpdateDto;
  return 'ConsentUpdateDto(purpose: ${_this.purpose}, granted: ${_this.granted}, policyVersion: ${_this.policyVersion})';
}


}

/// @nodoc
abstract mixin class $ConsentUpdateDtoCopyWith<$Res>  {
  factory $ConsentUpdateDtoCopyWith(ConsentUpdateDto value, $Res Function(ConsentUpdateDto) _then) = _$ConsentUpdateDtoCopyWithImpl;
@useResult
$Res call({
 ConsentPurposeDto purpose, bool granted, String policyVersion
});




}
/// @nodoc
class _$ConsentUpdateDtoCopyWithImpl<$Res>
    implements $ConsentUpdateDtoCopyWith<$Res> {
  _$ConsentUpdateDtoCopyWithImpl(this._self, this._then);

  final ConsentUpdateDto _self;
  final $Res Function(ConsentUpdateDto) _then;

/// Create a copy of ConsentUpdateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? purpose = null,Object? granted = null,Object? policyVersion = null,}) {
  return _then(ConsentUpdateDto(
purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as ConsentPurposeDto,granted: null == granted ? _self.granted : granted // ignore: cast_nullable_to_non_nullable
as bool,policyVersion: null == policyVersion ? _self.policyVersion : policyVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsentUpdateDto].
extension ConsentUpdateDtoPatterns on ConsentUpdateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsentUpdateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsentUpdateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsentUpdateDto value)  $default,){
final _that = this;
switch (_that) {
case _ConsentUpdateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsentUpdateDto value)?  $default,){
final _that = this;
switch (_that) {
case _ConsentUpdateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ConsentPurposeDto purpose,  bool granted,  String policyVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsentUpdateDto() when $default != null:
return $default(_that.purpose,_that.granted,_that.policyVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ConsentPurposeDto purpose,  bool granted,  String policyVersion)  $default,) {final _that = this;
switch (_that) {
case _ConsentUpdateDto():
return $default(_that.purpose,_that.granted,_that.policyVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ConsentPurposeDto purpose,  bool granted,  String policyVersion)?  $default,) {final _that = this;
switch (_that) {
case _ConsentUpdateDto() when $default != null:
return $default(_that.purpose,_that.granted,_that.policyVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsentUpdateDto implements ConsentUpdateDto {
  const _ConsentUpdateDto({required this.purpose, required this.granted, required this.policyVersion});
  factory _ConsentUpdateDto.fromJson(Map<String, dynamic> json) => _$ConsentUpdateDtoFromJson(json);

@override final  ConsentPurposeDto purpose;
@override final  bool granted;
@override final  String policyVersion;

/// Create a copy of ConsentUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsentUpdateDtoCopyWith<_ConsentUpdateDto> get copyWith => __$ConsentUpdateDtoCopyWithImpl<_ConsentUpdateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsentUpdateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsentUpdateDto&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.granted, granted) || other.granted == granted)&&(identical(other.policyVersion, policyVersion) || other.policyVersion == policyVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,purpose,granted,policyVersion);
}

@override
String toString() {
    return 'ConsentUpdateDto(purpose: $purpose, granted: $granted, policyVersion: $policyVersion)';
}


}

/// @nodoc
abstract mixin class _$ConsentUpdateDtoCopyWith<$Res> implements $ConsentUpdateDtoCopyWith<$Res> {
  factory _$ConsentUpdateDtoCopyWith(_ConsentUpdateDto value, $Res Function(_ConsentUpdateDto) _then) = __$ConsentUpdateDtoCopyWithImpl;
@override @useResult
$Res call({
 ConsentPurposeDto purpose, bool granted, String policyVersion
});




}
/// @nodoc
class __$ConsentUpdateDtoCopyWithImpl<$Res>
    implements _$ConsentUpdateDtoCopyWith<$Res> {
  __$ConsentUpdateDtoCopyWithImpl(this._self, this._then);

  final _ConsentUpdateDto _self;
  final $Res Function(_ConsentUpdateDto) _then;

/// Create a copy of ConsentUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? purpose = null,Object? granted = null,Object? policyVersion = null,}) {
  return _then(_ConsentUpdateDto(
purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as ConsentPurposeDto,granted: null == granted ? _self.granted : granted // ignore: cast_nullable_to_non_nullable
as bool,policyVersion: null == policyVersion ? _self.policyVersion : policyVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
