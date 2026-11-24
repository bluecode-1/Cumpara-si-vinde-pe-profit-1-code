import Foundation
import SwiftData

/// SwiftData row holding the onboarding progress. There is at most one row.
@Model
public final class OnboardingProgressRecord {
    /// Raw value of `OnboardingStep`.
    public var stepRawValue: String
    public var phone: String?
    public var displayName: String?
    public var updatedAt: Date

    public init(stepRawValue: String, phone: String?, displayName: String?, updatedAt: Date) {
        self.stepRawValue = stepRawValue
        self.phone = phone
        self.displayName = displayName
        self.updatedAt = updatedAt
    }
}
