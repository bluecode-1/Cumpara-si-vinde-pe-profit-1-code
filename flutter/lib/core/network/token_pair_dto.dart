import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:profitnet/core/security/auth_tokens.dart';

part 'token_pair_dto.freezed.dart';
part 'token_pair_dto.g.dart';

/// `TokenPair` schema: response of `POST /auth/refresh`.
@freezed
abstract class TokenPairDto with _$TokenPairDto {
  const factory TokenPairDto({
    required String accessToken,
    required String refreshToken,
    required int expiresInSeconds,
  }) = _TokenPairDto;

  const TokenPairDto._();

  factory TokenPairDto.fromJson(Map<String, dynamic> json) =>
      _$TokenPairDtoFromJson(json);

  AuthTokens toTokens() =>
      AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
}
