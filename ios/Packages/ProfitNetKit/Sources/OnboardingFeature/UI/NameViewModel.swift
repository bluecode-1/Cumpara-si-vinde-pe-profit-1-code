import Core
import DesignSystem
import Foundation
import Observation

public struct NameScreenState: Equatable, Sendable {
    public var name: String = ""
    public var isSubmitting: Bool = false
    public var error: ScreenError?

    public init() {}
}

@MainActor
@Observable
public final class NameViewModel {
    public var state = NameScreenState()

    @ObservationIgnored public var onSaved: (Me) -> Void = { _ in }

    private let repository: OnboardingRepository

    public init(repository: OnboardingRepository, initialName: String? = nil) {
        self.repository = repository
        if let initialName {
            state.name = initialName
        }
    }

    public func submit() async {
        guard !state.isSubmitting else {
            return
        }
        guard let name = DisplayNameValidator.validated(state.name) else {
            state.error = ScreenError(.nameErrorLength)
            return
        }
        state.error = nil
        state.isSubmitting = true
        do {
            let me = try await repository.updateDisplayName(name)
            state.isSubmitting = false
            onSaved(me)
        } catch is CancellationError {
            state.isSubmitting = false
        } catch {
            state.isSubmitting = false
            state.error = ScreenError(ErrorMessages.key(for: error))
        }
    }
}
