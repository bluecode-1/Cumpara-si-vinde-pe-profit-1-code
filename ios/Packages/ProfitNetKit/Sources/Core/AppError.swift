import Foundation

/// The single error type surfaced to the UI.
///
/// `code` is the stable machine-readable string from `application/problem+json`
/// (or one of the client-side codes below). User-facing text is looked up in
/// the app's string resources from `code`; server `detail` is never shown.
public struct AppError: Error, Equatable, Hashable, Sendable {
    public let code: String
    public let status: Int?

    public init(code: String, status: Int? = nil) {
        self.code = code
        self.status = status
    }

    /// Known error codes. Server codes are upper snake case as in the contract.
    public enum Code {
        public static let otpInvalid = "OTP_INVALID"
        public static let rateLimited = "RATE_LIMITED"
        /// Client-side: the request never reached the server.
        public static let network = "NETWORK"
        /// Client-side: there is no valid session (refresh failed or no tokens).
        public static let unauthorized = "UNAUTHORIZED"
        /// Client-side: a response body could not be decoded.
        public static let decoding = "DECODING"
        /// Client-side: anything else.
        public static let unknown = "UNKNOWN"
    }

    public static let network = AppError(code: Code.network)
    public static let unauthorized = AppError(code: Code.unauthorized, status: 401)
    public static let decoding = AppError(code: Code.decoding)
    public static let unknown = AppError(code: Code.unknown)

    /// Wraps any thrown error into an `AppError`.
    public static func wrapping(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        }
        return .unknown
    }
}
