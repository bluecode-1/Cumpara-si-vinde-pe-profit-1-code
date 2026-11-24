import Core
import DesignSystem
import Foundation
import Observation

public struct CodeScreenState: Equatable, Sendable {
    public var code: String = ""
    public var isSubmitting: Bool = false
    public var isResending: Bool = false
    /// Seconds until "resend" becomes available; 0 means it is available.
    public var secondsUntilResend: Int = 0
    public var error: ScreenError?

    public init() {}

    public var canResend: Bool {
        secondsUntilResend == 0 && !isResending && !isSubmitting
    }
}

@MainActor
@Observable
public final class CodeViewModel {
    public var state = CodeScreenState()

    /// The E.164 number the code was sent to.
    public let phone: String

    /// Called with the authenticated user after a successful verification.
    @ObservationIgnored public var onVerified: (Me) -> Void = { _ in }

    private let repository: OnboardingRepository
    private let now: () -> Date
    @ObservationIgnored private var challenge: OTPChallenge
    @ObservationIgnored private var resendDeadline: Date

    public init(
        phone: String,
        challenge: OTPChallenge,
        repository: OnboardingRepository,
        now: @escaping () -> Date = { Date() }
    ) {
        self.phone = phone
        self.challenge = challenge
        self.repository = repository
        self.now = now
        self.resendDeadline = now().addingTimeInterval(TimeInterval(challenge.retryAfterSeconds))
        state.secondsUntilResend = max(0, challenge.retryAfterSeconds)
    }

    /// Call after the text field changed. Keeps digits only and submits
    /// automatically when the sixth digit was entered.
    public func codeChanged() async {
        let sanitized = OTPCodeValidator.sanitized(state.code)
        if sanitized != state.code {
            state.code = sanitized
        }
        if OTPCodeValidator.isValid(sanitized) {
            await submit()
        }
    }

    public func submit() async {
        guard !state.isSubmitting, OTPCodeValidator.isValid(state.code) else {
            return
        }
        state.error = nil
        state.isSubmitting = true
        do {
            let me = try await repository.verifyCode(challengeId: challenge.challengeId, code: state.code)
            state.isSubmitting = false
            onVerified(me)
        } catch is CancellationError {
            state.isSubmitting = false
        } catch {
            state.isSubmitting = false
            handle(error)
        }
    }

    public func resend() async {
        guard state.canResend else {
            return
        }
        state.error = nil
        state.isResending = true
        do {
            let newChallenge = try await repository.requestCode(phone: phone)
            challenge = newChallenge
            state.isResending = false
            state.code = ""
            startCountdown(seconds: newChallenge.retryAfterSeconds)
        } catch is CancellationError {
            state.isResending = false
        } catch {
            state.isResending = false
            handle(error)
        }
    }

    /// Updates the countdown from the clock. Called once per second by the view.
    public func tick() {
        let remaining = resendDeadline.timeIntervalSince(now())
        state.secondsUntilResend = max(0, Int(remaining.rounded(.up)))
    }

    private func handle(_ error: Error) {
        let appError = AppError.wrapping(error)
        switch appError.code {
        case AppError.Code.otpInvalid:
            // A wrong or expired code clears the field.
            state.code = ""
        case AppError.Code.rateLimited:
            // Resending stays blocked until the countdown expires. If it
            // already expired, start it again.
            tick()
            if state.secondsUntilResend == 0 {
                startCountdown(seconds: challenge.retryAfterSeconds)
            }
        default:
            break
        }
        state.error = ScreenError(ErrorMessages.key(for: appError))
    }

    private func startCountdown(seconds: Int) {
        let clamped = max(0, seconds)
        resendDeadline = now().addingTimeInterval(TimeInterval(clamped))
        state.secondsUntilResend = clamped
    }
}
