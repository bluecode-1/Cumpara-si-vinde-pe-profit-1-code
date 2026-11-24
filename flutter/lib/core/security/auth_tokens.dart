import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_tokens.freezed.dart';

/// The token pair that makes up a session.
@freezed
abstract class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    required String accessToken,
    required String refreshToken,
  }) = _AuthTokens;

  const AuthTokens._();

  // Tokens must never end up in logs or crash reports.
  @override
  String toString() => 'AuthTokens(<redacted>)';
}
