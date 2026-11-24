// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BadgeDto _$BadgeDtoFromJson(Map<String, dynamic> json) => _BadgeDto(
  attribute: $enumDecode(
    _$ReputationAttributeDtoEnumMap,
    json['attribute'],
    unknownValue: ReputationAttributeDto.unknown,
  ),
  confirmations: (json['confirmations'] as num).toInt(),
);

Map<String, dynamic> _$BadgeDtoToJson(_BadgeDto instance) => <String, dynamic>{
  'attribute': _$ReputationAttributeDtoEnumMap[instance.attribute]!,
  'confirmations': instance.confirmations,
};

const _$ReputationAttributeDtoEnumMap = {
  ReputationAttributeDto.punctual: 'PUNCTUAL',
  ReputationAttributeDto.asDescribed: 'AS_DESCRIBED',
  ReputationAttributeDto.respondsFast: 'RESPONDS_FAST',
  ReputationAttributeDto.carefulPackaging: 'CAREFUL_PACKAGING',
  ReputationAttributeDto.fairNegotiation: 'FAIR_NEGOTIATION',
  ReputationAttributeDto.unknown: 'UNKNOWN',
};

_TraderInfoDto _$TraderInfoDtoFromJson(Map<String, dynamic> json) =>
    _TraderInfoDto(
      legalName: json['legalName'] as String?,
      registrationNumber: json['registrationNumber'] as String?,
      address: json['address'] as String?,
      contactEmail: json['contactEmail'] as String?,
    );

Map<String, dynamic> _$TraderInfoDtoToJson(_TraderInfoDto instance) =>
    <String, dynamic>{
      'legalName': instance.legalName,
      'registrationNumber': instance.registrationNumber,
      'address': instance.address,
      'contactEmail': instance.contactEmail,
    };

_AccountLimitsDto _$AccountLimitsDtoFromJson(Map<String, dynamic> json) =>
    _AccountLimitsDto(
      maxTransaction: Money.fromJson(
        json['maxTransaction'] as Map<String, dynamic>,
      ),
      monthlyVolume: Money.fromJson(
        json['monthlyVolume'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$AccountLimitsDtoToJson(_AccountLimitsDto instance) =>
    <String, dynamic>{
      'maxTransaction': instance.maxTransaction.toJson(),
      'monthlyVolume': instance.monthlyVolume.toJson(),
    };

_MeDto _$MeDtoFromJson(Map<String, dynamic> json) => _MeDto(
  id: json['id'] as String,
  displayName: json['displayName'] as String,
  verificationTier: $enumDecode(
    _$VerificationTierDtoEnumMap,
    json['verificationTier'],
    unknownValue: VerificationTierDto.unknown,
  ),
  sellerType: $enumDecode(
    _$SellerTypeDtoEnumMap,
    json['sellerType'],
    unknownValue: SellerTypeDto.unknown,
  ),
  badges: (json['badges'] as List<dynamic>)
      .map((e) => BadgeDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  memberSince: DateTime.parse(json['memberSince'] as String),
  phone: json['phone'] as String,
  locale: json['locale'] as String,
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
  limits: AccountLimitsDto.fromJson(json['limits'] as Map<String, dynamic>),
  avatarUrl: json['avatarUrl'] as String?,
  city: json['city'] as String?,
  completedTransactions: (json['completedTransactions'] as num?)?.toInt() ?? 0,
  traderInfo: json['traderInfo'] == null
      ? null
      : TraderInfoDto.fromJson(json['traderInfo'] as Map<String, dynamic>),
  email: json['email'] as String?,
  emailVerified: json['emailVerified'] as bool? ?? false,
  homeLocation: json['homeLocation'] == null
      ? null
      : GeoPoint.fromJson(json['homeLocation'] as Map<String, dynamic>),
  onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
);

Map<String, dynamic> _$MeDtoToJson(_MeDto instance) => <String, dynamic>{
  'id': instance.id,
  'displayName': instance.displayName,
  'verificationTier': _$VerificationTierDtoEnumMap[instance.verificationTier]!,
  'sellerType': _$SellerTypeDtoEnumMap[instance.sellerType]!,
  'badges': instance.badges.map((e) => e.toJson()).toList(),
  'memberSince': instance.memberSince.toIso8601String(),
  'phone': instance.phone,
  'locale': instance.locale,
  'currency': _$CurrencyEnumMap[instance.currency]!,
  'limits': instance.limits.toJson(),
  'avatarUrl': instance.avatarUrl,
  'city': instance.city,
  'completedTransactions': instance.completedTransactions,
  'traderInfo': instance.traderInfo?.toJson(),
  'email': instance.email,
  'emailVerified': instance.emailVerified,
  'homeLocation': instance.homeLocation?.toJson(),
  'onboardingCompleted': instance.onboardingCompleted,
};

const _$VerificationTierDtoEnumMap = {
  VerificationTierDto.phone: 'PHONE',
  VerificationTierDto.email: 'EMAIL',
  VerificationTierDto.identity: 'IDENTITY',
  VerificationTierDto.unknown: 'UNKNOWN',
};

const _$SellerTypeDtoEnumMap = {
  SellerTypeDto.occasional: 'OCCASIONAL',
  SellerTypeDto.professional: 'PROFESSIONAL',
  SellerTypeDto.unknown: 'UNKNOWN',
};

const _$CurrencyEnumMap = {Currency.ron: 'RON', Currency.eur: 'EUR'};

_MeUpdateDto _$MeUpdateDtoFromJson(Map<String, dynamic> json) => _MeUpdateDto(
  displayName: json['displayName'] as String?,
  homeLocation: json['homeLocation'] == null
      ? null
      : GeoPoint.fromJson(json['homeLocation'] as Map<String, dynamic>),
  interestCategoryIds: (json['interestCategoryIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  onboardingCompleted: json['onboardingCompleted'] as bool?,
);

Map<String, dynamic> _$MeUpdateDtoToJson(_MeUpdateDto instance) =>
    <String, dynamic>{
      'displayName': ?instance.displayName,
      'homeLocation': ?instance.homeLocation?.toJson(),
      'interestCategoryIds': ?instance.interestCategoryIds,
      'onboardingCompleted': ?instance.onboardingCompleted,
    };
