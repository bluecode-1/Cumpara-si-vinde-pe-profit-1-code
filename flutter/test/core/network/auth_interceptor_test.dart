import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/error/app_error_mapper.dart';
import 'package:profitnet/core/network/api_config.dart';
import 'package:profitnet/core/network/auth_interceptor.dart';
import 'package:profitnet/core/network/dio_provider.dart';
import 'package:profitnet/core/security/auth_tokens.dart';
import 'package:profitnet/core/security/token_store.dart';

import '../../support/fakes.dart';
import '../../support/fixtures.dart';

const AuthTokens _stale = AuthTokens(
  accessToken: 'stale-access',
  refreshToken: 'refresh-1',
);

/// Token pair returned by the `auth_refresh.200.json` fixture.
const String _freshAccess = 'fixture.access.token.2';

const Map<String, dynamic> _unauthorized = <String, dynamic>{
  'type': 'about:blank',
  'title': 'Unauthorized',
  'status': 401,
  'code': 'UNAUTHENTICATED',
};

String? _bearer(RequestOptions options) =>
    options.headers['Authorization'] as String?;

void main() {
  late InMemoryTokenStore tokenStore;
  late int sessionExpiredCalls;

  /// Builds the real API client (auth interceptor + separate refresh
  /// client) on top of scripted adapters.
  ({Dio dio, ScriptedHttpAdapter api, ScriptedHttpAdapter refresh}) build({
    required Future<ScriptedResponse> Function(RequestOptions) api,
    Future<ScriptedResponse> Function(RequestOptions)? refresh,
  }) {
    final ScriptedHttpAdapter apiAdapter = ScriptedHttpAdapter(api);
    final ScriptedHttpAdapter refreshAdapter = ScriptedHttpAdapter(
      refresh ??
          (RequestOptions _) async =>
              ScriptedResponse(200, fixtureObject('auth_refresh.200.json')),
    );
    final Dio dio = createApiClient(
      config: const ApiConfig(baseUrl: 'https://api.test/v1'),
      tokenStore: tokenStore,
      onSessionExpired: () async => sessionExpiredCalls++,
      refreshAdapter: refreshAdapter,
    )..httpClientAdapter = apiAdapter;
    addTearDown(dio.close);
    return (dio: dio, api: apiAdapter, refresh: refreshAdapter);
  }

  /// A backend that only accepts [_freshAccess].
  Future<ScriptedResponse> acceptFreshTokenOnly(RequestOptions options) async =>
      _bearer(options) == 'Bearer $_freshAccess'
      ? ScriptedResponse(200, <String, dynamic>{'path': options.path})
      : const ScriptedResponse(401, _unauthorized);

  setUp(() {
    tokenStore = InMemoryTokenStore(_stale);
    sessionExpiredCalls = 0;
  });

  test('attaches the access token to authenticated requests', () async {
    final client = build(
      api: (RequestOptions _) async => const ScriptedResponse(200),
    );
    await client.dio.get<dynamic>('/me');
    expect(_bearer(client.api.requests.single), 'Bearer stale-access');
  });

  test('does not attach the token to public endpoints', () async {
    final client = build(
      api: (RequestOptions _) async => const ScriptedResponse(200),
    );
    await client.dio.get<dynamic>(
      '/categories',
      options: AuthInterceptor.public(),
    );
    expect(_bearer(client.api.requests.single), isNull);
  });

  test('401 -> one refresh -> the request is retried once with the new '
      'token', () async {
    final client = build(api: acceptFreshTokenOnly);

    final Response<dynamic> response = await client.dio.get<dynamic>('/me');

    expect(response.statusCode, 200);
    expect(client.api.authorizations, <String>[
      'Bearer stale-access',
      'Bearer $_freshAccess',
    ]);
    expect(client.refresh.requests, hasLength(1));
    expect(client.refresh.requests.single.path, '/auth/refresh');
    expect(client.refresh.requests.single.data, <String, String>{
      'refreshToken': 'refresh-1',
    });
    expect(_bearer(client.refresh.requests.single), isNull);
    // The rotated pair is persisted.
    expect(
      await tokenStore.read(),
      const AuthTokens(
        accessToken: _freshAccess,
        refreshToken: 'fixture-refresh-token-2',
      ),
    );
    expect(sessionExpiredCalls, 0);
  });

  test('the request body is preserved on the retry', () async {
    final client = build(api: acceptFreshTokenOnly);
    await client.dio.patch<dynamic>(
      '/me',
      data: <String, dynamic>{'displayName': 'Ioana'},
    );
    expect(client.api.requests, hasLength(2));
    expect(client.api.requests.last.method, 'PATCH');
    expect(client.api.requests.last.data, <String, dynamic>{
      'displayName': 'Ioana',
    });
  });

  test('concurrent 401s share a single refresh', () async {
    final Completer<void> releaseRefresh = Completer<void>();
    final client = build(
      api: acceptFreshTokenOnly,
      refresh: (RequestOptions _) async {
        await releaseRefresh.future;
        return ScriptedResponse(200, fixtureObject('auth_refresh.200.json'));
      },
    );

    final Future<List<Response<dynamic>>> all = Future.wait(
      <Future<Response<dynamic>>>[
        client.dio.get<dynamic>('/me'),
        client.dio.get<dynamic>('/me/consents'),
        client.dio.patch<dynamic>('/me', data: <String, dynamic>{}),
        client.dio.post<dynamic>('/auth/logout'),
      ],
    );
    // Let every request fail with 401 and queue up behind the refresh.
    await pumpEventQueue();
    expect(client.api.requests, hasLength(4));
    releaseRefresh.complete();

    final List<Response<dynamic>> responses = await all;
    expect(
      responses.map((Response<dynamic> r) => r.statusCode),
      everyElement(200),
    );
    expect(client.refresh.requests, hasLength(1));
    // 4 originals + 4 retries, each path retried exactly once.
    expect(client.api.requests, hasLength(8));
    for (final String path in <String>['/me/consents', '/auth/logout']) {
      expect(client.api.requestsTo(path), hasLength(2));
    }
    expect(sessionExpiredCalls, 0);
  });

  test('a request that failed with an already replaced token is retried '
      'without another refresh', () async {
    final Completer<void> releaseSlow = Completer<void>();
    final client = build(
      api: (RequestOptions options) async {
        if (options.path == '/slow' &&
            _bearer(options) == 'Bearer stale-access') {
          await releaseSlow.future;
        }
        return acceptFreshTokenOnly(options);
      },
    );

    final Future<Response<dynamic>> slow = client.dio.get<dynamic>('/slow');
    await client.dio.get<dynamic>('/me'); // refreshes
    expect(client.refresh.requests, hasLength(1));
    releaseSlow.complete(); // now /slow gets its 401 with the old token

    expect((await slow).statusCode, 200);
    expect(client.refresh.requests, hasLength(1));
  });

  test('a request is retried only once: a second 401 is not refreshed '
      'again', () async {
    final client = build(
      api: (RequestOptions _) async =>
          const ScriptedResponse(401, _unauthorized),
    );

    await expectLater(
      client.dio.get<dynamic>('/me'),
      throwsA(
        isA<DioException>().having(
          (DioException e) => e.response?.statusCode,
          'status',
          401,
        ),
      ),
    );
    expect(client.api.requests, hasLength(2));
    expect(client.refresh.requests, hasLength(1));
  });

  test('refresh rejected by the server clears the session', () async {
    final client = build(
      api: acceptFreshTokenOnly,
      refresh: (RequestOptions _) async =>
          const ScriptedResponse(401, _unauthorized),
    );

    Object? failure;
    try {
      await client.dio.get<dynamic>('/me');
    } on DioException catch (error) {
      failure = error;
    }

    expect(failure, isA<DioException>());
    expect(
      AppErrorMapper.fromObject(failure!),
      const AppError.sessionExpired(),
    );
    expect(await tokenStore.read(), isNull);
    expect(sessionExpiredCalls, 1);
    // The original request is not retried.
    expect(client.api.requests, hasLength(1));
  });

  test('concurrent requests after a rejected refresh expire the session '
      'once', () async {
    final client = build(
      api: acceptFreshTokenOnly,
      refresh: (RequestOptions _) async =>
          const ScriptedResponse(400, _unauthorized),
    );

    final List<Object?> results = await Future.wait(<Future<Object?>>[
      for (final String path in <String>['/me', '/me/consents', '/x'])
        client.dio
            .get<dynamic>(path)
            .then<Object?>(
              (Response<dynamic> r) => r,
              onError: (Object error) => error,
            ),
    ]);

    expect(results, everyElement(isA<DioException>()));
    expect(client.refresh.requests, hasLength(1));
    expect(sessionExpiredCalls, 1);
    expect(await tokenStore.read(), isNull);
  });

  test('refresh failing without a response (offline) keeps the session and '
      'reports a network error', () async {
    final client = build(
      api: acceptFreshTokenOnly,
      refresh: (RequestOptions options) async => throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
      ),
    );

    Object? failure;
    try {
      await client.dio.get<dynamic>('/me');
    } on DioException catch (error) {
      failure = error;
    }

    expect(AppErrorMapper.fromObject(failure!), const AppError.network());
    expect(await tokenStore.read(), _stale);
    expect(sessionExpiredCalls, 0);
  });

  test('a 401 on a public endpoint is passed through untouched', () async {
    final client = build(
      api: (RequestOptions _) async =>
          const ScriptedResponse(401, _unauthorized),
    );
    await expectLater(
      client.dio.post<dynamic>(
        '/auth/otp/verify',
        options: AuthInterceptor.public(),
      ),
      throwsA(isA<DioException>()),
    );
    expect(client.api.requests, hasLength(1));
    expect(client.refresh.requests, isEmpty);
    expect(await tokenStore.read(), _stale);
  });

  test('without a session a 401 is not refreshed', () async {
    await tokenStore.clear();
    final client = build(
      api: (RequestOptions _) async =>
          const ScriptedResponse(401, _unauthorized),
    );
    await expectLater(
      client.dio.get<dynamic>('/me'),
      throwsA(isA<DioException>()),
    );
    expect(client.refresh.requests, isEmpty);
    expect(sessionExpiredCalls, 0);
  });

  test('other errors are not touched', () async {
    final client = build(
      api: (RequestOptions _) async =>
          ScriptedResponse(429, fixtureObject('problem_rate_limited.429.json')),
    );
    Object? failure;
    try {
      await client.dio.get<dynamic>('/me');
    } on DioException catch (error) {
      failure = error;
    }
    expect(
      AppErrorMapper.fromObject(failure!),
      const AppError(code: 'RATE_LIMITED', status: 429),
    );
    expect(client.refresh.requests, isEmpty);
  });
}
