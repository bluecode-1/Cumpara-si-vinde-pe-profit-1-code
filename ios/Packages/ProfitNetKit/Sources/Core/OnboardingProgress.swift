import Foundation

/// The steps of the onboarding flow, in order. The raw value is persisted.
public enum OnboardingStep: String, Codable, Sendable, CaseIterable {
    case welcome
    case phone
    case code
    case consents
    case name
    case location
    case interests
    case completed

    /// Steps that are only reachable with a valid session.
    public var requiresSession: Bool {
        switch self {
        case .welcome, .phone, .code:
            return false
        case .consents, .name, .location, .interests, .completed:
            return true
        }
    }
}

/// Locally persisted onboarding state, used to resume the flow.
public struct OnboardingProgress: Equatable, Sendable {
    public var step: OnboardingStep
    /// E.164 phone number entered by the user, if any.
    public var phone: String?
    /// Display name known so far (used for the greeting on the home screen).
    public var displayName: String?

    public init(step: OnboardingStep, phone: String? = nil, displayName: String? = nil) {
        self.step = step
        self.phone = phone
        self.displayName = displayName
    }
}
