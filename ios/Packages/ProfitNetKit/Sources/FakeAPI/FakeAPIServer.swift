#if DEBUG
import Foundation

/// A response produced by the fake server.
struct FakeAPIResponse {
    let status: Int
    let contentType: String?
    let body: Data

    static func json(_ status: Int, _ body: Data) -> FakeAPIResponse {
        FakeAPIResponse(status: status, contentType: "application/json", body: body)
    }

    static func problem(_ status: Int, _ body: Data) -> FakeAPIResponse {
        FakeAPIResponse(status: status, contentType: "application/problem+json", body: body)
    }

    static func noContent() -> FakeAPIResponse {
        FakeAPIResponse(status: 204, contentType: nil, body: Data())
    }
}

/// The in-memory fake backend.
///
/// Rules:
/// - any valid phone number gets the "code sent" fixture;
/// - code `123456` authenticates, any other code returns `OTP_INVALID` (422);
/// - `PATCH /me` and `PUT /me/consents` keep their changes in memory for the
///   lifetime of the process.
final class FakeAPIServer: @unchecked Sendable {
    static let shared = FakeAPIServer()

    private let lock = NSLock()
    /// The current `Me` object; `nil` until first needed.
    private var me: [String: Any]?
    private var consents: [[String: Any]] = []
    private var interestCategoryIds: [String] = []
    private var lastRequestedPhone: String?

    init() {}

    func reset() {
        lock.lock()
        defer { lock.unlock() }
        me = nil
        consents = []
        interestCategoryIds = []
        lastRequestedPhone = nil
    }

    /// - Parameters:
    ///   - method: The HTTP method, upper case.
    ///   - path: The path after the API version prefix, for example `/me`.
    ///   - authorization: The value of the `Authorization` header, if any.
    ///   - body: The request body, if any.
    func handle(method: String, path: String, authorization: String?, body: Data?) -> FakeAPIResponse {
        lock.lock()
        defer { lock.unlock() }

        switch (method, path) {
        case ("POST", "/auth/otp/request"):
            return requestOTP(body: body)
        case ("POST", "/auth/otp/verify"):
            return verifyOTP(body: body)
        case ("POST", "/auth/refresh"):
            return fixtureResponse("auth_refresh.200", status: 200)
        case ("GET", "/categories"):
            return fixtureResponse("categories.200", status: 200)
        default:
            break
        }

        // Everything below requires a bearer token.
        guard let authorization, authorization.hasPrefix("Bearer "), authorization.count > 7 else {
            return problem(status: 401, code: "UNAUTHORIZED", title: "Unauthorized")
        }

        switch (method, path) {
        case ("POST", "/auth/logout"):
            return .noContent()
        case ("GET", "/me"):
            return jsonResponse(currentMe(), status: 200)
        case ("PATCH", "/me"):
            return updateMe(body: body)
        case ("GET", "/me/consents"):
            return jsonResponse(consents, status: 200)
        case ("PUT", "/me/consents"):
            return setConsents(body: body)
        default:
            return problem(status: 404, code: "NOT_FOUND", title: "Not found")
        }
    }

    // MARK: - Handlers (called with the lock held)

    private func requestOTP(body: Data?) -> FakeAPIResponse {
        guard let object = jsonObject(body) as? [String: Any],
              let phone = object["phone"] as? String,
              Self.isValidPhone(phone)
        else {
            return problem(status: 422, code: "VALIDATION_FAILED", title: "Validation failed")
        }
        lastRequestedPhone = phone
        return fixtureResponse("auth_otp_request.202", status: 202)
    }

    private func verifyOTP(body: Data?) -> FakeAPIResponse {
        guard let object = jsonObject(body) as? [String: Any],
              let code = object["code"] as? String,
              code == DemoAPI.validCode
        else {
            return fixtureResponse("problem_otp_invalid.422", status: 422, isProblem: true)
        }
        guard var session = fixtureObject("auth_otp_verify.200") as? [String: Any] else {
            return missingFixture("auth_otp_verify.200")
        }

        var user = currentMe()
        if let phone = lastRequestedPhone {
            user["phone"] = phone
        }
        me = user

        let completed = (user["onboardingCompleted"] as? Bool) ?? false
        session["user"] = user
        session["isNewUser"] = !completed
        return jsonResponse(session, status: 200)
    }

    private func updateMe(body: Data?) -> FakeAPIResponse {
        guard let update = jsonObject(body) as? [String: Any] else {
            return problem(status: 422, code: "VALIDATION_FAILED", title: "Validation failed")
        }
        var user = currentMe()

        if let displayName = update["displayName"] as? String {
            guard displayName.count >= 2, displayName.count <= 40 else {
                return problem(status: 422, code: "VALIDATION_FAILED", title: "Validation failed")
            }
            user["displayName"] = displayName
        }
        if let homeLocation = update["homeLocation"] as? [String: Any] {
            user["homeLocation"] = homeLocation
        }
        if let completed = update["onboardingCompleted"] as? Bool {
            user["onboardingCompleted"] = completed
        }
        if let locale = update["locale"] as? String {
            user["locale"] = locale
        }
        if let currency = update["currency"] as? String {
            user["currency"] = currency
        }
        if let ids = update["interestCategoryIds"] as? [String] {
            interestCategoryIds = ids
        }

        me = user
        return jsonResponse(user, status: 200)
    }

    private func setConsents(body: Data?) -> FakeAPIResponse {
        guard let items = jsonObject(body) as? [[String: Any]] else {
            return problem(status: 422, code: "VALIDATION_FAILED", title: "Validation failed")
        }
        let now = ISO8601DateFormatter().string(from: Date())
        for item in items {
            guard let purpose = item["purpose"] as? String,
                  let granted = item["granted"] as? Bool,
                  let policyVersion = item["policyVersion"] as? String
            else {
                return problem(status: 422, code: "VALIDATION_FAILED", title: "Validation failed")
            }
            let consent: [String: Any] = [
                "purpose": purpose,
                "granted": granted,
                "policyVersion": policyVersion,
                "updatedAt": now,
            ]
            if let index = consents.firstIndex(where: { ($0["purpose"] as? String) == purpose }) {
                consents[index] = consent
            } else {
                consents.append(consent)
            }
        }
        return .noContent()
    }

    // MARK: - State and fixtures

    private func currentMe() -> [String: Any] {
        if let me {
            return me
        }
        let initial = (fixtureObject("me.new.200") as? [String: Any]) ?? [:]
        me = initial
        return initial
    }

    private static func isValidPhone(_ phone: String) -> Bool {
        guard phone.hasPrefix("+407"), phone.count == 12 else {
            return false
        }
        return phone.dropFirst().allSatisfy { $0 >= "0" && $0 <= "9" }
    }

    private func jsonObject(_ data: Data?) -> Any? {
        guard let data, !data.isEmpty else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
    }

    private func fixtureData(_ name: String) -> Data? {
        guard let url = Bundle.module.url(
            forResource: name,
            withExtension: "json",
            subdirectory: "Fixtures"
        ) else {
            return nil
        }
        return try? Data(contentsOf: url)
    }

    private func fixtureObject(_ name: String) -> Any? {
        jsonObject(fixtureData(name))
    }

    private func fixtureResponse(_ name: String, status: Int, isProblem: Bool = false) -> FakeAPIResponse {
        guard let data = fixtureData(name) else {
            return missingFixture(name)
        }
        return isProblem ? .problem(status, data) : .json(status, data)
    }

    private func jsonResponse(_ object: Any, status: Int) -> FakeAPIResponse {
        guard JSONSerialization.isValidJSONObject(object),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [])
        else {
            return problem(status: 500, code: "INTERNAL", title: "Fake API serialisation failed")
        }
        return .json(status, data)
    }

    private func missingFixture(_ name: String) -> FakeAPIResponse {
        problem(status: 500, code: "FIXTURE_MISSING", title: "Missing fixture \(name)")
    }

    private func problem(status: Int, code: String, title: String) -> FakeAPIResponse {
        let object: [String: Any] = [
            "type": "about:blank",
            "title": title,
            "status": status,
            "code": code,
        ]
        let data = (try? JSONSerialization.data(withJSONObject: object, options: [])) ?? Data()
        return .problem(status, data)
    }
}
#endif
