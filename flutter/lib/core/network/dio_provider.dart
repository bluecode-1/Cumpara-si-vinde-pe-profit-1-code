import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:profitnet/core/network/api_config.dart';
import 'package:profitnet/core/network/auth_interceptor.dart';
import 'package:profitnet/core/network/fake_api_interceptor.dart';
import 'package:profitnet/core/network/token_pair_dto.dart';
import 'package:profitnet/core/security/token_store.dart';
import 'package:profitnet/core/session/session_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

/// The in-memory backend used in demo mode; `null` in every other case.
///
/// `kReleaseMode` is a compile-time constant, so in release builds this is
/// constant-folded to `null` and the fake is removed by tree shaking.
@Riverpod(keepAlive: true)
FakeApiInterceptor? fakeApi(Ref ref) {
  if (kReleaseMode) {
    return null;
  }
  return ref.watch(apiConfigProvider).useFakeApi ? FakeApiInterceptor() : null;
}

/// The HTTP client used by every feature.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final Dio dio = createApiClient(
    config: ref.watch(apiConfigProvider),
    tokenStore: ref.watch(tokenStoreProvider),
    fakeApi: ref.watch(fakeApiProvider),
    onSessionExpired: () =>
        ref.read(sessionControllerProvider.notifier).signOut(),
  );
  ref.onDispose(dio.close);
  return dio;
}

/// Builds the API client: base options, [AuthInterceptor], certificate
/// pinning hook and, in demo mode only, the fake backend.
Dio createApiClient({
  required ApiConfig config,
  required TokenStore tokenStore,
  required Future<void> Function() onSessionExpired,
  FakeApiInterceptor? fakeApi,
  @visibleForTesting HttpClientAdapter? refreshAdapter,
}) {
  final BaseOptions options = BaseOptions(
    baseUrl: config.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    contentType: Headers.jsonContentType,
    headers: <String, Object?>{'Accept': 'application/json'},
  );

  // Refreshing uses its own client without the auth interceptor: a 401 from
  // /auth/refresh must never trigger another refresh.
  final Dio refreshClient = Dio(options);
  if (refreshAdapter != null) {
    refreshClient.httpClientAdapter = refreshAdapter;
  }
  final Dio client = Dio(options);
  config.pinning.applyTo(client);
  if (refreshAdapter == null) {
    config.pinning.applyTo(refreshClient);
  }

  client.interceptors.add(
    AuthInterceptor(
      tokenStore: tokenStore,
      refresh: (String refreshToken) async {
        final Response<Map<String, dynamic>> response = await refreshClient
            .post<Map<String, dynamic>>(
              '/auth/refresh',
              data: <String, String>{'refreshToken': refreshToken},
            );
        return TokenPairDto.fromJson(response.data!).toTokens();
      },
      retry: client.fetch<dynamic>,
      onSessionExpired: onSessionExpired,
    ),
  );

  if (!kReleaseMode && fakeApi != null) {
    // Last in the chain, so that requests reach it with the token attached.
    client.interceptors.add(fakeApi);
    refreshClient.interceptors.add(fakeApi);
  }
  return client;
}
