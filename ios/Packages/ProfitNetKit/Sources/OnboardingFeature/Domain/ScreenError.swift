import Core
import DesignSystem
import Foundation

/// An error shown on a screen. Each occurrence has its own identity so that
/// showing the same message twice is still announced twice.
public struct ScreenError: Equatable, Sendable {
    public let key: L10nKey
    public let id: UUID

    public init(_ key: L10nKey, id: UUID = UUID()) {
        self.key = key
        self.id = id
    }
}

/// Maps errors to user-facing message keys. Server `detail` is never shown.
public enum ErrorMessages {
    public static func key(for error: Error) -> L10nKey {
        let appError = AppError.wrapping(error)
        switch appError.code {
        case AppError.Code.otpInvalid:
            return .errorOtpInvalid
        case AppError.Code.rateLimited:
            return .errorRateLimited
        case AppError.Code.network:
            return .errorNetwork
        default:
            return .errorGeneric
        }
    }
}
