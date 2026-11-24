import Core
import DesignSystem
import Foundation
import Observation

public struct ConsentsScreenState: Equatable, Sendable {
    // Required.
    public var terms: Bool = false
    public var privacy: Bool = false
    // Optional; unchecked by default (consent cannot be presumed).
    public var marketing: Bool = false
    public var analytics: Bool = false
    public var aiPhotoProcessing: Bool = false

    public var isSubmitting: Bool = false
    public var error: ScreenError?

    public init() {}

    public var canContinue: Bool {
        terms && privacy
    }
}

@MainActor
@Observable
public final class ConsentsViewModel {
    public var state = ConsentsScreenState()

    @ObservationIgnored public var onSaved: () -> Void = {}

    private let repository: OnboardingRepository

    public init(repository: OnboardingRepository) {
        self.repository = repository
    }

    /// The consents as sent to `PUT /me/consents`.
    public var consentInputs: [ConsentInput] {
        [
            ConsentInput(purpose: .terms, granted: state.terms),
            ConsentInput(purpose: .privacy, granted: state.privacy),
            ConsentInput(purpose: .marketing, granted: state.marketing),
            ConsentInput(purpose: .analytics, granted: state.analytics),
            ConsentInput(purpose: .aiPhotoProcessing, granted: state.aiPhotoProcessing),
        ]
    }

    public func submit() async {
        guard state.canContinue, !state.isSubmitting else {
            return
        }
        state.error = nil
        state.isSubmitting = true
        do {
            try await repository.saveConsents(consentInputs)
            state.isSubmitting = false
            onSaved()
        } catch is CancellationError {
            state.isSubmitting = false
        } catch {
            state.isSubmitting = false
            state.error = ScreenError(ErrorMessages.key(for: error))
        }
    }
}
