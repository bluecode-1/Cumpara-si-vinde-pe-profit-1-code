import Core
import DesignSystem
import SwiftUI

/// Step 7: optional interests (top-level categories, multiple selection).
@MainActor
struct InterestsView: View {
    @Bindable var viewModel: InterestsViewModel

    var body: some View {
        OnboardingScaffold(
            title: L10n.string(.interestsTitle),
            subtitle: L10n.string(.interestsSubtitle)
        ) {
            if viewModel.state.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .accessibilityHidden(true)
            }

            VStack(alignment: .leading, spacing: PNSpacing.xs) {
                ForEach(viewModel.state.categories) { category in
                    PNCheckboxRow(category.name, isOn: selectionBinding(for: category))
                        .accessibilityIdentifier(OnboardingID.interestsCategoryPrefix + category.slug)
                }
            }

            ErrorMessageView(error: viewModel.state.error)
        } actions: {
            PNButton(L10n.string(.actionFinish), isLoading: viewModel.state.isSubmitting) {
                Task { await viewModel.finish() }
            }
            .accessibilityIdentifier(OnboardingID.interestsFinish)

            PNButton(L10n.string(.interestsSkip), kind: .secondary) {
                Task { await viewModel.skip() }
            }
            .disabled(viewModel.state.isSubmitting)
            .accessibilityIdentifier(OnboardingID.interestsSkip)
        }
        .announcesError(viewModel.state.error)
        .task {
            await viewModel.load()
        }
    }

    private func selectionBinding(for category: CatalogCategory) -> Binding<Bool> {
        Binding(
            get: { viewModel.isSelected(category) },
            set: { viewModel.setSelected($0, for: category) }
        )
    }
}
