import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_dtos.freezed.dart';
part 'otp_dtos.g.dart';

/// Body of `POST /auth/otp/request`.
@freezed
abstract class OtpRequestDto with _$OtpRequestDto {
  const factory OtpRequestDto({required String phone}) = _OtpRequestDto;

  factory OtpRequestDto.fromJson(Map<String, dynamic> json) =>
      _$OtpRequestDtoFromJson(json);
}

/// 202 response of `POST /auth/otp/request`.
@freezed
abstract class OtpChallengeDto with _$OtpChallengeDto {
  const factory OtpChallengeDto({
    required String challengeId,
    required int retryAfterSeconds,
  }) = _OtpChallengeDto;

  factory OtpChallengeDto.fromJson(Map<String, dynamic> json) =>
      _$OtpChallengeDtoFromJson(json);
}

/// Body of `POST /auth/otp/verify`.
@freezed
abstract class OtpVerifyRequestDto with _$OtpVerifyRequestDto {
  const factory OtpVerifyRequestDto({
    required String challengeId,
    required String code,
  }) = _OtpVerifyRequestDto;

  factory OtpVerifyRequestDto.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyRequestDtoFromJson(json);
}
