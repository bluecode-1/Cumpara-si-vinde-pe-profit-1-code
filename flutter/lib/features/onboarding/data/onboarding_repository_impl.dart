import 'package:profitnet/core/model/geo_point.dart';
import 'package:profitnet/core/network/api_call.dart';
import 'package:profitnet/core/security/auth_tokens.dart';
import 'package:profitnet/features/onboarding/data/dto/auth_session_dto.dart';
import 'package:profitnet/features/onboarding/data/dto/category_dto.dart';
import 'package:profitnet/features/onboarding/data/dto/consent_dto.dart';
import 'package:profitnet/features/onboarding/data/dto/me_dto.dart';
import 'package:profitnet/features/onboarding/data/dto/otp_dtos.dart';
import 'package:profitnet/features/onboarding/data/onboarding_api.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_models.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_repository.dart';

/// [OnboardingRepository] on the REST API.
final class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._api);

  final OnboardingApi _api;

  @override
  Future<OtpChallenge> requestOtp(String phone) => apiCall(() async {
    final OtpChallengeDto dto = await _api.requestOtp(
      OtpRequestDto(phone: phone),
    );
    return OtpChallenge(
      phone: phone,
      challengeId: dto.challengeId,
      retryAfterSeconds: dto.retryAfterSeconds,
    );
  });

  @override
  Future<VerifiedSession> verifyOtp({
    required String challengeId,
    required String code,
  }) => apiCall(() async {
    final AuthSessionDto dto = await _api.verifyOtp(
      OtpVerifyRequestDto(challengeId: challengeId, code: code),
    );
    return VerifiedSession(
      tokens: AuthTokens(
        accessToken: dto.accessToken,
        refreshToken: dto.refreshToken,
      ),
      user: dto.user.toDomain(),
    );
  });

  @override
  Future<void> saveConsents(List<ConsentDecision> decisions) => apiCall(
    () => _api.setConsents(<ConsentUpdateDto>[
      for (final ConsentDecision decision in decisions)
        ConsentUpdateDto(
          purpose: decision.purpose.toDto(),
          granted: decision.granted,
          policyVersion: policyVersion,
        ),
    ]),
  );

  @override
  Future<UserProfile> updateDisplayName(String displayName) =>
      _updateMe(MeUpdateDto(displayName: displayName));

  @override
  Future<UserProfile> updateHomeLocation(GeoPoint location) =>
      _updateMe(MeUpdateDto(homeLocation: location));

  @override
  Future<List<InterestCategory>> topLevelCategories() => apiCall(() async {
    final List<CategoryDto> all = await _api.listCategories();
    return <InterestCategory>[
      for (final CategoryDto category in all)
        if (category.parentId == null)
          InterestCategory(
            id: category.id,
            name: category.name,
            iconKey: category.iconKey,
          ),
    ];
  });

  @override
  Future<UserProfile> completeOnboarding(Set<String> interestCategoryIds) =>
      _updateMe(
        MeUpdateDto(
          interestCategoryIds: interestCategoryIds.toList(),
          onboardingCompleted: true,
        ),
      );

  Future<UserProfile> _updateMe(MeUpdateDto update) =>
      apiCall(() async => (await _api.updateMe(update)).toDomain());
}

extension on MeDto {
  UserProfile toDomain() => UserProfile(
    id: id,
    displayName: displayName,
    onboardingCompleted: onboardingCompleted,
    homeLocation: homeLocation,
  );
}

extension on ConsentPurpose {
  ConsentPurposeDto toDto() => switch (this) {
    ConsentPurpose.terms => ConsentPurposeDto.terms,
    ConsentPurpose.privacy => ConsentPurposeDto.privacy,
    ConsentPurpose.marketing => ConsentPurposeDto.marketing,
    ConsentPurpose.analytics => ConsentPurposeDto.analytics,
    ConsentPurpose.location => ConsentPurposeDto.location,
    ConsentPurpose.aiPhotoProcessing => ConsentPurposeDto.aiPhotoProcessing,
  };
}
