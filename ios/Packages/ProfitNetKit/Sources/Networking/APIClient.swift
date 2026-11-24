import Core
import Foundation

/// The HTTP client used by all repositories.
///
/// - Attaches the access token to authenticated endpoints.
/// - On 401 performs one serialised refresh and repeats the request once.
/// - Maps `application/problem+json` and transport failures to `AppError`.
///   Every error thrown by `send` is an `AppError` (or `CancellationError`).
public final class APIClient: Sendable {
    /// Emits a value every time the session was cleared because the refresh
    /// was rejected. The app listens and routes the user back to Welcome.
    /// An `AsyncStream` supports a single consumer.
    public let sessionExpired: AsyncStream<Void>

    private let transport: HTTPTransport
    private let refresher: TokenRefresher

    /// - Parameters:
    ///   - baseURL: For example `https://api.profitnet.example/v1`.
    ///   - session: The session to use. Pass one created with
    ///     `PinningDelegate` as its delegate to enable public-key pinning.
    ///   - tokenStore: Where the session tokens live.
    public init(baseURL: URL, session: URLSession, tokenStore: TokenStore) {
        let (stream, continuation) = AsyncStream<Void>.makeStream(bufferingPolicy: .bufferingNewest(1))
        self.sessionExpired = stream
        let transport = HTTPTransport(baseURL: baseURL, session: session)
        self.transport = transport
        self.refresher = TokenRefresher(
            tokenStore: tokenStore,
            transport: transport,
            onSessionCleared: {
                continuation.yield(())
            }
        )
    }

    /// Performs the call and decodes the JSON response body.
    public func send<Response: Decodable>(
        _ endpoint: Endpoint,
        as type: Response.Type = Response.self
    ) async throws -> Response {
        let body = try await perform(endpoint)
        do {
            return try JSONCoding.makeDecoder().decode(Response.self, from: body)
        } catch {
            throw AppError.decoding
        }
    }

    /// Performs a call whose successful response has no body (204).
    public func sendExpectingNoContent(_ endpoint: Endpoint) async throws {
        _ = try await perform(endpoint)
    }

    private func perform(_ endpoint: Endpoint) async throws -> Data {
        var accessToken: String?
        if endpoint.requiresAuth {
            guard let token = await refresher.currentAccessToken() else {
                throw AppError.unauthorized
            }
            accessToken = token
        }

        var (data, response) = try await transport.perform(endpoint, accessToken: accessToken)

        if response.statusCode == 401, endpoint.requiresAuth {
            let newToken = try await refresher.refreshedAccessToken(replacing: accessToken)
            (data, response) = try await transport.perform(endpoint, accessToken: newToken)
        }

        guard (200..<300).contains(response.statusCode) else {
            throw ProblemDecoder.error(from: data, status: response.statusCode)
        }
        return data
    }
}
