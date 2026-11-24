import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:profitnet/core/model/geo_point.dart';
import 'package:profitnet/core/security/auth_tokens.dart';

part 'onboarding_models.freezed.dart';

/// Version of the legal documents the user consents to during onboarding.
const String policyVersion = '2026-11';

/// A code sent by SMS that is waiting to be confirmed.
@freezed
abstract class OtpChallenge with _$OtpChallenge {
  const factory OtpChallenge({
    /// E.164 number the code was sent to.
    required String phone,
    required String challengeId,

    /// Seconds to wait before another code may be requested.
    required int retryAfterSeconds,
  }) = _OtpChallenge;
}

/// The part of the signed-in user's profile onboarding cares about.
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String displayName,
    required bool onboardingCompleted,
    GeoPoint? homeLocation,
  }) = _UserProfile;
}

/// Result of a successful code verification.
@freezed
abstract class VerifiedSession with _$VerifiedSession {
  const factory VerifiedSession({
    required AuthTokens tokens,
    required UserProfile user,
  }) = _VerifiedSession;
}

/// GDPR processing purposes a user can consent to.
enum ConsentPurpose {
  terms,
  privacy,
  marketing,
  analytics,
  location,
  aiPhotoProcessing;

  /// Consents without which the app cannot be used.
  bool get isRequired => this == terms || this == privacy;
}

@freezed
abstract class ConsentDecision with _$ConsentDecision {
  const factory ConsentDecision({
    required ConsentPurpose purpose,
    required bool granted,
  }) = _ConsentDecision;
}

/// A top-level category offered as an interest.
@freezed
abstract class InterestCategory with _$InterestCategory {
  const factory InterestCategory({
    required String id,
    required String name,
    String? iconKey,
  }) = _InterestCategory;
}
