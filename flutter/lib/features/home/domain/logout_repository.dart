/// Server side of signing out.
abstract interface class LogoutRepository {
  /// Revokes the refresh token family (`POST /auth/logout`). Throws
  /// `AppError` on failure.
  Future<void> logout();
}
