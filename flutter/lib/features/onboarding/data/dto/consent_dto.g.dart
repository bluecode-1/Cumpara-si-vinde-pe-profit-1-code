// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConsentDto _$ConsentDtoFromJson(Map<String, dynamic> json) => _ConsentDto(
  purpose: $enumDecode(
    _$ConsentPurposeDtoEnumMap,
    json['purpose'],
    unknownValue: ConsentPurposeDto.unknown,
  ),
  granted: json['granted'] as bool,
  policyVersion: json['policyVersion'] as String,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ConsentDtoToJson(_ConsentDto instance) =>
    <String, dynamic>{
      'purpose': _$ConsentPurposeDtoEnumMap[instance.purpose]!,
      'granted': instance.granted,
      'policyVersion': instance.policyVersion,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ConsentPurposeDtoEnumMap = {
  ConsentPurposeDto.terms: 'TERMS',
  ConsentPurposeDto.privacy: 'PRIVACY',
  ConsentPurposeDto.marketing: 'MARKETING',
  ConsentPurposeDto.analytics: 'ANALYTICS',
  ConsentPurposeDto.location: 'LOCATION',
  ConsentPurposeDto.aiPhotoProcessing: 'AI_PHOTO_PROCESSING',
  ConsentPurposeDto.unknown: 'UNKNOWN',
};

_ConsentUpdateDto _$ConsentUpdateDtoFromJson(Map<String, dynamic> json) =>
    _ConsentUpdateDto(
      purpose: $enumDecode(_$ConsentPurposeDtoEnumMap, json['purpose']),
      granted: json['granted'] as bool,
      policyVersion: json['policyVersion'] as String,
    );

Map<String, dynamic> _$ConsentUpdateDtoToJson(_ConsentUpdateDto instance) =>
    <String, dynamic>{
      'purpose': _$ConsentPurposeDtoEnumMap[instance.purpose]!,
      'granted': instance.granted,
      'policyVersion': instance.policyVersion,
    };
