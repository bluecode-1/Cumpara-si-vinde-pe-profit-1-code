import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

/// Loads one file of `api/fixtures` by name.
typedef FixtureLoader = Future<String> Function(String fileName);

Future<String> _loadBundledFixture(String fileName) =>
    rootBundle.loadString('assets/fixtures/$fileName');

/// Development-only stand-in for the backend (spec: "Mod demonstrativ").
///
/// Answers the onboarding endpoints with the shared `api/fixtures` files:
///
///  * any valid phone number gets the "code sent" response;
///  * code `123456` authenticates, any other code yields `OTP_INVALID`;
///  * `PATCH /me` and `PUT /me/consents` keep their changes in memory for
///    the lifetime of the process.
///
/// It is installed only when `FAKE_API=true` **and** the build is not a
/// release build; see `dio_provider.dart`.
final class FakeApiInterceptor extends Interceptor {
  FakeApiInterceptor({this._loadFixture = _loadBundledFixture});

  /// The only code the fake accepts.
  static const String validCode = '123456';

  static final RegExp _e164RomanianMobile = RegExp(r'^\+407\d{8}$');

  final FixtureLoader _loadFixture;

  Map<String, dynamic>? _me;
  List<Map<String, dynamic>>? _consents;

  /// Interests sent with `PATCH /me`; not part of the `Me` schema.
  List<String> interestCategoryIds = const <String>[];

  /// Current in-memory consent state, for assertions in tests.
  List<Map<String, dynamic>> get consents =>
      List<Map<String, dynamic>>.unmodifiable(
        _consents ?? const <Map<String, dynamic>>[],
      );

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final _FakeResponse fake = await _handle(options);
    final Response<dynamic> response = Response<dynamic>(
      requestOptions: options,
      statusCode: fake.status,
      data: fake.body,
      headers: Headers.fromMap(<String, List<String>>{
        Headers.contentTypeHeader: <String>[
          fake.status >= 400
              ? 'application/problem+json'
              : Headers.jsonContentType,
        ],
      }),
    );
    if (fake.status >= 400) {
      handler.reject(
        DioException.badResponse(
          statusCode: fake.status,
          requestOptions: options,
          response: response,
        ),
        true,
      );
    } else {
      handler.resolve(response, true);
    }
  }

  Future<_FakeResponse> _handle(RequestOptions options) async {
    final String route =
        '${options.method.toUpperCase()} ${_endpoint(options)}';
    final Object? body = options.data;
    switch (route) {
      case 'POST /auth/otp/request':
        final Object? phone = body is Map ? body['phone'] : null;
        if (phone is! String || !_e164RomanianMobile.hasMatch(phone)) {
          return _problem(422, 'VALIDATION_FAILED');
        }
        (await _currentMe())['phone'] = phone;
        return _FakeResponse(202, await _fixture('auth_otp_request.202.json'));
      case 'POST /auth/otp/verify':
        final Object? code = body is Map ? body['code'] : null;
        if (code != validCode) {
          return _FakeResponse(
            422,
            await _fixture('problem_otp_invalid.422.json'),
          );
        }
        final Map<String, dynamic> session =
            await _fixture('auth_otp_verify.200.json') as Map<String, dynamic>;
        final Map<String, dynamic> me = await _currentMe();
        session['user'] = _copy(me);
        session['isNewUser'] = me['onboardingCompleted'] != true;
        return _FakeResponse(200, session);
      case 'POST /auth/refresh':
        return _FakeResponse(200, await _fixture('auth_refresh.200.json'));
      case 'GET /categories':
        return _FakeResponse(200, await _fixture('categories.200.json'));
    }
    // Everything below requires a session.
    if (options.headers['Authorization'] == null) {
      return _problem(401, 'UNAUTHENTICATED');
    }
    switch (route) {
      case 'POST /auth/logout':
        return const _FakeResponse(204, null);
      case 'GET /me':
        return _FakeResponse(200, _copy(await _currentMe()));
      case 'PATCH /me':
        if (body is! Map) {
          return _problem(422, 'VALIDATION_FAILED');
        }
        final Map<String, dynamic> me = await _currentMe();
        for (final String key in const <String>[
          'displayName',
          'locale',
          'currency',
          'homeLocation',
          'onboardingCompleted',
        ]) {
          if (body.containsKey(key)) {
            me[key] = body[key];
          }
        }
        final Object? interests = body['interestCategoryIds'];
        if (interests is List) {
          interestCategoryIds = interests.cast<String>().toList();
        }
        return _FakeResponse(200, _copy(me));
      case 'GET /me/consents':
        return _FakeResponse(200, _copy(await _currentConsents()));
      case 'PUT /me/consents':
        if (body is! List) {
          return _problem(422, 'VALIDATION_FAILED');
        }
        final List<Map<String, dynamic>> consents = await _currentConsents();
        for (final Map<String, dynamic> update
            in body.cast<Map<String, dynamic>>()) {
          consents
            ..removeWhere(
              (Map<String, dynamic> c) => c['purpose'] == update['purpose'],
            )
            ..add(<String, dynamic>{
              ...update,
              'updatedAt': DateTime.now().toUtc().toIso8601String(),
            });
        }
        return const _FakeResponse(204, null);
    }
    return _problem(404, 'NOT_FOUND');
  }

  /// The request path relative to the API root, e.g. `/me/consents`.
  static String _endpoint(RequestOptions options) {
    final String path = options.uri.path;
    final String basePath = Uri.parse(options.baseUrl).path;
    final String relative = basePath.isNotEmpty && path.startsWith(basePath)
        ? path.substring(basePath.length)
        : path;
    return relative.startsWith('/') ? relative : '/$relative';
  }

  Future<Map<String, dynamic>> _currentMe() async =>
      _me ??= await _fixture('me.new.200.json') as Map<String, dynamic>;

  Future<List<Map<String, dynamic>>> _currentConsents() async =>
      _consents ??= <Map<String, dynamic>>[];

  Future<Object?> _fixture(String fileName) async =>
      jsonDecode(await _loadFixture(fileName));

  /// Deep copy, so that callers can never mutate the fake's state.
  static Object? _copy(Object? json) => jsonDecode(jsonEncode(json));

  static _FakeResponse _problem(int status, String code) =>
      _FakeResponse(status, <String, dynamic>{
        'type': 'about:blank',
        'title': code,
        'status': status,
        'code': code,
      });
}

final class _FakeResponse {
  const _FakeResponse(this.status, this.body);

  final int status;
  final Object? body;
}
