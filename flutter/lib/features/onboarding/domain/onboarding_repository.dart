import 'package:profitnet/core/model/geo_point.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_models.dart';

/// Server operations used by the onboarding flow. Every method throws
/// `AppError` on failure.
abstract interface class OnboardingRepository {
  /// Sends a code by SMS to [phone] (E.164).
  Future<OtpChallenge> requestOtp(String phone);

  /// Exchanges the SMS code for a session.
  Future<VerifiedSession> verifyOtp({
    required String challengeId,
    required String code,
  });

  /// Stores the given decisions for the current policy version.
  Future<void> saveConsents(List<ConsentDecision> decisions);

  Future<UserProfile> updateDisplayName(String displayName);

  /// [location] must already be rounded for privacy.
  Future<UserProfile> updateHomeLocation(GeoPoint location);

  Future<List<InterestCategory>> topLevelCategories();

  /// Saves the chosen interests (possibly none) and marks onboarding done.
  Future<UserProfile> completeOnboarding(Set<String> interestCategoryIds);
}
