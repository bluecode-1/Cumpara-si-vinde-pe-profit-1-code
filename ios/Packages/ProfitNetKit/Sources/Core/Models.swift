import Foundation

// Hand-written models for the parts of `api/openapi.yaml` used by onboarding.
// They are verified against `api/fixtures` by the Networking contract tests.

// MARK: - Auth

public struct TokenPair: Codable, Equatable, Sendable {
    public let accessToken: String
    public let refreshToken: String
    public let expiresInSeconds: Int

    public init(accessToken: String, refreshToken: String, expiresInSeconds: Int) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresInSeconds = expiresInSeconds
    }
}

/// Response of `POST /auth/otp/verify`: a flat object with the token fields
/// plus `user` and `isNewUser`.
public struct AuthSession: Decodable, Equatable, Sendable {
    public let tokens: TokenPair
    public let user: Me
    public let isNewUser: Bool

    public init(tokens: TokenPair, user: Me, isNewUser: Bool) {
        self.tokens = tokens
        self.user = user
        self.isNewUser = isNewUser
    }

    private enum CodingKeys: String, CodingKey {
        case user
        case isNewUser
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tokens = try TokenPair(from: decoder)
        self.user = try container.decode(Me.self, forKey: .user)
        self.isNewUser = try container.decode(Bool.self, forKey: .isNewUser)
    }
}

/// Response of `POST /auth/otp/request`.
public struct OTPChallenge: Codable, Equatable, Hashable, Sendable {
    public let challengeId: String
    public let retryAfterSeconds: Int

    public init(challengeId: String, retryAfterSeconds: Int) {
        self.challengeId = challengeId
        self.retryAfterSeconds = retryAfterSeconds
    }
}

// MARK: - User

public enum VerificationTier: String, Codable, Sendable {
    case phone = "PHONE"
    case email = "EMAIL"
    case identity = "IDENTITY"
}

public enum SellerType: String, Codable, Sendable {
    case occasional = "OCCASIONAL"
    case professional = "PROFESSIONAL"
}

public struct Badge: Codable, Equatable, Hashable, Sendable {
    /// A `ReputationAttribute` value. Kept as a string so that a new
    /// attribute added by the server does not break decoding of `Me`.
    public let attribute: String
    public let confirmations: Int

    public init(attribute: String, confirmations: Int) {
        self.attribute = attribute
        self.confirmations = confirmations
    }
}

public struct TraderInfo: Codable, Equatable, Hashable, Sendable {
    public let legalName: String?
    public let registrationNumber: String?
    public let address: String?
    public let contactEmail: String?

    public init(
        legalName: String? = nil,
        registrationNumber: String? = nil,
        address: String? = nil,
        contactEmail: String? = nil
    ) {
        self.legalName = legalName
        self.registrationNumber = registrationNumber
        self.address = address
        self.contactEmail = contactEmail
    }
}

public struct TransactionLimits: Codable, Equatable, Hashable, Sendable {
    public let maxTransaction: Money
    public let monthlyVolume: Money

    public init(maxTransaction: Money, monthlyVolume: Money) {
        self.maxTransaction = maxTransaction
        self.monthlyVolume = monthlyVolume
    }
}

/// The authenticated user (`Me` in the contract).
public struct Me: Decodable, Equatable, Sendable {
    public let id: String
    public let displayName: String
    public let avatarURL: URL?
    public let city: String?
    public let verificationTier: VerificationTier
    public let sellerType: SellerType
    public let badges: [Badge]
    public let completedTransactions: Int
    /// Calendar date (`yyyy-MM-dd`), kept as sent by the server.
    public let memberSince: String
    public let traderInfo: TraderInfo?
    public let phone: String
    public let email: String?
    public let emailVerified: Bool
    public let locale: String
    public let currency: Currency
    public let homeLocation: GeoPoint?
    public let limits: TransactionLimits
    public let onboardingCompleted: Bool

    public init(
        id: String,
        displayName: String,
        avatarURL: URL? = nil,
        city: String? = nil,
        verificationTier: VerificationTier = .phone,
        sellerType: SellerType = .occasional,
        badges: [Badge] = [],
        completedTransactions: Int = 0,
        memberSince: String,
        traderInfo: TraderInfo? = nil,
        phone: String,
        email: String? = nil,
        emailVerified: Bool = false,
        locale: String = "ro",
        currency: Currency = .ron,
        homeLocation: GeoPoint? = nil,
        limits: TransactionLimits,
        onboardingCompleted: Bool = false
    ) {
        self.id = id
        self.displayName = displayName
        self.avatarURL = avatarURL
        self.city = city
        self.verificationTier = verificationTier
        self.sellerType = sellerType
        self.badges = badges
        self.completedTransactions = completedTransactions
        self.memberSince = memberSince
        self.traderInfo = traderInfo
        self.phone = phone
        self.email = email
        self.emailVerified = emailVerified
        self.locale = locale
        self.currency = currency
        self.homeLocation = homeLocation
        self.limits = limits
        self.onboardingCompleted = onboardingCompleted
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case avatarUrl
        case city
        case verificationTier
        case sellerType
        case badges
        case completedTransactions
        case memberSince
        case traderInfo
        case phone
        case email
        case emailVerified
        case locale
        case currency
        case homeLocation
        case limits
        case onboardingCompleted
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        let avatar = try container.decodeIfPresent(String.self, forKey: .avatarUrl)
        self.avatarURL = avatar.flatMap { URL(string: $0) }
        self.city = try container.decodeIfPresent(String.self, forKey: .city)
        self.verificationTier = try container.decode(VerificationTier.self, forKey: .verificationTier)
        self.sellerType = try container.decode(SellerType.self, forKey: .sellerType)
        self.badges = try container.decode([Badge].self, forKey: .badges)
        self.completedTransactions =
            try container.decodeIfPresent(Int.self, forKey: .completedTransactions) ?? 0
        self.memberSince = try container.decode(String.self, forKey: .memberSince)
        self.traderInfo = try container.decodeIfPresent(TraderInfo.self, forKey: .traderInfo)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.emailVerified =
            try container.decodeIfPresent(Bool.self, forKey: .emailVerified) ?? false
        self.locale = try container.decode(String.self, forKey: .locale)
        self.currency = try container.decode(Currency.self, forKey: .currency)
        self.homeLocation = try container.decodeIfPresent(GeoPoint.self, forKey: .homeLocation)
        self.limits = try container.decode(TransactionLimits.self, forKey: .limits)
        self.onboardingCompleted =
            try container.decodeIfPresent(Bool.self, forKey: .onboardingCompleted) ?? false
    }
}

/// Body of `PATCH /me`. Only non-nil fields are sent.
public struct MeUpdate: Encodable, Equatable, Sendable {
    public var displayName: String?
    public var homeLocation: GeoPoint?
    public var interestCategoryIds: [String]?
    public var onboardingCompleted: Bool?

    public init(
        displayName: String? = nil,
        homeLocation: GeoPoint? = nil,
        interestCategoryIds: [String]? = nil,
        onboardingCompleted: Bool? = nil
    ) {
        self.displayName = displayName
        self.homeLocation = homeLocation
        self.interestCategoryIds = interestCategoryIds
        self.onboardingCompleted = onboardingCompleted
    }
}

// MARK: - Consents

public enum ConsentPurpose: String, Codable, Sendable, CaseIterable {
    case terms = "TERMS"
    case privacy = "PRIVACY"
    case marketing = "MARKETING"
    case analytics = "ANALYTICS"
    case location = "LOCATION"
    case aiPhotoProcessing = "AI_PHOTO_PROCESSING"
}

public struct Consent: Codable, Equatable, Sendable {
    public let purpose: ConsentPurpose
    public let granted: Bool
    public let policyVersion: String
    public let updatedAt: Date

    public init(purpose: ConsentPurpose, granted: Bool, policyVersion: String, updatedAt: Date) {
        self.purpose = purpose
        self.granted = granted
        self.policyVersion = policyVersion
        self.updatedAt = updatedAt
    }
}

/// One item of the `PUT /me/consents` body.
public struct ConsentInput: Codable, Equatable, Hashable, Sendable {
    public let purpose: ConsentPurpose
    public let granted: Bool
    public let policyVersion: String

    public init(purpose: ConsentPurpose, granted: Bool, policyVersion: String = PolicyVersion.current) {
        self.purpose = purpose
        self.granted = granted
        self.policyVersion = policyVersion
    }
}

public enum PolicyVersion {
    /// The policy version sent with every consent (onboarding specification §3).
    public static let current = "2026-11"
}

// MARK: - Catalog

/// `Category` in the contract. Named `CatalogCategory` because a public type
/// called `Category` is ambiguous with the Objective-C runtime's `Category`.
public struct CatalogCategory: Decodable, Equatable, Hashable, Sendable, Identifiable {
    public let id: String
    public let parentId: String?
    public let slug: String
    public let name: String
    public let iconKey: String?
    public let isVehicle: Bool

    public init(
        id: String,
        parentId: String? = nil,
        slug: String,
        name: String,
        iconKey: String? = nil,
        isVehicle: Bool = false
    ) {
        self.id = id
        self.parentId = parentId
        self.slug = slug
        self.name = name
        self.iconKey = iconKey
        self.isVehicle = isVehicle
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case parentId
        case slug
        case name
        case iconKey
        case isVehicle
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
        self.slug = try container.decode(String.self, forKey: .slug)
        self.name = try container.decode(String.self, forKey: .name)
        self.iconKey = try container.decodeIfPresent(String.self, forKey: .iconKey)
        self.isVehicle = try container.decodeIfPresent(Bool.self, forKey: .isVehicle) ?? false
    }

    public var isTopLevel: Bool { parentId == nil }
}
