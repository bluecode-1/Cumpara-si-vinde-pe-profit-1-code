import 'package:dio/dio.dart';
import 'package:profitnet/core/network/api_call.dart';
import 'package:profitnet/features/home/domain/logout_repository.dart';

/// [LogoutRepository] on the REST API.
final class LogoutRepositoryImpl implements LogoutRepository {
  const LogoutRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> logout() => apiCall(() => _dio.post<void>('/auth/logout'));
}
