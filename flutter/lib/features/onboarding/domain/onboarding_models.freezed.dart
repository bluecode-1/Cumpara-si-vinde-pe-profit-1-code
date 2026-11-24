// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OtpChallenge {

/// E.164 number the code was sent to.
 String get phone; String get challengeId;/// Seconds to wait before another code may be requested.
 int get retryAfterSeconds;
/// Create a copy of OtpChallenge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpChallengeCopyWith<OtpChallenge> get copyWith => _$OtpChallengeCopyWithImpl<OtpChallenge>(this as OtpChallenge, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OtpChallenge;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpChallenge&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.challengeId, _this.challengeId) || other.challengeId == _this.challengeId)&&(identical(other.retryAfterSeconds, _this.retryAfterSeconds) || other.retryAfterSeconds == _this.retryAfterSeconds));
}


@override
int get hashCode {
  final _this = this as OtpChallenge;
  return Object.hash(runtimeType,_this.phone,_this.challengeId,_this.retryAfterSeconds);
}

@override
String toString() {
  final _this = this as OtpChallenge;
  return 'OtpChallenge(phone: ${_this.phone}, challengeId: ${_this.challengeId}, retryAfterSeconds: ${_this.retryAfterSeconds})';
}


}

/// @nodoc
abstract mixin class $OtpChallengeCopyWith<$Res>  {
  factory $OtpChallengeCopyWith(OtpChallenge value, $Res Function(OtpChallenge) _then) = _$OtpChallengeCopyWithImpl;
@useResult
$Res call({
 String phone, String challengeId, int retryAfterSeconds
});




}
/// @nodoc
class _$OtpChallengeCopyWithImpl<$Res>
    implements $OtpChallengeCopyWith<$Res> {
  _$OtpChallengeCopyWithImpl(this._self, this._then);

  final OtpChallenge _self;
  final $Res Function(OtpChallenge) _then;

/// Create a copy of OtpChallenge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phone = null,Object? challengeId = null,Object? retryAfterSeconds = null,}) {
  return _then(OtpChallenge(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,challengeId: null == challengeId ? _self.challengeId : challengeId // ignore: cast_nullable_to_non_nullable
as String,retryAfterSeconds: null == retryAfterSeconds ? _self.retryAfterSeconds : retryAfterSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OtpChallenge].
extension OtpChallengePatterns on OtpChallenge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtpChallenge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtpChallenge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtpChallenge value)  $default,){
final _that = this;
switch (_that) {
case _OtpChallenge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtpChallenge value)?  $default,){
final _that = this;
switch (_that) {
case _OtpChallenge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phone,  String challengeId,  int retryAfterSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtpChallenge() when $default != null:
return $default(_that.phone,_that.challengeId,_that.retryAfterSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phone,  String challengeId,  int retryAfterSeconds)  $default,) {final _that = this;
switch (_that) {
case _OtpChallenge():
return $default(_that.phone,_that.challengeId,_that.retryAfterSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phone,  String challengeId,  int retryAfterSeconds)?  $default,) {final _that = this;
switch (_that) {
case _OtpChallenge() when $default != null:
return $default(_that.phone,_that.challengeId,_that.retryAfterSeconds);case _:
  return null;

}
}

}

/// @nodoc


class _OtpChallenge implements OtpChallenge {
  const _OtpChallenge({required this.phone, required this.challengeId, required this.retryAfterSeconds});
  

/// E.164 number the code was sent to.
@override final  String phone;
@override final  String challengeId;
/// Seconds to wait before another code may be requested.
@override final  int retryAfterSeconds;

/// Create a copy of OtpChallenge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpChallengeCopyWith<_OtpChallenge> get copyWith => __$OtpChallengeCopyWithImpl<_OtpChallenge>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpChallenge&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.challengeId, challengeId) || other.challengeId == challengeId)&&(identical(other.retryAfterSeconds, retryAfterSeconds) || other.retryAfterSeconds == retryAfterSeconds));
}


@override
int get hashCode {
    return Object.hash(runtimeType,phone,challengeId,retryAfterSeconds);
}

@override
String toString() {
    return 'OtpChallenge(phone: $phone, challengeId: $challengeId, retryAfterSeconds: $retryAfterSeconds)';
}


}

/// @nodoc
abstract mixin class _$OtpChallengeCopyWith<$Res> implements $OtpChallengeCopyWith<$Res> {
  factory _$OtpChallengeCopyWith(_OtpChallenge value, $Res Function(_OtpChallenge) _then) = __$OtpChallengeCopyWithImpl;
@override @useResult
$Res call({
 String phone, String challengeId, int retryAfterSeconds
});




}
/// @nodoc
class __$OtpChallengeCopyWithImpl<$Res>
    implements _$OtpChallengeCopyWith<$Res> {
  __$OtpChallengeCopyWithImpl(this._self, this._then);

  final _OtpChallenge _self;
  final $Res Function(_OtpChallenge) _then;

/// Create a copy of OtpChallenge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phone = null,Object? challengeId = null,Object? retryAfterSeconds = null,}) {
  return _then(_OtpChallenge(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,challengeId: null == challengeId ? _self.challengeId : challengeId // ignore: cast_nullable_to_non_nullable
as String,retryAfterSeconds: null == retryAfterSeconds ? _self.retryAfterSeconds : retryAfterSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$UserProfile {

 String get id; String get displayName; bool get onboardingCompleted; GeoPoint? get homeLocation;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.onboardingCompleted, _this.onboardingCompleted) || other.onboardingCompleted == _this.onboardingCompleted)&&(identical(other.homeLocation, _this.homeLocation) || other.homeLocation == _this.homeLocation));
}


@override
int get hashCode {
  final _this = this as UserProfile;
  return Object.hash(runtimeType,_this.id,_this.displayName,_this.onboardingCompleted,_this.homeLocation);
}

@override
String toString() {
  final _this = this as UserProfile;
  return 'UserProfile(id: ${_this.id}, displayName: ${_this.displayName}, onboardingCompleted: ${_this.onboardingCompleted}, homeLocation: ${_this.homeLocation})';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String id, String displayName, bool onboardingCompleted, GeoPoint? homeLocation
});


$GeoPointCopyWith<$Res>? get homeLocation;

}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? onboardingCompleted = null,Object? homeLocation = freezed,}) {
  return _then(UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,homeLocation: freezed == homeLocation ? _self.homeLocation : homeLocation // ignore: cast_nullable_to_non_nullable
as GeoPoint?,
  ));
}
/// Create a copy of UserProfile
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


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String displayName,  bool onboardingCompleted,  GeoPoint? homeLocation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.displayName,_that.onboardingCompleted,_that.homeLocation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String displayName,  bool onboardingCompleted,  GeoPoint? homeLocation)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.id,_that.displayName,_that.onboardingCompleted,_that.homeLocation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String displayName,  bool onboardingCompleted,  GeoPoint? homeLocation)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.displayName,_that.onboardingCompleted,_that.homeLocation);case _:
  return null;

}
}

}

/// @nodoc


class _UserProfile implements UserProfile {
  const _UserProfile({required this.id, required this.displayName, required this.onboardingCompleted, this.homeLocation});
  

@override final  String id;
@override final  String displayName;
@override final  bool onboardingCompleted;
@override final  GeoPoint? homeLocation;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.homeLocation, homeLocation) || other.homeLocation == homeLocation));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,displayName,onboardingCompleted,homeLocation);
}

@override
String toString() {
    return 'UserProfile(id: $id, displayName: $displayName, onboardingCompleted: $onboardingCompleted, homeLocation: $homeLocation)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName, bool onboardingCompleted, GeoPoint? homeLocation
});


@override $GeoPointCopyWith<$Res>? get homeLocation;

}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? onboardingCompleted = null,Object? homeLocation = freezed,}) {
  return _then(_UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,homeLocation: freezed == homeLocation ? _self.homeLocation : homeLocation // ignore: cast_nullable_to_non_nullable
as GeoPoint?,
  ));
}

/// Create a copy of UserProfile
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
mixin _$VerifiedSession {

 AuthTokens get tokens; UserProfile get user;
/// Create a copy of VerifiedSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifiedSessionCopyWith<VerifiedSession> get copyWith => _$VerifiedSessionCopyWithImpl<VerifiedSession>(this as VerifiedSession, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as VerifiedSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifiedSession&&(identical(other.tokens, _this.tokens) || other.tokens == _this.tokens)&&(identical(other.user, _this.user) || other.user == _this.user));
}


@override
int get hashCode {
  final _this = this as VerifiedSession;
  return Object.hash(runtimeType,_this.tokens,_this.user);
}

@override
String toString() {
  final _this = this as VerifiedSession;
  return 'VerifiedSession(tokens: ${_this.tokens}, user: ${_this.user})';
}


}

/// @nodoc
abstract mixin class $VerifiedSessionCopyWith<$Res>  {
  factory $VerifiedSessionCopyWith(VerifiedSession value, $Res Function(VerifiedSession) _then) = _$VerifiedSessionCopyWithImpl;
@useResult
$Res call({
 AuthTokens tokens, UserProfile user
});


$AuthTokensCopyWith<$Res> get tokens;$UserProfileCopyWith<$Res> get user;

}
/// @nodoc
class _$VerifiedSessionCopyWithImpl<$Res>
    implements $VerifiedSessionCopyWith<$Res> {
  _$VerifiedSessionCopyWithImpl(this._self, this._then);

  final VerifiedSession _self;
  final $Res Function(VerifiedSession) _then;

/// Create a copy of VerifiedSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tokens = null,Object? user = null,}) {
  return _then(VerifiedSession(
tokens: null == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as AuthTokens,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserProfile,
  ));
}
/// Create a copy of VerifiedSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthTokensCopyWith<$Res> get tokens {
  
  return $AuthTokensCopyWith<$Res>(_self.tokens, (value) {
    return _then(_self.copyWith(tokens: value));
  });
}/// Create a copy of VerifiedSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res> get user {
  
  return $UserProfileCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [VerifiedSession].
extension VerifiedSessionPatterns on VerifiedSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerifiedSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerifiedSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerifiedSession value)  $default,){
final _that = this;
switch (_that) {
case _VerifiedSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerifiedSession value)?  $default,){
final _that = this;
switch (_that) {
case _VerifiedSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AuthTokens tokens,  UserProfile user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerifiedSession() when $default != null:
return $default(_that.tokens,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AuthTokens tokens,  UserProfile user)  $default,) {final _that = this;
switch (_that) {
case _VerifiedSession():
return $default(_that.tokens,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AuthTokens tokens,  UserProfile user)?  $default,) {final _that = this;
switch (_that) {
case _VerifiedSession() when $default != null:
return $default(_that.tokens,_that.user);case _:
  return null;

}
}

}

/// @nodoc


class _VerifiedSession implements VerifiedSession {
  const _VerifiedSession({required this.tokens, required this.user});
  

@override final  AuthTokens tokens;
@override final  UserProfile user;

/// Create a copy of VerifiedSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerifiedSessionCopyWith<_VerifiedSession> get copyWith => __$VerifiedSessionCopyWithImpl<_VerifiedSession>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerifiedSession&&(identical(other.tokens, tokens) || other.tokens == tokens)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tokens,user);
}

@override
String toString() {
    return 'VerifiedSession(tokens: $tokens, user: $user)';
}


}

/// @nodoc
abstract mixin class _$VerifiedSessionCopyWith<$Res> implements $VerifiedSessionCopyWith<$Res> {
  factory _$VerifiedSessionCopyWith(_VerifiedSession value, $Res Function(_VerifiedSession) _then) = __$VerifiedSessionCopyWithImpl;
@override @useResult
$Res call({
 AuthTokens tokens, UserProfile user
});


@override $AuthTokensCopyWith<$Res> get tokens;@override $UserProfileCopyWith<$Res> get user;

}
/// @nodoc
class __$VerifiedSessionCopyWithImpl<$Res>
    implements _$VerifiedSessionCopyWith<$Res> {
  __$VerifiedSessionCopyWithImpl(this._self, this._then);

  final _VerifiedSession _self;
  final $Res Function(_VerifiedSession) _then;

/// Create a copy of VerifiedSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tokens = null,Object? user = null,}) {
  return _then(_VerifiedSession(
tokens: null == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as AuthTokens,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserProfile,
  ));
}

/// Create a copy of VerifiedSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthTokensCopyWith<$Res> get tokens {
  
  return $AuthTokensCopyWith<$Res>(_self.tokens, (value) {
    return _then(_self.copyWith(tokens: value));
  });
}/// Create a copy of VerifiedSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res> get user {
  
  return $UserProfileCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc
mixin _$ConsentDecision {

 ConsentPurpose get purpose; bool get granted;
/// Create a copy of ConsentDecision
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsentDecisionCopyWith<ConsentDecision> get copyWith => _$ConsentDecisionCopyWithImpl<ConsentDecision>(this as ConsentDecision, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ConsentDecision;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsentDecision&&(identical(other.purpose, _this.purpose) || other.purpose == _this.purpose)&&(identical(other.granted, _this.granted) || other.granted == _this.granted));
}


@override
int get hashCode {
  final _this = this as ConsentDecision;
  return Object.hash(runtimeType,_this.purpose,_this.granted);
}

@override
String toString() {
  final _this = this as ConsentDecision;
  return 'ConsentDecision(purpose: ${_this.purpose}, granted: ${_this.granted})';
}


}

/// @nodoc
abstract mixin class $ConsentDecisionCopyWith<$Res>  {
  factory $ConsentDecisionCopyWith(ConsentDecision value, $Res Function(ConsentDecision) _then) = _$ConsentDecisionCopyWithImpl;
@useResult
$Res call({
 ConsentPurpose purpose, bool granted
});




}
/// @nodoc
class _$ConsentDecisionCopyWithImpl<$Res>
    implements $ConsentDecisionCopyWith<$Res> {
  _$ConsentDecisionCopyWithImpl(this._self, this._then);

  final ConsentDecision _self;
  final $Res Function(ConsentDecision) _then;

/// Create a copy of ConsentDecision
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? purpose = null,Object? granted = null,}) {
  return _then(ConsentDecision(
purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as ConsentPurpose,granted: null == granted ? _self.granted : granted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsentDecision].
extension ConsentDecisionPatterns on ConsentDecision {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsentDecision value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsentDecision() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsentDecision value)  $default,){
final _that = this;
switch (_that) {
case _ConsentDecision():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsentDecision value)?  $default,){
final _that = this;
switch (_that) {
case _ConsentDecision() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ConsentPurpose purpose,  bool granted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsentDecision() when $default != null:
return $default(_that.purpose,_that.granted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ConsentPurpose purpose,  bool granted)  $default,) {final _that = this;
switch (_that) {
case _ConsentDecision():
return $default(_that.purpose,_that.granted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ConsentPurpose purpose,  bool granted)?  $default,) {final _that = this;
switch (_that) {
case _ConsentDecision() when $default != null:
return $default(_that.purpose,_that.granted);case _:
  return null;

}
}

}

/// @nodoc


class _ConsentDecision implements ConsentDecision {
  const _ConsentDecision({required this.purpose, required this.granted});
  

@override final  ConsentPurpose purpose;
@override final  bool granted;

/// Create a copy of ConsentDecision
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsentDecisionCopyWith<_ConsentDecision> get copyWith => __$ConsentDecisionCopyWithImpl<_ConsentDecision>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsentDecision&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.granted, granted) || other.granted == granted));
}


@override
int get hashCode {
    return Object.hash(runtimeType,purpose,granted);
}

@override
String toString() {
    return 'ConsentDecision(purpose: $purpose, granted: $granted)';
}


}

/// @nodoc
abstract mixin class _$ConsentDecisionCopyWith<$Res> implements $ConsentDecisionCopyWith<$Res> {
  factory _$ConsentDecisionCopyWith(_ConsentDecision value, $Res Function(_ConsentDecision) _then) = __$ConsentDecisionCopyWithImpl;
@override @useResult
$Res call({
 ConsentPurpose purpose, bool granted
});




}
/// @nodoc
class __$ConsentDecisionCopyWithImpl<$Res>
    implements _$ConsentDecisionCopyWith<$Res> {
  __$ConsentDecisionCopyWithImpl(this._self, this._then);

  final _ConsentDecision _self;
  final $Res Function(_ConsentDecision) _then;

/// Create a copy of ConsentDecision
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? purpose = null,Object? granted = null,}) {
  return _then(_ConsentDecision(
purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as ConsentPurpose,granted: null == granted ? _self.granted : granted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$InterestCategory {

 String get id; String get name; String? get iconKey;
/// Create a copy of InterestCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InterestCategoryCopyWith<InterestCategory> get copyWith => _$InterestCategoryCopyWithImpl<InterestCategory>(this as InterestCategory, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InterestCategory;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InterestCategory&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.iconKey, _this.iconKey) || other.iconKey == _this.iconKey));
}


@override
int get hashCode {
  final _this = this as InterestCategory;
  return Object.hash(runtimeType,_this.id,_this.name,_this.iconKey);
}

@override
String toString() {
  final _this = this as InterestCategory;
  return 'InterestCategory(id: ${_this.id}, name: ${_this.name}, iconKey: ${_this.iconKey})';
}


}

/// @nodoc
abstract mixin class $InterestCategoryCopyWith<$Res>  {
  factory $InterestCategoryCopyWith(InterestCategory value, $Res Function(InterestCategory) _then) = _$InterestCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? iconKey
});




}
/// @nodoc
class _$InterestCategoryCopyWithImpl<$Res>
    implements $InterestCategoryCopyWith<$Res> {
  _$InterestCategoryCopyWithImpl(this._self, this._then);

  final InterestCategory _self;
  final $Res Function(InterestCategory) _then;

/// Create a copy of InterestCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? iconKey = freezed,}) {
  return _then(InterestCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconKey: freezed == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InterestCategory].
extension InterestCategoryPatterns on InterestCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InterestCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InterestCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InterestCategory value)  $default,){
final _that = this;
switch (_that) {
case _InterestCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InterestCategory value)?  $default,){
final _that = this;
switch (_that) {
case _InterestCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? iconKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InterestCategory() when $default != null:
return $default(_that.id,_that.name,_that.iconKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? iconKey)  $default,) {final _that = this;
switch (_that) {
case _InterestCategory():
return $default(_that.id,_that.name,_that.iconKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? iconKey)?  $default,) {final _that = this;
switch (_that) {
case _InterestCategory() when $default != null:
return $default(_that.id,_that.name,_that.iconKey);case _:
  return null;

}
}

}

/// @nodoc


class _InterestCategory implements InterestCategory {
  const _InterestCategory({required this.id, required this.name, this.iconKey});
  

@override final  String id;
@override final  String name;
@override final  String? iconKey;

/// Create a copy of InterestCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InterestCategoryCopyWith<_InterestCategory> get copyWith => __$InterestCategoryCopyWithImpl<_InterestCategory>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InterestCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,iconKey);
}

@override
String toString() {
    return 'InterestCategory(id: $id, name: $name, iconKey: $iconKey)';
}


}

/// @nodoc
abstract mixin class _$InterestCategoryCopyWith<$Res> implements $InterestCategoryCopyWith<$Res> {
  factory _$InterestCategoryCopyWith(_InterestCategory value, $Res Function(_InterestCategory) _then) = __$InterestCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? iconKey
});




}
/// @nodoc
class __$InterestCategoryCopyWithImpl<$Res>
    implements _$InterestCategoryCopyWith<$Res> {
  __$InterestCategoryCopyWithImpl(this._self, this._then);

  final _InterestCategory _self;
  final $Res Function(_InterestCategory) _then;

/// Create a copy of InterestCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? iconKey = freezed,}) {
  return _then(_InterestCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconKey: freezed == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
