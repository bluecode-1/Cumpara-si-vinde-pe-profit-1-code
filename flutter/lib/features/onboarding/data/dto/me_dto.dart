import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:profitnet/core/model/geo_point.dart';
import 'package:profitnet/core/model/money.dart';

part 'me_dto.freezed.dart';
part 'me_dto.g.dart';

// Every enum has an `unknown` fallback so that a value added by a newer
// backend never breaks decoding in an older app.

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum VerificationTierDto { phone, email, identity, unknown }

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum SellerTypeDto { occasional, professional, unknown }

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum ReputationAttributeDto {
  punctual,
  asDescribed,
  respondsFast,
  carefulPackaging,
  fairNegotiation,
  unknown,
}

/// `Badge` schema.
@freezed
abstract class BadgeDto with _$BadgeDto {
  const factory BadgeDto({
    @JsonKey(unknownEnumValue: ReputationAttributeDto.unknown)
    required ReputationAttributeDto attribute,
    required int confirmations,
  }) = _BadgeDto;

  factory BadgeDto.fromJson(Map<String, dynamic> json) =>
      _$BadgeDtoFromJson(json);
}

/// `PublicUser.traderInfo`: present only for professional sellers.
@freezed
abstract class TraderInfoDto with _$TraderInfoDto {
  const factory TraderInfoDto({
    String? legalName,
    String? registrationNumber,
    String? address,
    String? contactEmail,
  }) = _TraderInfoDto;

  factory TraderInfoDto.fromJson(Map<String, dynamic> json) =>
      _$TraderInfoDtoFromJson(json);
}

/// `Me.limits`.
@freezed
abstract class AccountLimitsDto with _$AccountLimitsDto {
  const factory AccountLimitsDto({
    required Money maxTransaction,
    required Money monthlyVolume,
  }) = _AccountLimitsDto;

  factory AccountLimitsDto.fromJson(Map<String, dynamic> json) =>
      _$AccountLimitsDtoFromJson(json);
}

/// `Me` schema (`PublicUser` plus the private fields): response of
/// `GET /me` and `PATCH /me`, and the `user` member of `AuthSession`.
@freezed
abstract class MeDto with _$MeDto {
  const factory MeDto({
    required String id,
    required String displayName,
    @JsonKey(unknownEnumValue: VerificationTierDto.unknown)
    required VerificationTierDto verificationTier,
    @JsonKey(unknownEnumValue: SellerTypeDto.unknown)
    required SellerTypeDto sellerType,
    required List<BadgeDto> badges,
    required DateTime memberSince,
    required String phone,
    required String locale,
    required Currency currency,
    required AccountLimitsDto limits,
    String? avatarUrl,
    String? city,
    @Default(0) int completedTransactions,
    TraderInfoDto? traderInfo,
    String? email,
    @Default(false) bool emailVerified,
    GeoPoint? homeLocation,
    @Default(false) bool onboardingCompleted,
  }) = _MeDto;

  factory MeDto.fromJson(Map<String, dynamic> json) => _$MeDtoFromJson(json);
}

/// `MeUpdate` schema: body of `PATCH /me`. Only the fields that are set are
/// sent.
@freezed
abstract class MeUpdateDto with _$MeUpdateDto {
  @JsonSerializable(includeIfNull: false)
  const factory MeUpdateDto({
    String? displayName,
    GeoPoint? homeLocation,
    List<String>? interestCategoryIds,
    bool? onboardingCompleted,
  }) = _MeUpdateDto;

  factory MeUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$MeUpdateDtoFromJson(json);
}
