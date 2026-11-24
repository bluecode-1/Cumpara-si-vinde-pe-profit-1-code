/// Stable error codes the client reacts to. Server codes come from the `code`
/// member of `application/problem+json`; the last three are client-side.
abstract final class AppErrorCode {
  static const String otpInvalid = 'OTP_INVALID';
  static const String rateLimited = 'RATE_LIMITED';

  /// No connectivity, DNS failure or a timeout: the request never completed.
  static const String network = 'NETWORK';

  /// The session could not be refreshed and has been cleared.
  static const String sessionExpired = 'SESSION_EXPIRED';

  /// Anything that does not carry a recognisable problem document.
  static const String unknown = 'UNKNOWN';
}

/// The single error type surfaced to the domain and presentation layers.
///
/// User-facing text is looked up from the app resources by [code]; the
/// server-provided `detail` is deliberately not carried along.
final class AppError implements Exception {
  const AppError({required this.code, this.status});

  const AppError.network() : code = AppErrorCode.network, status = null;

  const AppError.sessionExpired()
    : code = AppErrorCode.sessionExpired,
      status = 401;

  const AppError.unknown({this.status}) : code = AppErrorCode.unknown;

  /// Machine-readable code, e.g. `OTP_INVALID`.
  final String code;

  /// HTTP status, when the error originates from a response.
  final int? status;

  bool get isNetwork => code == AppErrorCode.network;

  @override
  bool operator ==(Object other) =>
      other is AppError && other.code == code && other.status == status;

  @override
  int get hashCode => Object.hash(code, status);

  @override
  String toString() => 'AppError(code: $code, status: $status)';
}
