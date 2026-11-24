import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/error/problem_dto.dart';

/// Converts transport-level failures into [AppError].
abstract final class AppErrorMapper {
  /// Maps any error thrown by a Dio call.
  static AppError fromObject(Object error) => switch (error) {
    final AppError appError => appError,
    final DioException dioException => fromDioException(dioException),
    _ => const AppError.unknown(),
  };

  static AppError fromDioException(DioException exception) {
    // An interceptor may already have produced the final error.
    final Object? inner = exception.error;
    if (inner is AppError) {
      return inner;
    }
    final Response<dynamic>? response = exception.response;
    if (response != null) {
      return fromResponse(status: response.statusCode, body: response.data);
    }
    return switch (exception.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const AppError.network(),
      _ => const AppError.unknown(),
    };
  }

  /// Maps an error response. [body] may be a decoded JSON map or, when the
  /// transformer did not recognise the content type, the raw JSON text.
  static AppError fromResponse({required int? status, required Object? body}) {
    final ProblemDto? problem = _parseProblem(body);
    if (problem == null) {
      return AppError.unknown(status: status);
    }
    return AppError(code: problem.code, status: status ?? problem.status);
  }

  static ProblemDto? _parseProblem(Object? body) {
    try {
      final Object? decoded = body is String ? jsonDecode(body) : body;
      if (decoded is Map<String, dynamic>) {
        return ProblemDto.fromJson(decoded);
      }
    } on Object {
      // Not a problem document (HTML error page, truncated body...).
    }
    return null;
  }
}
