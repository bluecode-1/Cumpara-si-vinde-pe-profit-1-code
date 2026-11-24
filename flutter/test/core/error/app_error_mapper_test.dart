import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/error/app_error_mapper.dart';
import 'package:profitnet/core/error/error_messages.dart';
import 'package:profitnet/core/network/api_call.dart';

import '../../support/fixtures.dart';
import '../../support/test_app.dart';

void main() {
  final RequestOptions request = RequestOptions(path: '/auth/otp/verify');

  DioException badResponse(int status, Object? body) =>
      DioException.badResponse(
        statusCode: status,
        requestOptions: request,
        response: Response<dynamic>(
          requestOptions: request,
          statusCode: status,
          data: body,
        ),
      );

  group('problem+json', () {
    test('OTP_INVALID fixture maps to code and status', () {
      final AppError error = AppErrorMapper.fromDioException(
        badResponse(422, fixtureObject('problem_otp_invalid.422.json')),
      );
      expect(error, const AppError(code: 'OTP_INVALID', status: 422));
    });

    test('RATE_LIMITED fixture maps to code and status', () {
      final AppError error = AppErrorMapper.fromDioException(
        badResponse(429, fixtureObject('problem_rate_limited.429.json')),
      );
      expect(error, const AppError(code: 'RATE_LIMITED', status: 429));
    });

    test('a body left as raw JSON text is still decoded', () {
      final AppError error = AppErrorMapper.fromResponse(
        status: 422,
        body: readFixture('problem_otp_invalid.422.json'),
      );
      expect(error, const AppError(code: 'OTP_INVALID', status: 422));
    });

    test('falls back to the status inside the document', () {
      final AppError error = AppErrorMapper.fromResponse(
        status: null,
        body: fixtureObject('problem_rate_limited.429.json'),
      );
      expect(error.status, 429);
    });

    test('the server detail is never carried into AppError', () {
      final AppError error = AppErrorMapper.fromResponse(
        status: 422,
        body: fixtureObject('problem_otp_invalid.422.json'),
      );
      expect(error.toString(), isNot(contains('expirat')));
    });
  });

  group('non-problem responses', () {
    for (final Object? body in <Object?>[
      null,
      '<html>Bad gateway</html>',
      <String, dynamic>{'message': 'no code member'},
      <dynamic>[1, 2, 3],
      '',
    ]) {
      test('body $body -> UNKNOWN with the HTTP status', () {
        expect(
          AppErrorMapper.fromDioException(badResponse(502, body)),
          const AppError.unknown(status: 502),
        );
      });
    }
  });

  group('transport failures', () {
    for (final DioExceptionType type in <DioExceptionType>[
      DioExceptionType.connectionError,
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
    ]) {
      test('${type.name} -> NETWORK', () {
        final AppError error = AppErrorMapper.fromDioException(
          DioException(requestOptions: request, type: type),
        );
        expect(error, const AppError.network());
        expect(error.isNetwork, isTrue);
        expect(error.status, isNull);
      });
    }

    test('cancel / unknown -> UNKNOWN', () {
      expect(
        AppErrorMapper.fromDioException(
          DioException(requestOptions: request, type: DioExceptionType.cancel),
        ),
        const AppError.unknown(),
      );
      expect(
        AppErrorMapper.fromObject(StateError('x')),
        const AppError.unknown(),
      );
    });

    test('an AppError produced by an interceptor passes through', () {
      expect(
        AppErrorMapper.fromDioException(
          badResponse(
            401,
            null,
          ).copyWith(error: const AppError.sessionExpired()),
        ),
        const AppError.sessionExpired(),
      );
    });
  });

  group('apiCall', () {
    test('rethrows Dio failures as AppError', () {
      expect(
        apiCall<void>(
          () async => throw DioException(
            requestOptions: request,
            type: DioExceptionType.connectionError,
          ),
        ),
        throwsA(const AppError.network()),
      );
    });

    test('a response that does not match the contract becomes UNKNOWN', () {
      expect(
        apiCall<void>(() async => throw const FormatException('bad json')),
        throwsA(const AppError.unknown()),
      );
      expect(
        apiCall<String>(() async => (null as dynamic) as String),
        throwsA(const AppError.unknown()),
      );
    });
  });

  group('user-facing messages come from resources, by code', () {
    test('known codes', () {
      expect(
        messageForError(ro, const AppError(code: 'OTP_INVALID', status: 422)),
        'Codul nu este corect sau a expirat.',
      );
      expect(
        messageForError(ro, const AppError(code: 'RATE_LIMITED', status: 429)),
        'Prea multe încercări. Încearcă din nou peste câteva minute.',
      );
      expect(
        messageForError(ro, const AppError.network()),
        'Nu există conexiune la internet. Verifică rețeaua și încearcă din nou.',
      );
    });

    test('anything else gets the generic message', () {
      expect(
        messageForError(ro, const AppError(code: 'SOMETHING_NEW', status: 400)),
        'Ceva nu a mers. Încearcă din nou.',
      );
      expect(
        messageForError(ro, const AppError.unknown(status: 500)),
        ro.errorGeneric,
      );
    });
  });
}
