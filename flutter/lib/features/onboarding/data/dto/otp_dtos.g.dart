// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OtpRequestDto _$OtpRequestDtoFromJson(Map<String, dynamic> json) =>
    _OtpRequestDto(phone: json['phone'] as String);

Map<String, dynamic> _$OtpRequestDtoToJson(_OtpRequestDto instance) =>
    <String, dynamic>{'phone': instance.phone};

_OtpChallengeDto _$OtpChallengeDtoFromJson(Map<String, dynamic> json) =>
    _OtpChallengeDto(
      challengeId: json['challengeId'] as String,
      retryAfterSeconds: (json['retryAfterSeconds'] as num).toInt(),
    );

Map<String, dynamic> _$OtpChallengeDtoToJson(_OtpChallengeDto instance) =>
    <String, dynamic>{
      'challengeId': instance.challengeId,
      'retryAfterSeconds': instance.retryAfterSeconds,
    };

_OtpVerifyRequestDto _$OtpVerifyRequestDtoFromJson(Map<String, dynamic> json) =>
    _OtpVerifyRequestDto(
      challengeId: json['challengeId'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$OtpVerifyRequestDtoToJson(
  _OtpVerifyRequestDto instance,
) => <String, dynamic>{
  'challengeId': instance.challengeId,
  'code': instance.code,
};
