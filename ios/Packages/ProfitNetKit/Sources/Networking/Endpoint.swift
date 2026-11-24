import Core
import Foundation

public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

/// Describes one API call: method, path relative to the base URL, optional
/// JSON body and whether the access token must be attached.
public struct Endpoint: Equatable, Sendable {
    public let method: HTTPMethod
    /// Path relative to the base URL, starting with `/` (for example `/me`).
    public let path: String
    public let body: Data?
    public let requiresAuth: Bool

    public init(method: HTTPMethod, path: String, body: Data? = nil, requiresAuth: Bool = true) {
        self.method = method
        self.path = path
        self.body = body
        self.requiresAuth = requiresAuth
    }

    /// Creates an endpoint whose body is `json` encoded with the API encoder.
    public init<Body: Encodable>(
        method: HTTPMethod,
        path: String,
        json: Body,
        requiresAuth: Bool = true
    ) throws {
        let data: Data
        do {
            data = try JSONCoding.makeEncoder().encode(json)
        } catch {
            throw AppError.unknown
        }
        self.init(method: method, path: path, body: data, requiresAuth: requiresAuth)
    }
}

/// The endpoints used by the onboarding step (see `api/openapi.yaml`).
public enum APIEndpoints {
    private struct OTPRequestBody: Encodable {
        let phone: String
    }

    private struct OTPVerifyBody: Encodable {
        let challengeId: String
        let code: String
    }

    struct RefreshBody: Encodable {
        let refreshToken: String
    }

    /// `POST /auth/otp/request` → `OTPChallenge` (202).
    public static func requestOTP(phone: String) throws -> Endpoint {
        try Endpoint(
            method: .post,
            path: "/auth/otp/request",
            json: OTPRequestBody(phone: phone),
            requiresAuth: false
        )
    }

    /// `POST /auth/otp/verify` → `AuthSession`.
    public static func verifyOTP(challengeId: String, code: String) throws -> Endpoint {
        try Endpoint(
            method: .post,
            path: "/auth/otp/verify",
            json: OTPVerifyBody(challengeId: challengeId, code: code),
            requiresAuth: false
        )
    }

    /// `POST /auth/refresh` → `TokenPair`.
    public static func refresh(refreshToken: String) throws -> Endpoint {
        try Endpoint(
            method: .post,
            path: "/auth/refresh",
            json: RefreshBody(refreshToken: refreshToken),
            requiresAuth: false
        )
    }

    /// `POST /auth/logout` → 204.
    public static func logout() -> Endpoint {
        Endpoint(method: .post, path: "/auth/logout")
    }

    /// `GET /me` → `Me`.
    public static func me() -> Endpoint {
        Endpoint(method: .get, path: "/me")
    }

    /// `PATCH /me` → `Me`.
    public static func updateMe(_ update: MeUpdate) throws -> Endpoint {
        try Endpoint(method: .patch, path: "/me", json: update)
    }

    /// `PUT /me/consents` → 204.
    public static func setConsents(_ consents: [ConsentInput]) throws -> Endpoint {
        try Endpoint(method: .put, path: "/me/consents", json: consents)
    }

    /// `GET /categories` → `[CatalogCategory]`. Public endpoint.
    public static func categories() -> Endpoint {
        Endpoint(method: .get, path: "/categories", requiresAuth: false)
    }
}
