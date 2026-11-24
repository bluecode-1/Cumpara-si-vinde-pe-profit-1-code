// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'me_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BadgeDto {

@JsonKey(unknownEnumValue: ReputationAttributeDto.unknown) ReputationAttributeDto get attribute; int get confirmations;
/// Create a copy of BadgeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadgeDtoCopyWith<BadgeDto> get copyWith => _$BadgeDtoCopyWithImpl<BadgeDto>(this as BadgeDto, _$identity);

  /// Serializes this BadgeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BadgeDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadgeDto&&(identical(other.attribute, _this.attribute) || other.attribute == _this.attribute)&&(identical(other.confirmations, _this.confirmations) || other.confirmations == _this.confirmations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BadgeDto;
  return Object.hash(runtimeType,_this.attribute,_this.confirmations);
}

@override
String toString() {
  final _this = this as BadgeDto;
  return 'BadgeDto(attribute: ${_this.attribute}, confirmations: ${_this.confirmations})';
}


}

/// @nodoc
abstract mixin class $BadgeDtoCopyWith<$Res>  {
  factory $BadgeDtoCopyWith(BadgeDto value, $Res Function(BadgeDto) _then) = _$BadgeDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: ReputationAttributeDto.unknown) ReputationAttributeDto attribute, int confirmations
});




}
/// @nodoc
class _$BadgeDtoCopyWithImpl<$Res>
    implements $BadgeDtoCopyWith<$Res> {
  _$BadgeDtoCopyWithImpl(this._self, this._then);

  final BadgeDto _self;
  final $Res Function(BadgeDto) _then;

/// Create a copy of BadgeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attribute = null,Object? confirmations = null,}) {
  return _then(BadgeDto(
attribute: null == attribute ? _self.attribute : attribute // ignore: cast_nullable_to_non_nullable
as ReputationAttributeDto,confirmations: null == confirmations ? _self.confirmations : confirmations // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BadgeDto].
extension BadgeDtoPatterns on BadgeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BadgeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BadgeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BadgeDto value)  $default,){
final _that = this;
switch (_that) {
case _BadgeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BadgeDto value)?  $default,){
final _that = this;
switch (_that) {
case _BadgeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: ReputationAttributeDto.unknown)  ReputationAttributeDto attribute,  int confirmations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BadgeDto() when $default != null:
return $default(_that.attribute,_that.confirmations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: ReputationAttributeDto.unknown)  ReputationAttributeDto attribute,  int confirmations)  $default,) {final _that = this;
switch (_that) {
case _BadgeDto():
return $default(_that.attribute,_that.confirmations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: ReputationAttributeDto.unknown)  ReputationAttributeDto attribute,  int confirmations)?  $default,) {final _that = this;
switch (_that) {
case _BadgeDto() when $default != null:
return $default(_that.attribute,_that.confirmations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BadgeDto implements BadgeDto {
  const _BadgeDto({@JsonKey(unknownEnumValue: ReputationAttributeDto.unknown) required this.attribute, required this.confirmations});
  factory _BadgeDto.fromJson(Map<String, dynamic> json) => _$BadgeDtoFromJson(json);

@override@JsonKey(unknownEnumValue: ReputationAttributeDto.unknown) final  ReputationAttributeDto attribute;
@override final  int confirmations;

/// Create a copy of BadgeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BadgeDtoCopyWith<_BadgeDto> get copyWith => __$BadgeDtoCopyWithImpl<_BadgeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BadgeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BadgeDto&&(identical(other.attribute, attribute) || other.attribute == attribute)&&(identical(other.confirmations, confirmations) || other.confirmations == confirmations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,attribute,confirmations);
}

@override
String toString() {
    return 'BadgeDto(attribute: $attribute, confirmations: $confirmations)';
}


}

/// @nodoc
abstract mixin class _$BadgeDtoCopyWith<$Res> implements $BadgeDtoCopyWith<$Res> {
  factory _$BadgeDtoCopyWith(_BadgeDto value, $Res Function(_BadgeDto) _then) = __$BadgeDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: ReputationAttributeDto.unknown) ReputationAttributeDto attribute, int confirmations
});




}
/// @nodoc
class __$BadgeDtoCopyWithImpl<$Res>
    implements _$BadgeDtoCopyWith<$Res> {
  __$BadgeDtoCopyWithImpl(this._self, this._then);

  final _BadgeDto _self;
  final $Res Function(_BadgeDto) _then;

/// Create a copy of BadgeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attribute = null,Object? confirmations = null,}) {
  return _then(_BadgeDto(
attribute: null == attribute ? _self.attribute : attribute // ignore: cast_nullable_to_non_nullable
as ReputationAttributeDto,confirmations: null == confirmations ? _self.confirmations : confirmations // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TraderInfoDto {

 String? get legalName; String? get registrationNumber; String? get address; String? get contactEmail;
/// Create a copy of TraderInfoDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TraderInfoDtoCopyWith<TraderInfoDto> get copyWith => _$TraderInfoDtoCopyWithImpl<TraderInfoDto>(this as TraderInfoDto, _$identity);

  /// Serializes this TraderInfoDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TraderInfoDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TraderInfoDto&&(identical(other.legalName, _this.legalName) || other.legalName == _this.legalName)&&(identical(other.registrationNumber, _this.registrationNumber) || other.registrationNumber == _this.registrationNumber)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.contactEmail, _this.contactEmail) || other.contactEmail == _this.contactEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TraderInfoDto;
  return Object.hash(runtimeType,_this.legalName,_this.registrationNumber,_this.address,_this.contactEmail);
}

@override
String toString() {
  final _this = this as TraderInfoDto;
  return 'TraderInfoDto(legalName: ${_this.legalName}, registrationNumber: ${_this.registrationNumber}, address: ${_this.address}, contactEmail: ${_this.contactEmail})';
}


}

/// @nodoc
abstract mixin class $TraderInfoDtoCopyWith<$Res>  {
  factory $TraderInfoDtoCopyWith(TraderInfoDto value, $Res Function(TraderInfoDto) _then) = _$TraderInfoDtoCopyWithImpl;
@useResult
$Res call({
 String? legalName, String? registrationNumber, String? address, String? contactEmail
});




}
/// @nodoc
class _$TraderInfoDtoCopyWithImpl<$Res>
    implements $TraderInfoDtoCopyWith<$Res> {
  _$TraderInfoDtoCopyWithImpl(this._self, this._then);

  final TraderInfoDto _self;
  final $Res Function(TraderInfoDto) _then;

/// Create a copy of TraderInfoDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? legalName = freezed,Object? registrationNumber = freezed,Object? address = freezed,Object? contactEmail = freezed,}) {
  return _then(TraderInfoDto(
legalName: freezed == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String?,registrationNumber: freezed == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TraderInfoDto].
extension TraderInfoDtoPatterns on TraderInfoDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TraderInfoDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TraderInfoDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TraderInfoDto value)  $default,){
final _that = this;
switch (_that) {
case _TraderInfoDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TraderInfoDto value)?  $default,){
final _that = this;
switch (_that) {
case _TraderInfoDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? legalName,  String? registrationNumber,  String? address,  String? contactEmail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TraderInfoDto() when $default != null:
return $default(_that.legalName,_that.registrationNumber,_that.address,_that.contactEmail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? legalName,  String? registrationNumber,  String? address,  String? contactEmail)  $default,) {final _that = this;
switch (_that) {
case _TraderInfoDto():
return $default(_that.legalName,_that.registrationNumber,_that.address,_that.contactEmail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? legalName,  String? registrationNumber,  String? address,  String? contactEmail)?  $default,) {final _that = this;
switch (_that) {
case _TraderInfoDto() when $default != null:
return $default(_that.legalName,_that.registrationNumber,_that.address,_that.contactEmail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TraderInfoDto implements TraderInfoDto {
  const _TraderInfoDto({this.legalName, this.registrationNumber, this.address, this.contactEmail});
  factory _TraderInfoDto.fromJson(Map<String, dynamic> json) => _$TraderInfoDtoFromJson(json);

@override final  String? legalName;
@override final  String? registrationNumber;
@override final  String? address;
@override final  String? contactEmail;

/// Create a copy of TraderInfoDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TraderInfoDtoCopyWith<_TraderInfoDto> get copyWith => __$TraderInfoDtoCopyWithImpl<_TraderInfoDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TraderInfoDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TraderInfoDto&&(identical(other.legalName, legalName) || other.legalName == legalName)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.address, address) || other.address == address)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,legalName,registrationNumber,address,contactEmail);
}

@override
String toString() {
    return 'TraderInfoDto(legalName: $legalName, registrationNumber: $registrationNumber, address: $address, contactEmail: $contactEmail)';
}


}

/// @nodoc
abstract mixin class _$TraderInfoDtoCopyWith<$Res> implements $TraderInfoDtoCopyWith<$Res> {
  factory _$TraderInfoDtoCopyWith(_TraderInfoDto value, $Res Function(_TraderInfoDto) _then) = __$TraderInfoDtoCopyWithImpl;
@override @useResult
$Res call({
 String? legalName, String? registrationNumber, String? address, String? contactEmail
});




}
/// @nodoc
class __$TraderInfoDtoCopyWithImpl<$Res>
    implements _$TraderInfoDtoCopyWith<$Res> {
  __$TraderInfoDtoCopyWithImpl(this._self, this._then);

  final _TraderInfoDto _self;
  final $Res Function(_TraderInfoDto) _then;

/// Create a copy of TraderInfoDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? legalName = freezed,Object? registrationNumber = freezed,Object? address = freezed,Object? contactEmail = freezed,}) {
  return _then(_TraderInfoDto(
legalName: freezed == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String?,registrationNumber: freezed == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AccountLimitsDto {

 Money get maxTransaction; Money get monthlyVolume;
/// Create a copy of AccountLimitsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountLimitsDtoCopyWith<AccountLimitsDto> get copyWith => _$AccountLimitsDtoCopyWithImpl<AccountLimitsDto>(this as AccountLimitsDto, _$identity);

  /// Serializes this AccountLimitsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AccountLimitsDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountLimitsDto&&(identical(other.maxTransaction, _this.maxTransaction) || other.maxTransaction == _this.maxTransaction)&&(identical(other.monthlyVolume, _this.monthlyVolume) || other.monthlyVolume == _this.monthlyVolume));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AccountLimitsDto;
  return Object.hash(runtimeType,_this.maxTransaction,_this.monthlyVolume);
}

@override
String toString() {
  final _this = this as AccountLimitsDto;
  return 'AccountLimitsDto(maxTransaction: ${_this.maxTransaction}, monthlyVolume: ${_this.monthlyVolume})';
}


}

/// @nodoc
abstract mixin class $AccountLimitsDtoCopyWith<$Res>  {
  factory $AccountLimitsDtoCopyWith(AccountLimitsDto value, $Res Function(AccountLimitsDto) _then) = _$AccountLimitsDtoCopyWithImpl;
@useResult
$Res call({
 Money maxTransaction, Money monthlyVolume
});


$MoneyCopyWith<$Res> get maxTransaction;$MoneyCopyWith<$Res> get monthlyVolume;

}
/// @nodoc
class _$AccountLimitsDtoCopyWithImpl<$Res>
    implements $AccountLimitsDtoCopyWith<$Res> {
  _$AccountLimitsDtoCopyWithImpl(this._self, this._then);

  final AccountLimitsDto _self;
  final $Res Function(AccountLimitsDto) _then;

/// Create a copy of AccountLimitsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? maxTransaction = null,Object? monthlyVolume = null,}) {
  return _then(AccountLimitsDto(
maxTransaction: null == maxTransaction ? _self.maxTransaction : maxTransaction // ignore: cast_nullable_to_non_nullable
as Money,monthlyVolume: null == monthlyVolume ? _self.monthlyVolume : monthlyVolume // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}
/// Create a copy of AccountLimitsDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get maxTransaction {
  
  return $MoneyCopyWith<$Res>(_self.maxTransaction, (value) {
    return _then(_self.copyWith(maxTransaction: value));
  });
}/// Create a copy of AccountLimitsDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get monthlyVolume {
  
  return $MoneyCopyWith<$Res>(_self.monthlyVolume, (value) {
    return _then(_self.copyWith(monthlyVolume: value));
  });
}
}


/// Adds pattern-matching-related methods to [AccountLimitsDto].
extension AccountLimitsDtoPatterns on AccountLimitsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountLimitsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountLimitsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountLimitsDto value)  $default,){
final _that = this;
switch (_that) {
case _AccountLimitsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountLimitsDto value)?  $default,){
final _that = this;
switch (_that) {
case _AccountLimitsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Money maxTransaction,  Money monthlyVolume)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountLimitsDto() when $default != null:
return $default(_that.maxTransaction,_that.monthlyVolume);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Money maxTransaction,  Money monthlyVolume)  $default,) {final _that = this;
switch (_that) {
case _AccountLimitsDto():
return $default(_that.maxTransaction,_that.monthlyVolume);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Money maxTransaction,  Money monthlyVolume)?  $default,) {final _that = this;
switch (_that) {
case _AccountLimitsDto() when $default != null:
return $default(_that.maxTransaction,_that.monthlyVolume);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountLimitsDto implements AccountLimitsDto {
  const _AccountLimitsDto({required this.maxTransaction, required this.monthlyVolume});
  factory _AccountLimitsDto.fromJson(Map<String, dynamic> json) => _$AccountLimitsDtoFromJson(json);

@override final  Money maxTransaction;
@override final  Money monthlyVolume;

/// Create a copy of AccountLimitsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountLimitsDtoCopyWith<_AccountLimitsDto> get copyWith => __$AccountLimitsDtoCopyWithImpl<_AccountLimitsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountLimitsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountLimitsDto&&(identical(other.maxTransaction, maxTransaction) || other.maxTransaction == maxTransaction)&&(identical(other.monthlyVolume, monthlyVolume) || other.monthlyVolume == monthlyVolume));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,maxTransaction,monthlyVolume);
}

@override
String toString() {
    return 'AccountLimitsDto(maxTransaction: $maxTransaction, monthlyVolume: $monthlyVolume)';
}


}

/// @nodoc
abstract mixin class _$AccountLimitsDtoCopyWith<$Res> implements $AccountLimitsDtoCopyWith<$Res> {
  factory _$AccountLimitsDtoCopyWith(_AccountLimitsDto value, $Res Function(_AccountLimitsDto) _then) = __$AccountLimitsDtoCopyWithImpl;
@override @useResult
$Res call({
 Money maxTransaction, Money monthlyVolume
});


@override $MoneyCopyWith<$Res> get maxTransaction;@override $MoneyCopyWith<$Res> get monthlyVolume;

}
/// @nodoc
class __$AccountLimitsDtoCopyWithImpl<$Res>
    implements _$AccountLimitsDtoCopyWith<$Res> {
  __$AccountLimitsDtoCopyWithImpl(this._self, this._then);

  final _AccountLimitsDto _self;
  final $Res Function(_AccountLimitsDto) _then;

/// Create a copy of AccountLimitsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? maxTransaction = null,Object? monthlyVolume = null,}) {
  return _then(_AccountLimitsDto(
maxTransaction: null == maxTransaction ? _self.maxTransaction : maxTransaction // ignore: cast_nullable_to_non_nullable
as Money,monthlyVolume: null == monthlyVolume ? _self.monthlyVolume : monthlyVolume // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}

/// Create a copy of AccountLimitsDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get maxTransaction {
  
  return $MoneyCopyWith<$Res>(_self.maxTransaction, (value) {
    return _then(_self.copyWith(maxTransaction: value));
  });
}/// Create a copy of AccountLimitsDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get monthlyVolume {
  
  return $MoneyCopyWith<$Res>(_self.monthlyVolume, (value) {
    return _then(_self.copyWith(monthlyVolume: value));
  });
}
}


/// @nodoc
mixin _$MeDto {

 String get id; String get displayName;@JsonKey(unknownEnumValue: VerificationTierDto.unknown) VerificationTierDto get verificationTier;@JsonKey(unknownEnumValue: SellerTypeDto.unknown) SellerTypeDto get sellerType; List<BadgeDto> get badges; DateTime get memberSince; String get phone; String get locale; Currency get currency; AccountLimitsDto get limits; String? get avatarUrl; String? get city; int get completedTransactions; TraderInfoDto? get traderInfo; String? get email; bool get emailVerified; GeoPoint? get homeLocation; bool get onboardingCompleted;
/// Create a copy of MeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeDtoCopyWith<MeDto> get copyWith => _$MeDtoCopyWithImpl<MeDto>(this as MeDto, _$identity);

  /// Serializes this MeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.verificationTier, _this.verificationTier) || other.verificationTier == _this.verificationTier)&&(identical(other.sellerType, _this.sellerType) || other.sellerType == _this.sellerType)&&const DeepCollectionEquality().equals(other.badges, _this.badges)&&(identical(other.memberSince, _this.memberSince) || other.memberSince == _this.memberSince)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.locale, _this.locale) || other.locale == _this.locale)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.limits, _this.limits) || other.limits == _this.limits)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.completedTransactions, _this.completedTransactions) || other.completedTransactions == _this.completedTransactions)&&(identical(other.traderInfo, _this.traderInfo) || other.traderInfo == _this.traderInfo)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.emailVerified, _this.emailVerified) || other.emailVerified == _this.emailVerified)&&(identical(other.homeLocation, _this.homeLocation) || other.homeLocation == _this.homeLocation)&&(identical(other.onboardingCompleted, _this.onboardingCompleted) || other.onboardingCompleted == _this.onboardingCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeDto;
  return Object.hash(runtimeType,_this.id,_this.displayName,_this.verificationTier,_this.sellerType,const DeepCollectionEquality().hash(_this.badges),_this.memberSince,_this.phone,_this.locale,_this.currency,_this.limits,_this.avatarUrl,_this.city,_this.completedTransactions,_this.traderInfo,_this.email,_this.emailVerified,_this.homeLocation,_this.onboardingCompleted);
}

@override
String toString() {
  final _this = this as MeDto;
  return 'MeDto(id: ${_this.id}, displayName: ${_this.displayName}, verificationTier: ${_this.verificationTier}, sellerType: ${_this.sellerType}, badges: ${_this.badges}, memberSince: ${_this.memberSince}, phone: ${_this.phone}, locale: ${_this.locale}, currency: ${_this.currency}, limits: ${_this.limits}, avatarUrl: ${_this.avatarUrl}, city: ${_this.city}, completedTransactions: ${_this.completedTransactions}, traderInfo: ${_this.traderInfo}, email: ${_this.email}, emailVerified: ${_this.emailVerified}, homeLocation: ${_this.homeLocation}, onboardingCompleted: ${_this.onboardingCompleted})';
}


}

/// @nodoc
abstract mixin class $MeDtoCopyWith<$Res>  {
  factory $MeDtoCopyWith(MeDto value, $Res Function(MeDto) _then) = _$MeDtoCopyWithImpl;
@useResult
$Res call({
 String id, String displayName,@JsonKey(unknownEnumValue: VerificationTierDto.unknown) VerificationTierDto verificationTier,@JsonKey(unknownEnumValue: SellerTypeDto.unknown) SellerTypeDto sellerType, List<BadgeDto> badges, DateTime memberSince, String phone, String locale, Currency currency, AccountLimitsDto limits, String? avatarUrl, String? city, int completedTransactions, TraderInfoDto? traderInfo, String? email, bool emailVerified, GeoPoint? homeLocation, bool onboardingCompleted
});


$AccountLimitsDtoCopyWith<$Res> get limits;$TraderInfoDtoCopyWith<$Res>? get traderInfo;$GeoPointCopyWith<$Res>? get homeLocation;

}
/// @nodoc
class _$MeDtoCopyWithImpl<$Res>
    implements $MeDtoCopyWith<$Res> {
  _$MeDtoCopyWithImpl(this._self, this._then);

  final MeDto _self;
  final $Res Function(MeDto) _then;

/// Create a copy of MeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? verificationTier = null,Object? sellerType = null,Object? badges = null,Object? memberSince = null,Object? phone = null,Object? locale = null,Object? currency = null,Object? limits = null,Object? avatarUrl = freezed,Object? city = freezed,Object? completedTransactions = null,Object? traderInfo = freezed,Object? email = freezed,Object? emailVerified = null,Object? homeLocation = freezed,Object? onboardingCompleted = null,}) {
  return _then(MeDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,verificationTier: null == verificationTier ? _self.verificationTier : verificationTier // ignore: cast_nullable_to_non_nullable
as VerificationTierDto,sellerType: null == sellerType ? _self.sellerType : sellerType // ignore: cast_nullable_to_non_nullable
as SellerTypeDto,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<BadgeDto>,memberSince: null == memberSince ? _self.memberSince : memberSince // ignore: cast_nullable_to_non_nullable
as DateTime,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,limits: null == limits ? _self.limits : limits // ignore: cast_nullable_to_non_nullable
as AccountLimitsDto,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,completedTransactions: null == completedTransactions ? _self.completedTransactions : completedTransactions // ignore: cast_nullable_to_non_nullable
as int,traderInfo: freezed == traderInfo ? _self.traderInfo : traderInfo // ignore: cast_nullable_to_non_nullable
as TraderInfoDto?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,homeLocation: freezed == homeLocation ? _self.homeLocation : homeLocation // ignore: cast_nullable_to_non_nullable
as GeoPoint?,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of MeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountLimitsDtoCopyWith<$Res> get limits {
  
  return $AccountLimitsDtoCopyWith<$Res>(_self.limits, (value) {
    return _then(_self.copyWith(limits: value));
  });
}/// Create a copy of MeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TraderInfoDtoCopyWith<$Res>? get traderInfo {
    if (_self.traderInfo == null) {
    return null;
  }

  return $TraderInfoDtoCopyWith<$Res>(_self.traderInfo!, (value) {
    return _then(_self.copyWith(traderInfo: value));
  });
}/// Create a copy of MeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res>? get homeLocation {
    if (_self.homeLocation == null) {
    return null;
  }

  return $GeoPointCopyWith<$Res>(_self.homeLocation!, (value) {
    return _then(_self.copyWith(homeLocation: value));
  });
}
}


/// Adds pattern-matching-related methods to [MeDto].
extension MeDtoPatterns on MeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeDto value)  $default,){
final _that = this;
switch (_that) {
case _MeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeDto value)?  $default,){
final _that = this;
switch (_that) {
case _MeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String displayName, @JsonKey(unknownEnumValue: VerificationTierDto.unknown)  VerificationTierDto verificationTier, @JsonKey(unknownEnumValue: SellerTypeDto.unknown)  SellerTypeDto sellerType,  List<BadgeDto> badges,  DateTime memberSince,  String phone,  String locale,  Currency currency,  AccountLimitsDto limits,  String? avatarUrl,  String? city,  int completedTransactions,  TraderInfoDto? traderInfo,  String? email,  bool emailVerified,  GeoPoint? homeLocation,  bool onboardingCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeDto() when $default != null:
return $default(_that.id,_that.displayName,_that.verificationTier,_that.sellerType,_that.badges,_that.memberSince,_that.phone,_that.locale,_that.currency,_that.limits,_that.avatarUrl,_that.city,_that.completedTransactions,_that.traderInfo,_that.email,_that.emailVerified,_that.homeLocation,_that.onboardingCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String displayName, @JsonKey(unknownEnumValue: VerificationTierDto.unknown)  VerificationTierDto verificationTier, @JsonKey(unknownEnumValue: SellerTypeDto.unknown)  SellerTypeDto sellerType,  List<BadgeDto> badges,  DateTime memberSince,  String phone,  String locale,  Currency currency,  AccountLimitsDto limits,  String? avatarUrl,  String? city,  int completedTransactions,  TraderInfoDto? traderInfo,  String? email,  bool emailVerified,  GeoPoint? homeLocation,  bool onboardingCompleted)  $default,) {final _that = this;
switch (_that) {
case _MeDto():
return $default(_that.id,_that.displayName,_that.verificationTier,_that.sellerType,_that.badges,_that.memberSince,_that.phone,_that.locale,_that.currency,_that.limits,_that.avatarUrl,_that.city,_that.completedTransactions,_that.traderInfo,_that.email,_that.emailVerified,_that.homeLocation,_that.onboardingCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String displayName, @JsonKey(unknownEnumValue: VerificationTierDto.unknown)  VerificationTierDto verificationTier, @JsonKey(unknownEnumValue: SellerTypeDto.unknown)  SellerTypeDto sellerType,  List<BadgeDto> badges,  DateTime memberSince,  String phone,  String locale,  Currency currency,  AccountLimitsDto limits,  String? avatarUrl,  String? city,  int completedTransactions,  TraderInfoDto? traderInfo,  String? email,  bool emailVerified,  GeoPoint? homeLocation,  bool onboardingCompleted)?  $default,) {final _that = this;
switch (_that) {
case _MeDto() when $default != null:
return $default(_that.id,_that.displayName,_that.verificationTier,_that.sellerType,_that.badges,_that.memberSince,_that.phone,_that.locale,_that.currency,_that.limits,_that.avatarUrl,_that.city,_that.completedTransactions,_that.traderInfo,_that.email,_that.emailVerified,_that.homeLocation,_that.onboardingCompleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeDto implements MeDto {
  const _MeDto({required this.id, required this.displayName, @JsonKey(unknownEnumValue: VerificationTierDto.unknown) required this.verificationTier, @JsonKey(unknownEnumValue: SellerTypeDto.unknown) required this.sellerType, required  List<BadgeDto> badges, required this.memberSince, required this.phone, required this.locale, required this.currency, required this.limits, this.avatarUrl, this.city, this.completedTransactions = 0, this.traderInfo, this.email, this.emailVerified = false, this.homeLocation, this.onboardingCompleted = false}): _badges = badges;
  factory _MeDto.fromJson(Map<String, dynamic> json) => _$MeDtoFromJson(json);

@override final  String id;
@override final  String displayName;
@override@JsonKey(unknownEnumValue: VerificationTierDto.unknown) final  VerificationTierDto verificationTier;
@override@JsonKey(unknownEnumValue: SellerTypeDto.unknown) final  SellerTypeDto sellerType;
 final  List<BadgeDto> _badges;
@override List<BadgeDto> get badges {
  if (_badges is EqualUnmodifiableListView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_badges);
}

@override final  DateTime memberSince;
@override final  String phone;
@override final  String locale;
@override final  Currency currency;
@override final  AccountLimitsDto limits;
@override final  String? avatarUrl;
@override final  String? city;
@override@JsonKey() final  int completedTransactions;
@override final  TraderInfoDto? traderInfo;
@override final  String? email;
@override@JsonKey() final  bool emailVerified;
@override final  GeoPoint? homeLocation;
@override@JsonKey() final  bool onboardingCompleted;

/// Create a copy of MeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeDtoCopyWith<_MeDto> get copyWith => __$MeDtoCopyWithImpl<_MeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeDto&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.verificationTier, verificationTier) || other.verificationTier == verificationTier)&&(identical(other.sellerType, sellerType) || other.sellerType == sellerType)&&const DeepCollectionEquality().equals(other.badges, _badges)&&(identical(other.memberSince, memberSince) || other.memberSince == memberSince)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.limits, limits) || other.limits == limits)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.city, city) || other.city == city)&&(identical(other.completedTransactions, completedTransactions) || other.completedTransactions == completedTransactions)&&(identical(other.traderInfo, traderInfo) || other.traderInfo == traderInfo)&&(identical(other.email, email) || other.email == email)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.homeLocation, homeLocation) || other.homeLocation == homeLocation)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,displayName,verificationTier,sellerType,const DeepCollectionEquality().hash(_badges),memberSince,phone,locale,currency,limits,avatarUrl,city,completedTransactions,traderInfo,email,emailVerified,homeLocation,onboardingCompleted);
}

@override
String toString() {
    return 'MeDto(id: $id, displayName: $displayName, verificationTier: $verificationTier, sellerType: $sellerType, badges: $badges, memberSince: $memberSince, phone: $phone, locale: $locale, currency: $currency, limits: $limits, avatarUrl: $avatarUrl, city: $city, completedTransactions: $completedTransactions, traderInfo: $traderInfo, email: $email, emailVerified: $emailVerified, homeLocation: $homeLocation, onboardingCompleted: $onboardingCompleted)';
}


}

/// @nodoc
abstract mixin class _$MeDtoCopyWith<$Res> implements $MeDtoCopyWith<$Res> {
  factory _$MeDtoCopyWith(_MeDto value, $Res Function(_MeDto) _then) = __$MeDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName,@JsonKey(unknownEnumValue: VerificationTierDto.unknown) VerificationTierDto verificationTier,@JsonKey(unknownEnumValue: SellerTypeDto.unknown) SellerTypeDto sellerType, List<BadgeDto> badges, DateTime memberSince, String phone, String locale, Currency currency, AccountLimitsDto limits, String? avatarUrl, String? city, int completedTransactions, TraderInfoDto? traderInfo, String? email, bool emailVerified, GeoPoint? homeLocation, bool onboardingCompleted
});


@override $AccountLimitsDtoCopyWith<$Res> get limits;@override $TraderInfoDtoCopyWith<$Res>? get traderInfo;@override $GeoPointCopyWith<$Res>? get homeLocation;

}
/// @nodoc
class __$MeDtoCopyWithImpl<$Res>
    implements _$MeDtoCopyWith<$Res> {
  __$MeDtoCopyWithImpl(this._self, this._then);

  final _MeDto _self;
  final $Res Function(_MeDto) _then;

/// Create a copy of MeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? verificationTier = null,Object? sellerType = null,Object? badges = null,Object? memberSince = null,Object? phone = null,Object? locale = null,Object? currency = null,Object? limits = null,Object? avatarUrl = freezed,Object? city = freezed,Object? completedTransactions = null,Object? traderInfo = freezed,Object? email = freezed,Object? emailVerified = null,Object? homeLocation = freezed,Object? onboardingCompleted = null,}) {
  return _then(_MeDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,verificationTier: null == verificationTier ? _self.verificationTier : verificationTier // ignore: cast_nullable_to_non_nullable
as VerificationTierDto,sellerType: null == sellerType ? _self.sellerType : sellerType // ignore: cast_nullable_to_non_nullable
as SellerTypeDto,badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as List<BadgeDto>,memberSince: null == memberSince ? _self.memberSince : memberSince // ignore: cast_nullable_to_non_nullable
as DateTime,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,limits: null == limits ? _self.limits : limits // ignore: cast_nullable_to_non_nullable
as AccountLimitsDto,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,completedTransactions: null == completedTransactions ? _self.completedTransactions : completedTransactions // ignore: cast_nullable_to_non_nullable
as int,traderInfo: freezed == traderInfo ? _self.traderInfo : traderInfo // ignore: cast_nullable_to_non_nullable
as TraderInfoDto?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,homeLocation: freezed == homeLocation ? _self.homeLocation : homeLocation // ignore: cast_nullable_to_non_nullable
as GeoPoint?,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountLimitsDtoCopyWith<$Res> get limits {
  
  return $AccountLimitsDtoCopyWith<$Res>(_self.limits, (value) {
    return _then(_self.copyWith(limits: value));
  });
}/// Create a copy of MeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TraderInfoDtoCopyWith<$Res>? get traderInfo {
    if (_self.traderInfo == null) {
    return null;
  }

  return $TraderInfoDtoCopyWith<$Res>(_self.traderInfo!, (value) {
    return _then(_self.copyWith(traderInfo: value));
  });
}/// Create a copy of MeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res>? get homeLocation {
    if (_self.homeLocation == null) {
    return null;
  }

  return $GeoPointCopyWith<$Res>(_self.homeLocation!, (value) {
    return _then(_self.copyWith(homeLocation: value));
  });
}
}


/// @nodoc
mixin _$MeUpdateDto {

 String? get displayName; GeoPoint? get homeLocation; List<String>? get interestCategoryIds; bool? get onboardingCompleted;
/// Create a copy of MeUpdateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeUpdateDtoCopyWith<MeUpdateDto> get copyWith => _$MeUpdateDtoCopyWithImpl<MeUpdateDto>(this as MeUpdateDto, _$identity);

  /// Serializes this MeUpdateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeUpdateDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeUpdateDto&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.homeLocation, _this.homeLocation) || other.homeLocation == _this.homeLocation)&&const DeepCollectionEquality().equals(other.interestCategoryIds, _this.interestCategoryIds)&&(identical(other.onboardingCompleted, _this.onboardingCompleted) || other.onboardingCompleted == _this.onboardingCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeUpdateDto;
  return Object.hash(runtimeType,_this.displayName,_this.homeLocation,const DeepCollectionEquality().hash(_this.interestCategoryIds),_this.onboardingCompleted);
}

@override
String toString() {
  final _this = this as MeUpdateDto;
  return 'MeUpdateDto(displayName: ${_this.displayName}, homeLocation: ${_this.homeLocation}, interestCategoryIds: ${_this.interestCategoryIds}, onboardingCompleted: ${_this.onboardingCompleted})';
}


}

/// @nodoc
abstract mixin class $MeUpdateDtoCopyWith<$Res>  {
  factory $MeUpdateDtoCopyWith(MeUpdateDto value, $Res Function(MeUpdateDto) _then) = _$MeUpdateDtoCopyWithImpl;
@useResult
$Res call({
 String? displayName, GeoPoint? homeLocation, List<String>? interestCategoryIds, bool? onboardingCompleted
});


$GeoPointCopyWith<$Res>? get homeLocation;

}
/// @nodoc
class _$MeUpdateDtoCopyWithImpl<$Res>
    implements $MeUpdateDtoCopyWith<$Res> {
  _$MeUpdateDtoCopyWithImpl(this._self, this._then);

  final MeUpdateDto _self;
  final $Res Function(MeUpdateDto) _then;

/// Create a copy of MeUpdateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = freezed,Object? homeLocation = freezed,Object? interestCategoryIds = freezed,Object? onboardingCompleted = freezed,}) {
  return _then(MeUpdateDto(
displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,homeLocation: freezed == homeLocation ? _self.homeLocation : homeLocation // ignore: cast_nullable_to_non_nullable
as GeoPoint?,interestCategoryIds: freezed == interestCategoryIds ? _self.interestCategoryIds : interestCategoryIds // ignore: cast_nullable_to_non_nullable
as List<String>?,onboardingCompleted: freezed == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}
/// Create a copy of MeUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res>? get homeLocation {
    if (_self.homeLocation == null) {
    return null;
  }

  return $GeoPointCopyWith<$Res>(_self.homeLocation!, (value) {
    return _then(_self.copyWith(homeLocation: value));
  });
}
}


/// Adds pattern-matching-related methods to [MeUpdateDto].
extension MeUpdateDtoPatterns on MeUpdateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeUpdateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeUpdateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeUpdateDto value)  $default,){
final _that = this;
switch (_that) {
case _MeUpdateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeUpdateDto value)?  $default,){
final _that = this;
switch (_that) {
case _MeUpdateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? displayName,  GeoPoint? homeLocation,  List<String>? interestCategoryIds,  bool? onboardingCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeUpdateDto() when $default != null:
return $default(_that.displayName,_that.homeLocation,_that.interestCategoryIds,_that.onboardingCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? displayName,  GeoPoint? homeLocation,  List<String>? interestCategoryIds,  bool? onboardingCompleted)  $default,) {final _that = this;
switch (_that) {
case _MeUpdateDto():
return $default(_that.displayName,_that.homeLocation,_that.interestCategoryIds,_that.onboardingCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? displayName,  GeoPoint? homeLocation,  List<String>? interestCategoryIds,  bool? onboardingCompleted)?  $default,) {final _that = this;
switch (_that) {
case _MeUpdateDto() when $default != null:
return $default(_that.displayName,_that.homeLocation,_that.interestCategoryIds,_that.onboardingCompleted);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _MeUpdateDto implements MeUpdateDto {
  const _MeUpdateDto({this.displayName, this.homeLocation,  List<String>? interestCategoryIds, this.onboardingCompleted}): _interestCategoryIds = interestCategoryIds;
  factory _MeUpdateDto.fromJson(Map<String, dynamic> json) => _$MeUpdateDtoFromJson(json);

@override final  String? displayName;
@override final  GeoPoint? homeLocation;
 final  List<String>? _interestCategoryIds;
@override List<String>? get interestCategoryIds {
  final value = _interestCategoryIds;
  if (value == null) return null;
  if (_interestCategoryIds is EqualUnmodifiableListView) return _interestCategoryIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  bool? onboardingCompleted;

/// Create a copy of MeUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeUpdateDtoCopyWith<_MeUpdateDto> get copyWith => __$MeUpdateDtoCopyWithImpl<_MeUpdateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeUpdateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeUpdateDto&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.homeLocation, homeLocation) || other.homeLocation == homeLocation)&&const DeepCollectionEquality().equals(other.interestCategoryIds, _interestCategoryIds)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,displayName,homeLocation,const DeepCollectionEquality().hash(_interestCategoryIds),onboardingCompleted);
}

@override
String toString() {
    return 'MeUpdateDto(displayName: $displayName, homeLocation: $homeLocation, interestCategoryIds: $interestCategoryIds, onboardingCompleted: $onboardingCompleted)';
}


}

/// @nodoc
abstract mixin class _$MeUpdateDtoCopyWith<$Res> implements $MeUpdateDtoCopyWith<$Res> {
  factory _$MeUpdateDtoCopyWith(_MeUpdateDto value, $Res Function(_MeUpdateDto) _then) = __$MeUpdateDtoCopyWithImpl;
@override @useResult
$Res call({
 String? displayName, GeoPoint? homeLocation, List<String>? interestCategoryIds, bool? onboardingCompleted
});


@override $GeoPointCopyWith<$Res>? get homeLocation;

}
/// @nodoc
class __$MeUpdateDtoCopyWithImpl<$Res>
    implements _$MeUpdateDtoCopyWith<$Res> {
  __$MeUpdateDtoCopyWithImpl(this._self, this._then);

  final _MeUpdateDto _self;
  final $Res Function(_MeUpdateDto) _then;

/// Create a copy of MeUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = freezed,Object? homeLocation = freezed,Object? interestCategoryIds = freezed,Object? onboardingCompleted = freezed,}) {
  return _then(_MeUpdateDto(
displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,homeLocation: freezed == homeLocation ? _self.homeLocation : homeLocation // ignore: cast_nullable_to_non_nullable
as GeoPoint?,interestCategoryIds: freezed == interestCategoryIds ? _self._interestCategoryIds : interestCategoryIds // ignore: cast_nullable_to_non_nullable
as List<String>?,onboardingCompleted: freezed == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of MeUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res>? get homeLocation {
    if (_self.homeLocation == null) {
    return null;
  }

  return $GeoPointCopyWith<$Res>(_self.homeLocation!, (value) {
    return _then(_self.copyWith(homeLocation: value));
  });
}
}

// dart format on
