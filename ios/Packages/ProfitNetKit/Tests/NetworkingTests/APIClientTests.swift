import Core
import Networking
import XCTest

/// Session behaviour of `APIClient`: token attachment, the single-flight
/// refresh on 401, the single retry and error mapping.
final class APIClientTests: XCTestCase {
    private let oldTokens = TokenPair(accessToken: "access-1", refreshToken: "refresh-1", expiresInSeconds: 900)
    /// The access token inside `auth_refresh.200.json`.
    private let refreshedAccessToken = "fixture.access.token.2"

    private let mePath = "/v1/me"
    private let refreshPath = "/v1/auth/refresh"

    override func tearDown() {
        StubURLProtocol.reset()
        super.tearDown()
    }

    private func makeClient(tokens: TokenPair?) throws -> (APIClient, InMemoryTokenStore) {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        let store = InMemoryTokenStore(tokens: tokens)
        let baseURL = try XCTUnwrap(URL(string: "https://api.test/v1"))
        let client = APIClient(
            baseURL: baseURL,
            session: URLSession(configuration: configuration),
            tokenStore: store
        )
        return (client, store)
    }

    /// A server where `/me` accepts only the refreshed token and
    /// `/auth/refresh` answers with `refreshResponse`.
    private func installServer(
        refreshResponse: StubResponse,
        refreshDelay: TimeInterval = 0
    ) throws {
        let meBody = try Fixture.data("me.new.200")
        let validAuthorization = "Bearer " + refreshedAccessToken
        let mePath = self.mePath
        let refreshPath = self.refreshPath
        StubURLProtocol.setHandler { request in
            if request.path == refreshPath {
                if refreshDelay > 0 {
                    Thread.sleep(forTimeInterval: refreshDelay)
                }
                return refreshResponse
            }
            if request.path == mePath {
                if request.authorization == validAuthorization {
                    return .json(200, meBody)
                }
                return .problem(401, code: "TOKEN_EXPIRED")
            }
            return .problem(404, code: "NOT_FOUND")
        }
    }

    private func assertThrows(
        _ expected: AppError,
        file: StaticString = #filePath,
        line: UInt = #line,
        _ operation: () async throws -> Void
    ) async {
        do {
            try await operation()
            XCTFail("Expected \(expected) to be thrown", file: file, line: line)
        } catch {
            XCTAssertEqual(error as? AppError, expected, file: file, line: line)
        }
    }

    // MARK: - Token attachment

    func testAttachesAccessTokenToAuthenticatedRequests() async throws {
        let meBody = try Fixture.data("me.new.200")
        StubURLProtocol.setHandler { _ in .json(200, meBody) }
        let (client, _) = try makeClient(tokens: oldTokens)

        let me = try await client.send(APIEndpoints.me(), as: Me.self)

        XCTAssertEqual(me.phone, "+40712345678")
        XCTAssertEqual(StubURLProtocol.requests.count, 1)
        XCTAssertEqual(StubURLProtocol.requests.first?.method, "GET")
        XCTAssertEqual(StubURLProtocol.requests.first?.authorization, "Bearer access-1")
    }

    func testDoesNotAttachTokenToPublicEndpoints() async throws {
        let body = try Fixture.data("categories.200")
        StubURLProtocol.setHandler { _ in .json(200, body) }
        let (client, _) = try makeClient(tokens: oldTokens)

        let categories = try await client.send(APIEndpoints.categories(), as: [CatalogCategory].self)

        XCTAssertEqual(categories.count, 8)
        XCTAssertNil(StubURLProtocol.requests.first?.authorization)
    }

    func testAuthenticatedRequestWithoutSessionFailsWithoutNetworkCall() async throws {
        StubURLProtocol.setHandler { _ in .empty(200) }
        let (client, _) = try makeClient(tokens: nil)

        await assertThrows(.unauthorized) {
            _ = try await client.send(APIEndpoints.me(), as: Me.self)
        }
        XCTAssertTrue(StubURLProtocol.requests.isEmpty)
    }

    // MARK: - Refresh

    func testRefreshesOnceAndRetriesOnceAfter401() async throws {
        try installServer(refreshResponse: .json(200, Fixture.data("auth_refresh.200")))
        let (client, store) = try makeClient(tokens: oldTokens)

        let me = try await client.send(APIEndpoints.me(), as: Me.self)

        XCTAssertEqual(me.id, "0193f6a0-2a00-7000-8000-000000000001")
        XCTAssertEqual(StubURLProtocol.requestCount(path: refreshPath), 1)
        XCTAssertEqual(StubURLProtocol.requestCount(path: mePath), 2)

        // The request was first sent with the old token, then with the new one.
        let meRequests = StubURLProtocol.requests.filter { $0.path == mePath }
        XCTAssertEqual(meRequests.map(\.authorization), ["Bearer access-1", "Bearer " + refreshedAccessToken])

        // The refresh call carries the refresh token and no access token.
        let refreshRequest = try XCTUnwrap(StubURLProtocol.requests.first { $0.path == refreshPath })
        XCTAssertEqual(refreshRequest.method, "POST")
        XCTAssertNil(refreshRequest.authorization)
        let refreshBody = try XCTUnwrap(refreshRequest.body)
        let refreshObject = try JSONSerialization.jsonObject(with: refreshBody) as? [String: String]
        XCTAssertEqual(refreshObject, ["refreshToken": "refresh-1"])

        // The rotated pair was stored.
        let stored = try store.load()
        XCTAssertEqual(stored?.accessToken, refreshedAccessToken)
        XCTAssertEqual(stored?.refreshToken, "fixture-refresh-token-2")
    }

    func testConcurrent401sRefreshOnlyOnce() async throws {
        try installServer(
            refreshResponse: .json(200, Fixture.data("auth_refresh.200")),
            refreshDelay: 0.1
        )
        let (client, store) = try makeClient(tokens: oldTokens)
        let requestCount = 8

        let phones = try await withThrowingTaskGroup(of: String.self) { group -> [String] in
            for _ in 0..<requestCount {
                group.addTask {
                    try await client.send(APIEndpoints.me(), as: Me.self).phone
                }
            }
            var results: [String] = []
            for try await phone in group {
                results.append(phone)
            }
            return results
        }

        XCTAssertEqual(phones.count, requestCount)
        XCTAssertEqual(StubURLProtocol.requestCount(path: refreshPath), 1)
        XCTAssertEqual(try store.load()?.accessToken, refreshedAccessToken)
        // No request was retried more than once.
        XCTAssertLessThanOrEqual(StubURLProtocol.requestCount(path: mePath), requestCount * 2)
    }

    func testRejectedRefreshClearsSessionAndSignalsExpiry() async throws {
        try installServer(refreshResponse: .problem(401, code: "REFRESH_TOKEN_REVOKED"))
        let (client, store) = try makeClient(tokens: oldTokens)

        await assertThrows(.unauthorized) {
            _ = try await client.send(APIEndpoints.me(), as: Me.self)
        }

        XCTAssertNil(try store.load())
        XCTAssertEqual(StubURLProtocol.requestCount(path: refreshPath), 1)
        // The original request is not repeated after a failed refresh.
        XCTAssertEqual(StubURLProtocol.requestCount(path: mePath), 1)

        // The expiry was signalled (the value is buffered until consumed).
        var iterator = client.sessionExpired.makeAsyncIterator()
        let signal: Void? = await iterator.next()
        XCTAssertTrue(signal != nil)
    }

    func testConcurrentRequestsWithRejectedRefreshAllFailAndRefreshOnce() async throws {
        try installServer(
            refreshResponse: .problem(401, code: "REFRESH_TOKEN_REVOKED"),
            refreshDelay: 0.1
        )
        let (client, store) = try makeClient(tokens: oldTokens)

        let failures = await withTaskGroup(of: Bool.self) { group -> Int in
            for _ in 0..<5 {
                group.addTask {
                    do {
                        _ = try await client.send(APIEndpoints.me(), as: Me.self)
                        return false
                    } catch {
                        return (error as? AppError) == .unauthorized
                    }
                }
            }
            var count = 0
            for await failed in group where failed {
                count += 1
            }
            return count
        }

        XCTAssertEqual(failures, 5)
        XCTAssertNil(try store.load())
        XCTAssertEqual(StubURLProtocol.requestCount(path: refreshPath), 1)
    }

    func testUndecodableRefreshResponseClearsSession() async throws {
        try installServer(refreshResponse: .json(200, Data("{}".utf8)))
        let (client, store) = try makeClient(tokens: oldTokens)

        await assertThrows(.unauthorized) {
            _ = try await client.send(APIEndpoints.me(), as: Me.self)
        }
        XCTAssertNil(try store.load())
    }

    func testConnectivityFailureDuringRefreshKeepsSession() async throws {
        try installServer(refreshResponse: .failure(URLError(.notConnectedToInternet)))
        let (client, store) = try makeClient(tokens: oldTokens)

        await assertThrows(.network) {
            _ = try await client.send(APIEndpoints.me(), as: Me.self)
        }
        XCTAssertEqual(try store.load(), oldTokens)
    }

    func testSecond401AfterRefreshIsNotRetriedAgain() async throws {
        let refreshBody = try Fixture.data("auth_refresh.200")
        let refreshPath = self.refreshPath
        StubURLProtocol.setHandler { request in
            if request.path == refreshPath {
                return .json(200, refreshBody)
            }
            return .problem(401, code: "TOKEN_EXPIRED")
        }
        let (client, _) = try makeClient(tokens: oldTokens)

        await assertThrows(AppError(code: "TOKEN_EXPIRED", status: 401)) {
            _ = try await client.send(APIEndpoints.me(), as: Me.self)
        }
        XCTAssertEqual(StubURLProtocol.requestCount(path: refreshPath), 1)
        XCTAssertEqual(StubURLProtocol.requestCount(path: mePath), 2)
    }

    func test401OnPublicEndpointDoesNotRefresh() async throws {
        StubURLProtocol.setHandler { _ in .problem(401, code: "SOMETHING") }
        let (client, store) = try makeClient(tokens: oldTokens)

        await assertThrows(AppError(code: "SOMETHING", status: 401)) {
            _ = try await client.send(
                APIEndpoints.verifyOTP(challengeId: "c", code: "000000"),
                as: AuthSession.self
            )
        }
        XCTAssertEqual(StubURLProtocol.requests.count, 1)
        XCTAssertEqual(try store.load(), oldTokens)
    }

    // MARK: - Error mapping

    func testProblemResponseBecomesAppError() async throws {
        let body = try Fixture.data("problem_otp_invalid.422")
        StubURLProtocol.setHandler { _ in
            .http(status: 422, body: body, contentType: "application/problem+json")
        }
        let (client, _) = try makeClient(tokens: nil)

        await assertThrows(AppError(code: "OTP_INVALID", status: 422)) {
            _ = try await client.send(
                APIEndpoints.verifyOTP(challengeId: "c", code: "000000"),
                as: AuthSession.self
            )
        }
    }

    func testRateLimitedProblem() async throws {
        let body = try Fixture.data("problem_rate_limited.429")
        StubURLProtocol.setHandler { _ in
            .http(status: 429, body: body, contentType: "application/problem+json")
        }
        let (client, _) = try makeClient(tokens: nil)

        await assertThrows(AppError(code: "RATE_LIMITED", status: 429)) {
            _ = try await client.send(APIEndpoints.requestOTP(phone: "+40712345678"), as: OTPChallenge.self)
        }
    }

    func testNoConnectionBecomesNetworkError() async throws {
        StubURLProtocol.setHandler { _ in .failure(URLError(.notConnectedToInternet)) }
        let (client, _) = try makeClient(tokens: nil)

        await assertThrows(.network) {
            _ = try await client.send(APIEndpoints.requestOTP(phone: "+40712345678"), as: OTPChallenge.self)
        }
    }

    func testUndecodableSuccessBodyBecomesDecodingError() async throws {
        StubURLProtocol.setHandler { _ in .json(200, Data("[]".utf8)) }
        let (client, _) = try makeClient(tokens: nil)

        await assertThrows(.decoding) {
            _ = try await client.send(APIEndpoints.requestOTP(phone: "+40712345678"), as: OTPChallenge.self)
        }
    }

    func testAcceptedResponseDecodes() async throws {
        let body = try Fixture.data("auth_otp_request.202")
        StubURLProtocol.setHandler { _ in .json(202, body) }
        let (client, _) = try makeClient(tokens: nil)

        let challenge = try await client.send(
            APIEndpoints.requestOTP(phone: "+40712345678"),
            as: OTPChallenge.self
        )

        XCTAssertEqual(challenge.retryAfterSeconds, 30)
        XCTAssertEqual(StubURLProtocol.requests.first?.path, "/v1/auth/otp/request")
    }

    func testNoContentResponseSucceeds() async throws {
        StubURLProtocol.setHandler { _ in .empty(204) }
        let (client, _) = try makeClient(tokens: oldTokens)

        try await client.sendExpectingNoContent(
            APIEndpoints.setConsents([ConsentInput(purpose: .terms, granted: true)])
        )

        XCTAssertEqual(StubURLProtocol.requests.first?.method, "PUT")
        XCTAssertEqual(StubURLProtocol.requests.first?.path, "/v1/me/consents")
        XCTAssertEqual(StubURLProtocol.requests.first?.authorization, "Bearer access-1")
    }
}

final class PinningDelegateTests: XCTestCase {
    func testEmptyPinSetDisablesPinning() {
        XCTAssertFalse(PinningDelegate().isEnabled)
        XCTAssertTrue(PinningDelegate(pinnedKeyHashes: ["abc"]).isEnabled)
    }

    func testPinIsBase64OfSHA256() {
        // SHA-256 of the empty input.
        XCTAssertEqual(
            PinningDelegate.pin(forPublicKeyData: Data()),
            "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU="
        )
    }
}
