#if DEBUG
@testable import FakeAPI
import XCTest

/// The demo-mode rules from docs/06-flux-onboarding.md §5.
final class FakeAPIServerTests: XCTestCase {
    private let bearer = "Bearer fixture.access.token"

    private func body(_ object: [String: Any]) throws -> Data {
        try JSONSerialization.data(withJSONObject: object)
    }

    private func arrayBody(_ items: [[String: Any]]) throws -> Data {
        try JSONSerialization.data(withJSONObject: items)
    }

    private func object(_ response: FakeAPIResponse) throws -> [String: Any] {
        let value = try JSONSerialization.jsonObject(with: response.body)
        return try XCTUnwrap(value as? [String: Any])
    }

    func testAnyValidPhoneGetsTheCodeSentFixture() throws {
        let server = FakeAPIServer()
        let response = server.handle(
            method: "POST",
            path: "/auth/otp/request",
            authorization: nil,
            body: try body(["phone": "+40799999999"])
        )
        XCTAssertEqual(response.status, 202)
        let json = try object(response)
        XCTAssertEqual(json["retryAfterSeconds"] as? Int, 30)
        XCTAssertNotNil(json["challengeId"] as? String)
    }

    func testInvalidPhoneIsRejected() throws {
        let server = FakeAPIServer()
        let response = server.handle(
            method: "POST",
            path: "/auth/otp/request",
            authorization: nil,
            body: try body(["phone": "0712345678"])
        )
        XCTAssertEqual(response.status, 422)
        XCTAssertEqual(response.contentType, "application/problem+json")
    }

    func testCode123456Authenticates() throws {
        let server = FakeAPIServer()
        _ = server.handle(
            method: "POST",
            path: "/auth/otp/request",
            authorization: nil,
            body: try body(["phone": "+40799999999"])
        )
        let response = server.handle(
            method: "POST",
            path: "/auth/otp/verify",
            authorization: nil,
            body: try body(["challengeId": "c", "code": "123456"])
        )
        XCTAssertEqual(response.status, 200)
        let json = try object(response)
        XCTAssertEqual(json["accessToken"] as? String, "fixture.access.token")
        XCTAssertEqual(json["isNewUser"] as? Bool, true)
        let user = try XCTUnwrap(json["user"] as? [String: Any])
        XCTAssertEqual(user["phone"] as? String, "+40799999999")
        XCTAssertEqual(user["onboardingCompleted"] as? Bool, false)
    }

    func testAnyOtherCodeReturnsOTPInvalid() throws {
        let server = FakeAPIServer()
        let response = server.handle(
            method: "POST",
            path: "/auth/otp/verify",
            authorization: nil,
            body: try body(["challengeId": "c", "code": "000000"])
        )
        XCTAssertEqual(response.status, 422)
        XCTAssertEqual(response.contentType, "application/problem+json")
        XCTAssertEqual(try object(response)["code"] as? String, "OTP_INVALID")
    }

    func testAuthenticatedEndpointsRequireABearerToken() {
        let server = FakeAPIServer()
        let response = server.handle(method: "GET", path: "/me", authorization: nil, body: nil)
        XCTAssertEqual(response.status, 401)
    }

    func testPatchMeKeepsChangesInMemory() throws {
        let server = FakeAPIServer()
        let patch = server.handle(
            method: "PATCH",
            path: "/me",
            authorization: bearer,
            body: try body([
                "displayName": "Ioana",
                "homeLocation": ["lat": 44.43, "lng": 26.1],
            ])
        )
        XCTAssertEqual(patch.status, 200)
        XCTAssertEqual(try object(patch)["displayName"] as? String, "Ioana")

        _ = server.handle(
            method: "PATCH",
            path: "/me",
            authorization: bearer,
            body: try body(["onboardingCompleted": true, "interestCategoryIds": ["a"]])
        )

        let me = try object(server.handle(method: "GET", path: "/me", authorization: bearer, body: nil))
        XCTAssertEqual(me["displayName"] as? String, "Ioana")
        XCTAssertEqual(me["onboardingCompleted"] as? Bool, true)
        let location = try XCTUnwrap(me["homeLocation"] as? [String: Double])
        XCTAssertEqual(location["lat"] ?? 0, 44.43, accuracy: 1e-9)

        // A later sign-in in the same run sees the completed profile.
        let verify = server.handle(
            method: "POST",
            path: "/auth/otp/verify",
            authorization: nil,
            body: try body(["challengeId": "c", "code": "123456"])
        )
        XCTAssertEqual(try object(verify)["isNewUser"] as? Bool, false)
    }

    func testPutConsentsKeepsChangesInMemory() throws {
        let server = FakeAPIServer()
        let put = server.handle(
            method: "PUT",
            path: "/me/consents",
            authorization: bearer,
            body: try arrayBody([
                ["purpose": "TERMS", "granted": true, "policyVersion": "2026-11"],
                ["purpose": "MARKETING", "granted": false, "policyVersion": "2026-11"],
            ])
        )
        XCTAssertEqual(put.status, 204)

        // A second call for one purpose replaces only that purpose.
        _ = server.handle(
            method: "PUT",
            path: "/me/consents",
            authorization: bearer,
            body: try arrayBody([["purpose": "MARKETING", "granted": true, "policyVersion": "2026-11"]])
        )

        let get = server.handle(method: "GET", path: "/me/consents", authorization: bearer, body: nil)
        let consents = try XCTUnwrap(try JSONSerialization.jsonObject(with: get.body) as? [[String: Any]])
        XCTAssertEqual(consents.count, 2)
        let marketing = try XCTUnwrap(consents.first { ($0["purpose"] as? String) == "MARKETING" })
        XCTAssertEqual(marketing["granted"] as? Bool, true)
        XCTAssertNotNil(marketing["updatedAt"] as? String)
    }

    func testCategoriesAndRefreshServeFixtures() throws {
        let server = FakeAPIServer()
        let categories = server.handle(method: "GET", path: "/categories", authorization: nil, body: nil)
        XCTAssertEqual(categories.status, 200)
        let list = try XCTUnwrap(try JSONSerialization.jsonObject(with: categories.body) as? [[String: Any]])
        XCTAssertEqual(list.count, 8)

        let refresh = server.handle(
            method: "POST",
            path: "/auth/refresh",
            authorization: nil,
            body: try body(["refreshToken": "x"])
        )
        XCTAssertEqual(try object(refresh)["accessToken"] as? String, "fixture.access.token.2")
    }

    func testLogoutAndUnknownPaths() {
        let server = FakeAPIServer()
        XCTAssertEqual(
            server.handle(method: "POST", path: "/auth/logout", authorization: bearer, body: nil).status,
            204
        )
        XCTAssertEqual(
            server.handle(method: "GET", path: "/nope", authorization: bearer, body: nil).status,
            404
        )
    }
}

final class DemoAPITests: XCTestCase {
    func testIsRequestedByLaunchArgument() {
        XCTAssertTrue(DemoAPI.isRequested(arguments: ["app", "-FAKE_API", "1"], environment: [:]))
        XCTAssertTrue(DemoAPI.isRequested(arguments: ["app", "-FAKE_API"], environment: [:]))
        XCTAssertFalse(DemoAPI.isRequested(arguments: ["app", "-FAKE_API", "0"], environment: [:]))
        XCTAssertFalse(DemoAPI.isRequested(arguments: ["app"], environment: [:]))
    }

    func testIsRequestedByEnvironment() {
        XCTAssertTrue(DemoAPI.isRequested(arguments: ["app"], environment: ["FAKE_API": "1"]))
        XCTAssertFalse(DemoAPI.isRequested(arguments: ["app"], environment: ["FAKE_API": "0"]))
    }

    /// End to end through `URLSession`, including the request body that
    /// `URLSession` hands over as a stream.
    func testInstalledProtocolAnswersRequests() async throws {
        DemoAPI.reset()
        let configuration = URLSessionConfiguration.ephemeral
        DemoAPI.install(in: configuration)
        let session = URLSession(configuration: configuration)

        let url = try XCTUnwrap(URL(string: "https://api.profitnet.example/v1/auth/otp/verify"))
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: ["challengeId": "c", "code": "999999"])

        let (data, response) = try await session.data(for: request)

        let httpResponse = try XCTUnwrap(response as? HTTPURLResponse)
        XCTAssertEqual(httpResponse.statusCode, 422)
        XCTAssertEqual(httpResponse.value(forHTTPHeaderField: "Content-Type"), "application/problem+json")
        let problem = try XCTUnwrap(try JSONSerialization.jsonObject(with: data) as? [String: Any])
        XCTAssertEqual(problem["code"] as? String, "OTP_INVALID")
    }
}
#endif
