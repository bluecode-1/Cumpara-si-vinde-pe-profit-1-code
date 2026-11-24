import Core
import Networking
import XCTest

/// Contract tests: every fixture used by onboarding decodes into the
/// hand-written models. The same files are decoded by the Android and
/// Flutter test suites.
final class FixtureContractTests: XCTestCase {
    private func decode<T: Decodable>(_ type: T.Type, from fixture: String) throws -> T {
        try JSONCoding.makeDecoder().decode(type, from: Fixture.data(fixture))
    }

    func testOTPRequestResponse() throws {
        let challenge = try decode(OTPChallenge.self, from: "auth_otp_request.202")
        XCTAssertEqual(challenge.challengeId, "0193f6a0-1c2d-7b3a-9e4f-5a6b7c8d9e01")
        XCTAssertEqual(challenge.retryAfterSeconds, 30)
    }

    func testOTPVerifyResponse() throws {
        let session = try decode(AuthSession.self, from: "auth_otp_verify.200")
        XCTAssertEqual(session.tokens.accessToken, "fixture.access.token")
        XCTAssertEqual(session.tokens.refreshToken, "fixture-refresh-token-1")
        XCTAssertEqual(session.tokens.expiresInSeconds, 900)
        XCTAssertTrue(session.isNewUser)
        XCTAssertEqual(session.user.id, "0193f6a0-2a00-7000-8000-000000000001")
        XCTAssertEqual(session.user.phone, "+40712345678")
        XCTAssertEqual(session.user.displayName, "")
        XCTAssertFalse(session.user.onboardingCompleted)
    }

    func testRefreshResponse() throws {
        let tokens = try decode(TokenPair.self, from: "auth_refresh.200")
        XCTAssertEqual(tokens.accessToken, "fixture.access.token.2")
        XCTAssertEqual(tokens.refreshToken, "fixture-refresh-token-2")
        XCTAssertEqual(tokens.expiresInSeconds, 900)
    }

    func testNewUser() throws {
        let me = try decode(Me.self, from: "me.new.200")
        XCTAssertEqual(me.displayName, "")
        XCTAssertNil(me.avatarURL)
        XCTAssertNil(me.city)
        XCTAssertEqual(me.verificationTier, .phone)
        XCTAssertEqual(me.sellerType, .occasional)
        XCTAssertTrue(me.badges.isEmpty)
        XCTAssertEqual(me.completedTransactions, 0)
        XCTAssertEqual(me.memberSince, "2026-11-23")
        XCTAssertNil(me.traderInfo)
        XCTAssertEqual(me.phone, "+40712345678")
        XCTAssertNil(me.email)
        XCTAssertFalse(me.emailVerified)
        XCTAssertEqual(me.locale, "ro")
        XCTAssertEqual(me.currency, .ron)
        XCTAssertNil(me.homeLocation)
        XCTAssertEqual(me.limits.maxTransaction, Money(amountMinor: 150_000, currency: .ron))
        XCTAssertEqual(me.limits.monthlyVolume, Money(amountMinor: 500_000, currency: .ron))
        XCTAssertFalse(me.onboardingCompleted)
    }

    func testOnboardedUser() throws {
        let me = try decode(Me.self, from: "me.onboarded.200")
        XCTAssertEqual(me.displayName, "Ioana")
        XCTAssertEqual(me.city, "Cluj-Napoca")
        XCTAssertEqual(
            me.badges,
            [
                Badge(attribute: "PUNCTUAL", confirmations: 23),
                Badge(attribute: "AS_DESCRIBED", confirmations: 31),
            ]
        )
        XCTAssertEqual(me.completedTransactions, 34)
        XCTAssertEqual(me.homeLocation, GeoPoint(lat: 46.77, lng: 23.6))
        XCTAssertTrue(me.onboardingCompleted)
    }

    func testConsents() throws {
        let consents = try decode([Consent].self, from: "me_consents.200")
        XCTAssertEqual(consents.count, 6)
        XCTAssertEqual(
            consents.map(\.purpose),
            [.terms, .privacy, .marketing, .analytics, .location, .aiPhotoProcessing]
        )
        XCTAssertEqual(consents.map(\.granted), [true, true, false, false, true, false])
        XCTAssertTrue(consents.allSatisfy { $0.policyVersion == "2026-11" })

        // 2026-11-23T10:00:00Z
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        let expected = calendar.date(
            from: DateComponents(year: 2026, month: 11, day: 23, hour: 10, minute: 0, second: 0)
        )
        XCTAssertEqual(consents.first?.updatedAt, expected)
    }

    func testCategories() throws {
        let categories = try decode([CatalogCategory].self, from: "categories.200")
        XCTAssertEqual(categories.count, 8)
        XCTAssertTrue(categories.allSatisfy { $0.isTopLevel })
        XCTAssertEqual(categories.first?.id, "0193f6a0-3c00-7000-8000-000000000001")
        XCTAssertEqual(categories.first?.slug, "haine")
        XCTAssertEqual(categories.first?.name, "Haine și încălțăminte")
        XCTAssertEqual(categories.first?.iconKey, "clothing")
        XCTAssertEqual(categories.first?.isVehicle, false)
        XCTAssertEqual(categories.last?.slug, "auto")
        XCTAssertEqual(categories.last?.isVehicle, true)
    }

    func testProblemFixtures() throws {
        let otpInvalid = try ProblemDecoder.error(from: Fixture.data("problem_otp_invalid.422"), status: 422)
        XCTAssertEqual(otpInvalid, AppError(code: "OTP_INVALID", status: 422))

        let rateLimited = try ProblemDecoder.error(from: Fixture.data("problem_rate_limited.429"), status: 429)
        XCTAssertEqual(rateLimited, AppError(code: "RATE_LIMITED", status: 429))
    }

    func testTimestampsWithFractionalSecondsDecode() throws {
        let json = Data(
            """
            {"purpose":"TERMS","granted":true,"policyVersion":"2026-11","updatedAt":"2026-11-23T10:00:00.250Z"}
            """.utf8
        )
        let consent = try JSONCoding.makeDecoder().decode(Consent.self, from: json)
        XCTAssertEqual(consent.purpose, .terms)
    }
}

/// Request bodies must match the contract as well.
final class RequestEncodingTests: XCTestCase {
    private func jsonObject(_ endpoint: Endpoint) throws -> Any {
        let body = try XCTUnwrap(endpoint.body)
        return try JSONSerialization.jsonObject(with: body)
    }

    func testOTPRequestBody() throws {
        let endpoint = try APIEndpoints.requestOTP(phone: "+40712345678")
        XCTAssertEqual(endpoint.method, .post)
        XCTAssertEqual(endpoint.path, "/auth/otp/request")
        XCTAssertFalse(endpoint.requiresAuth)
        let object = try XCTUnwrap(try jsonObject(endpoint) as? [String: String])
        XCTAssertEqual(object, ["phone": "+40712345678"])
    }

    func testOTPVerifyBody() throws {
        let endpoint = try APIEndpoints.verifyOTP(challengeId: "c-1", code: "123456")
        XCTAssertEqual(endpoint.path, "/auth/otp/verify")
        XCTAssertFalse(endpoint.requiresAuth)
        let object = try XCTUnwrap(try jsonObject(endpoint) as? [String: String])
        XCTAssertEqual(object, ["challengeId": "c-1", "code": "123456"])
    }

    func testMeUpdateOmitsUnsetFields() throws {
        let endpoint = try APIEndpoints.updateMe(MeUpdate(displayName: "Ioana"))
        XCTAssertEqual(endpoint.method, .patch)
        XCTAssertEqual(endpoint.path, "/me")
        XCTAssertTrue(endpoint.requiresAuth)
        let object = try XCTUnwrap(try jsonObject(endpoint) as? [String: Any])
        XCTAssertEqual(object.count, 1)
        XCTAssertEqual(object["displayName"] as? String, "Ioana")
    }

    func testMeUpdateWithLocationAndCompletion() throws {
        let update = MeUpdate(
            homeLocation: GeoPoint(lat: 44.43, lng: 26.1),
            interestCategoryIds: ["a", "b"],
            onboardingCompleted: true
        )
        let object = try XCTUnwrap(try jsonObject(try APIEndpoints.updateMe(update)) as? [String: Any])
        let location = try XCTUnwrap(object["homeLocation"] as? [String: Double])
        XCTAssertEqual(location["lat"] ?? 0, 44.43, accuracy: 1e-9)
        XCTAssertEqual(location["lng"] ?? 0, 26.1, accuracy: 1e-9)
        XCTAssertEqual(object["interestCategoryIds"] as? [String], ["a", "b"])
        XCTAssertEqual(object["onboardingCompleted"] as? Bool, true)
        XCTAssertNil(object["displayName"])
    }

    func testConsentsBody() throws {
        let endpoint = try APIEndpoints.setConsents([
            ConsentInput(purpose: .terms, granted: true),
            ConsentInput(purpose: .aiPhotoProcessing, granted: false),
        ])
        XCTAssertEqual(endpoint.method, .put)
        XCTAssertEqual(endpoint.path, "/me/consents")
        let items = try XCTUnwrap(try jsonObject(endpoint) as? [[String: Any]])
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[0]["purpose"] as? String, "TERMS")
        XCTAssertEqual(items[0]["granted"] as? Bool, true)
        XCTAssertEqual(items[0]["policyVersion"] as? String, "2026-11")
        XCTAssertEqual(items[1]["purpose"] as? String, "AI_PHOTO_PROCESSING")
        XCTAssertEqual(items[1]["granted"] as? Bool, false)
    }
}
