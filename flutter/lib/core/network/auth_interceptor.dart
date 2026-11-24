import 'dart:async';

import 'package:dio/dio.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/security/auth_tokens.dart';
import 'package:profitnet/core/security/token_store.dart';

/// Exchanges a refresh token for a new pair (`POST /auth/refresh`).
typedef TokenRefresher = Future<AuthTokens> Function(String refreshToken);

/// Re-sends a request through the client the interceptor is installed on.
typedef RequestRetrier = Future<Response<dynamic>> Function(
  RequestOptions options,
);

/// Attaches the access token to authenticated requests and recovers from a
/// 401 with exactly one token refresh, shared by all concurrent requests,
/// followed by one retry of each failed request.
///
/// When the server rejects the refresh the session is cleared (the router
/// then sends the user back to Welcome). A refresh that fails without a
/// response (no connectivity) keeps the session: the user is not logged out
/// for being offline.
final class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this._tokenStore,
    required this._refresh,
    required this._retry,
    required this._onSessionExpired,
  });

  /// `Options.extra` key; set to `false` for endpoints declared with
  /// `security: []` in the contract.
  static const String requiresAuthKey = 'requiresAuth';
  static const String _retriedKey = 'authRetried';
  static const String _authorization = 'Authorization';

  /// Options for endpoints that must not carry the access token.
  static Options public() =>
      Options(extra: <String, Object?>{requiresAuthKey: false});

  final TokenStore _tokenStore;
  final TokenRefresher _refresh;
  final RequestRetrier _retry;
  final Future<void> Function() _onSessionExpired;

  /// The refresh currently running, if any (single flight).
  Future<AuthTokens?>? _refreshInFlight;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_requiresAuth(options)) {
      return handler.next(options);
    }
    try {
      // Do not send a token that is known to be about to be replaced.
      final Future<AuthTokens?>? pending = _refreshInFlight;
      if (pending != null) {
        await pending.catchError((Object _) => null);
      }
      final AuthTokens? tokens = await _tokenStore.read();
      if (tokens != null) {
        options.headers[_authorization] = 'Bearer ${tokens.accessToken}';
      }
      handler.next(options);
    } on Object catch (error, stackTrace) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final RequestOptions options = err.requestOptions;
    final bool recoverable =
        err.response?.statusCode == 401 &&
        _requiresAuth(options) &&
        options.extra[_retriedKey] != true;
    if (!recoverable) {
      return handler.next(err);
    }
    try {
      final AuthTokens? tokens = await _freshTokens(
        rejectedAccessToken: _bearerToken(options),
      );
      if (tokens == null) {
        return handler.next(
          err.copyWith(error: const AppError.sessionExpired()),
        );
      }
      options.extra[_retriedKey] = true;
      options.headers[_authorization] = 'Bearer ${tokens.accessToken}';
      handler.resolve(await _retry(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    } on Object catch (error, stackTrace) {
      handler.next(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Returns tokens newer than [rejectedAccessToken], refreshing if needed,
  /// or `null` when there is no session any more.
  Future<AuthTokens?> _freshTokens({
    required String? rejectedAccessToken,
  }) async {
    final Future<AuthTokens?>? pending = _refreshInFlight;
    if (pending != null) {
      return pending;
    }
    final AuthTokens? current = await _tokenStore.read();
    if (current == null) {
      return null;
    }
    if (rejectedAccessToken != null &&
        current.accessToken != rejectedAccessToken) {
      // Another request already refreshed while this one was in flight.
      return current;
    }
    // Re-check after the await above: a concurrent caller may have started.
    return _refreshInFlight ??= _runRefresh(current.refreshToken)
        .whenComplete(() => _refreshInFlight = null);
  }

  Future<AuthTokens?> _runRefresh(String refreshToken) async {
    try {
      final AuthTokens tokens = await _refresh(refreshToken);
      await _tokenStore.write(tokens);
      return tokens;
    } on DioException catch (error) {
      if (error.response == null) {
        // Transport failure: the refresh token may still be valid.
        rethrow;
      }
      await _tokenStore.clear();
      await _onSessionExpired();
      return null;
    }
  }

  static bool _requiresAuth(RequestOptions options) =>
      options.extra[requiresAuthKey] != false;

  static String? _bearerToken(RequestOptions options) {
    final Object? header = options.headers[_authorization];
    const String prefix = 'Bearer ';
    return header is String && header.startsWith(prefix)
        ? header.substring(prefix.length)
        : null;
  }
}
