import Core
import Foundation

/// Maps an `application/problem+json` body (RFC 9457) to `AppError`.
public enum ProblemDecoder {
    private struct Problem: Decodable {
        let code: String?
    }

    /// - Parameters:
    ///   - data: The response body. May be empty or not JSON at all.
    ///   - status: The HTTP status code of the response.
    public static func error(from data: Data, status: Int) -> AppError {
        if let problem = try? JSONDecoder().decode(Problem.self, from: data),
           let code = problem.code,
           !code.isEmpty {
            return AppError(code: code, status: status)
        }
        return AppError(code: fallbackCode(for: status), status: status)
    }

    private static func fallbackCode(for status: Int) -> String {
        switch status {
        case 401:
            return AppError.Code.unauthorized
        case 429:
            return AppError.Code.rateLimited
        default:
            return AppError.Code.unknown
        }
    }
}
