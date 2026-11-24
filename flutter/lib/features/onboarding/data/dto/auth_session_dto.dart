import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:profitnet/features/onboarding/data/dto/me_dto.dart';

part 'auth_session_dto.freezed.dart';
part 'auth_session_dto.g.dart';

/// `AuthSession` schema (`TokenPair` plus the user): 200 response of
/// `POST /auth/otp/verify`.
@freezed
abstract class AuthSessionDto with _$AuthSessionDto {
  const factory AuthSessionDto({
    required String accessToken,
    required String refreshToken,
    required int expiresInSeconds,
    required MeDto user,
    required bool isNewUser,
  }) = _AuthSessionDto;

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionDtoFromJson(json);
}
