import 'package:dio/dio.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/error/app_error_mapper.dart';

/// Runs an API call and converts every failure into an [AppError], so that
/// nothing above the data layer depends on Dio or on JSON decoding details.
Future<T> apiCall<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on DioException catch (error) {
    throw AppErrorMapper.fromDioException(error);
  } on AppError {
    rethrow;
  } on Exception {
    // A response that does not match the contract (JSON shape mismatch).
    throw const AppError.unknown();
  } on TypeError {
    throw const AppError.unknown();
  }
}
