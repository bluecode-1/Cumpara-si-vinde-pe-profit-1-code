import Core
import DesignSystem
import Foundation
import Observation

public struct InterestsScreenState: Equatable, Sendable {
    public var categories: [CatalogCategory] = []
    public var selectedIds: Set<String> = []
    public var isLoading: Bool = false
    public var isSubmitting: Bool = false
    public var error: ScreenError?

    public init() {}
}

@MainActor
@Observable
public final class InterestsViewModel {
    public var state = InterestsScreenState()

    @ObservationIgnored public var onCompleted: (Me) -> Void = { _ in }

    private let repository: OnboardingRepository

    public init(repository: OnboardingRepository) {
        self.repository = repository
    }

    /// Loads the top-level categories. If loading fails the user can still
    /// finish or skip; interests are optional.
    public func load() async {
        guard state.categories.isEmpty, !state.isLoading else {
            return
        }
        state.isLoading = true
        do {
            state.categories = try await repository.topLevelCategories()
            state.isLoading = false
        } catch is CancellationError {
            state.isLoading = false
        } catch {
            state.isLoading = false
            state.error = ScreenError(ErrorMessages.key(for: error))
        }
    }

    public func isSelected(_ category: CatalogCategory) -> Bool {
        state.selectedIds.contains(category.id)
    }

    public func setSelected(_ isSelected: Bool, for category: CatalogCategory) {
        if isSelected {
            state.selectedIds.insert(category.id)
        } else {
            state.selectedIds.remove(category.id)
        }
    }

    /// "Done": saves the selected interests and completes onboarding.
    public func finish() async {
        // Keep the order in which the categories are displayed.
        let ids = state.categories.map(\.id).filter { state.selectedIds.contains($0) }
        await complete(with: ids)
    }

    /// "Skip": completes onboarding without interests.
    public func skip() async {
        await complete(with: [])
    }

    private func complete(with ids: [String]) async {
        guard !state.isSubmitting else {
            return
        }
        state.error = nil
        state.isSubmitting = true
        do {
            let me = try await repository.completeOnboarding(interestCategoryIds: ids)
            state.isSubmitting = false
            onCompleted(me)
        } catch is CancellationError {
            state.isSubmitting = false
        } catch {
            state.isSubmitting = false
            state.error = ScreenError(ErrorMessages.key(for: error))
        }
    }
}
