import Core
import DesignSystem
import Foundation
import Observation

public struct PhoneScreenState: Equatable, Sendable {
    /// The national part typed by the user (the `+40` prefix is fixed).
    public var input: String = ""
    public var isSubmitting: Bool = false
    public var error: ScreenError?

    public init() {}
}

@MainActor
@Observable
public final class PhoneViewModel {
    public var state = PhoneScreenState()

    /// Called with the E.164 number and the challenge after the code was sent.
    @ObservationIgnored public var onCodeRequested: (String, OTPChallenge) -> Void = { _, _ in }

    private let repository: OnboardingRepository

    public init(repository: OnboardingRepository, prefilledPhone: String? = nil) {
        self.repository = repository
        if let prefilledPhone {
            // Show the national part only; the prefix is displayed separately.
            if prefilledPhone.hasPrefix(PhoneNumberNormalizer.countryPrefix) {
                state.input = String(prefilledPhone.dropFirst(PhoneNumberNormalizer.countryPrefix.count))
            } else {
                state.input = prefilledPhone
            }
        }
    }

    public func submit() async {
        guard !state.isSubmitting else {
            return
        }
        // Invalid numbers show the validation error without a server call.
        guard let phone = PhoneNumberNormalizer.normalize(state.input) else {
            state.error = ScreenError(.phoneErrorInvalid)
            return
        }

        state.error = nil
        state.isSubmitting = true
        do {
            let challenge = try await repository.requestCode(phone: phone)
            state.isSubmitting = false
            onCodeRequested(phone, challenge)
        } catch is CancellationError {
            state.isSubmitting = false
        } catch {
            state.isSubmitting = false
            state.error = ScreenError(ErrorMessages.key(for: error))
        }
    }
}
