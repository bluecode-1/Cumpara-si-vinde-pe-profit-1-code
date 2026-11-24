import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/error/app_error_mapper.dart';
import 'package:profitnet/core/network/api_config.dart';
import 'package:profitnet/core/network/auth_interceptor.dart';
import 'package:profitnet/core/network/dio_provider.dart';
import 'package:profitnet/core/network/fake_api_interceptor.dart';
import 'package:profitnet/core/security/auth_tokens.dart';
import 'package:profitnet/core/security/token_store.dart';

import '../../support/fixtures.dart';

void main() {
  late FakeApiInterceptor fake;
  late InMemoryTokenStore tokenStore;
  late Dio dio;

  setUp(() {
    fake = FakeApiInterceptor(loadFixture: loadSharedFixture);
    tokenStore = InMemoryTokenStore();
    dio = createApiClient(
      config: const ApiConfig(
        baseUrl: 'https://api.invalid/v1',
        useFakeApi: true,
      ),
      tokenStore: tokenStore,
      onSessionExpired: () async {},
      fakeApi: fake,
    );
    addTearDown(dio.close);
  });

  Future<AppError> errorOf(Future<Object?> call) async {
    try {
      await call;
    } on DioException catch (error) {
      return AppErrorMapper.fromDioException(error);
    }
    fail('expected the call to fail');
  }

  Future<void> signIn() => tokenStore.write(
    const AuthTokens(accessToken: 'fixture.access.token', refreshToken: 'r'),
  );

  test('any valid number gets the "code sent" fixture', () async {
    for (final String phone in <String>['+40712345678', '+40799000111']) {
      final Response<dynamic> response = await dio.post<dynamic>(
        '/auth/otp/request',
        data: <String, String>{'phone': phone},
        options: AuthInterceptor.public(),
      );
      expect(response.statusCode, 202);
      expect(response.data, fixtureObject('auth_otp_request.202.json'));
    }
  });

  test('an invalid number is rejected', () async {
    final AppError error = await errorOf(
      dio.post<dynamic>(
        '/auth/otp/request',
        data: <String, String>{'phone': '0712345678'},
        options: AuthInterceptor.public(),
      ),
    );
    expect(error.status, 422);
  });

  test('code 123456 authenticates with the verify fixture', () async {
    final Response<dynamic> response = await dio.post<dynamic>(
      '/auth/otp/verify',
      data: <String, String>{'challengeId': 'c', 'code': '123456'},
      options: AuthInterceptor.public(),
    );
    expect(response.statusCode, 200);
    expect(response.data, fixtureObject('auth_otp_verify.200.json'));
  });

  test('any other code returns OTP_INVALID (422)', () async {
    for (final String code in <String>['000000', '123457', '12345', '']) {
      final AppError error = await errorOf(
        dio.post<dynamic>(
          '/auth/otp/verify',
          data: <String, String>{'challengeId': 'c', 'code': code},
          options: AuthInterceptor.public(),
        ),
      );
      expect(error, const AppError(code: 'OTP_INVALID', status: 422));
    }
  });

  test('authenticated endpoints require a token', () async {
    final AppError error = await errorOf(dio.get<dynamic>('/me'));
    expect(error.status, 401);
  });

  test('GET /me starts from the new-user fixture', () async {
    await signIn();
    final Response<dynamic> response = await dio.get<dynamic>('/me');
    expect(response.data, fixtureObject('me.new.200.json'));
  });

  test('PATCH /me keeps changes in memory', () async {
    await signIn();
    await dio.patch<dynamic>(
      '/me',
      data: <String, dynamic>{'displayName': 'Ioana'},
    );
    await dio.patch<dynamic>(
      '/me',
      data: <String, dynamic>{
        'homeLocation': <String, dynamic>{'lat': 46.77, 'lng': 23.6},
      },
    );
    final Response<dynamic> patched = await dio.patch<dynamic>(
      '/me',
      data: <String, dynamic>{
        'interestCategoryIds': <String>['a', 'b'],
        'onboardingCompleted': true,
      },
    );

    final Map<String, dynamic> me =
        (await dio.get<dynamic>('/me')).data as Map<String, dynamic>;
    expect(patched.data, me);
    expect(me['displayName'], 'Ioana');
    expect(me['homeLocation'], <String, dynamic>{'lat': 46.77, 'lng': 23.6});
    expect(me['onboardingCompleted'], isTrue);
    expect(me['phone'], '+40712345678');
    expect(fake.interestCategoryIds, <String>['a', 'b']);

    // A later sign-in returns the updated user, like a real backend would.
    final Response<dynamic> session = await dio.post<dynamic>(
      '/auth/otp/verify',
      data: <String, String>{'challengeId': 'c', 'code': '123456'},
      options: AuthInterceptor.public(),
    );
    final Map<String, dynamic> body = session.data as Map<String, dynamic>;
    expect((body['user'] as Map<String, dynamic>)['displayName'], 'Ioana');
    expect(body['isNewUser'], isFalse);
  });

  test('PUT /me/consents keeps decisions in memory, last write wins', () async {
    await signIn();
    Future<Response<dynamic>> put(String purpose, bool granted) =>
        dio.put<dynamic>(
          '/me/consents',
          data: <Map<String, dynamic>>[
            <String, dynamic>{
              'purpose': purpose,
              'granted': granted,
              'policyVersion': '2026-11',
            },
          ],
        );

    expect((await put('TERMS', true)).statusCode, 204);
    await put('MARKETING', true);
    await put('MARKETING', false);

    final List<dynamic> consents =
        (await dio.get<dynamic>('/me/consents')).data as List<dynamic>;
    expect(consents, hasLength(2));
    final Map<String, bool> byPurpose = <String, bool>{
      for (final Map<String, dynamic> consent
          in consents.cast<Map<String, dynamic>>())
        consent['purpose'] as String: consent['granted'] as bool,
    };
    expect(byPurpose, <String, bool>{'TERMS': true, 'MARKETING': false});
    expect(
      consents.cast<Map<String, dynamic>>().first.keys,
      containsAll(<String>['purpose', 'granted', 'policyVersion', 'updatedAt']),
    );
  });

  test('categories, refresh and logout', () async {
    expect(
      (await dio.get<dynamic>(
        '/categories',
        options: AuthInterceptor.public(),
      )).data,
      decodeFixture('categories.200.json'),
    );
    await signIn();
    expect((await dio.post<dynamic>('/auth/logout')).statusCode, 204);
  });

  test('unknown endpoints answer 404', () async {
    await signIn();
    expect((await errorOf(dio.get<dynamic>('/listings'))).status, 404);
  });

  test('the fake is opt-in: disabled by default configuration', () {
    expect(const ApiConfig.fromEnvironment().useFakeApi, isFalse);
    expect(const ApiConfig.fromEnvironment().pinning.isEnabled, isFalse);
  });
}
