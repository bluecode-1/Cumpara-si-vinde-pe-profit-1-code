import 'package:dio/dio.dart';
import 'package:profitnet/core/network/auth_interceptor.dart';
import 'package:profitnet/features/onboarding/data/dto/auth_session_dto.dart';
import 'package:profitnet/features/onboarding/data/dto/category_dto.dart';
import 'package:profitnet/features/onboarding/data/dto/consent_dto.dart';
import 'package:profitnet/features/onboarding/data/dto/me_dto.dart';
import 'package:profitnet/features/onboarding/data/dto/otp_dtos.dart';

/// Typed access to the endpoints used during onboarding. Paths and shapes
/// follow `api/openapi.yaml`.
final class OnboardingApi {
  const OnboardingApi(this._dio);

  final Dio _dio;

  Future<OtpChallengeDto> requestOtp(OtpRequestDto body) async {
    final Response<Map<String, dynamic>> response = await _dio
        .post<Map<String, dynamic>>(
          '/auth/otp/request',
          data: body.toJson(),
          options: AuthInterceptor.public(),
        );
    return OtpChallengeDto.fromJson(response.data!);
  }

  Future<AuthSessionDto> verifyOtp(OtpVerifyRequestDto body) async {
    final Response<Map<String, dynamic>> response = await _dio
        .post<Map<String, dynamic>>(
          '/auth/otp/verify',
          data: body.toJson(),
          options: AuthInterceptor.public(),
        );
    return AuthSessionDto.fromJson(response.data!);
  }

  Future<MeDto> updateMe(MeUpdateDto body) async {
    final Response<Map<String, dynamic>> response = await _dio
        .patch<Map<String, dynamic>>('/me', data: body.toJson());
    return MeDto.fromJson(response.data!);
  }

  Future<void> setConsents(List<ConsentUpdateDto> body) => _dio.put<void>(
    '/me/consents',
    data: <Map<String, dynamic>>[
      for (final ConsentUpdateDto consent in body) consent.toJson(),
    ],
  );

  Future<List<CategoryDto>> listCategories() async {
    final Response<List<dynamic>> response = await _dio.get<List<dynamic>>(
      '/categories',
      options: AuthInterceptor.public(),
    );
    return <CategoryDto>[
      for (final Object? item in response.data!)
        CategoryDto.fromJson(item! as Map<String, dynamic>),
    ];
  }
}
