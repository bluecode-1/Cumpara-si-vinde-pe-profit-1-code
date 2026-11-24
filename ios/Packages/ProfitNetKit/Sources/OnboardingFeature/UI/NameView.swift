import DesignSystem
import SwiftUI

/// Step 5: the display name (2–40 characters).
@MainActor
struct NameView: View {
    @Bindable var viewModel: NameViewModel
    @FocusState private var isFieldFocused: Bool

    var body: some View {
        OnboardingScaffold(
            title: L10n.string(.nameTitle),
            subtitle: L10n.string(.nameSubtitle)
        ) {
            TextField(L10n.string(.nameLabel), text: $viewModel.state.name)
                .textContentType(.givenName)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.continue)
                .focused($isFieldFocused)
                .onSubmit {
                    Task { await viewModel.submit() }
                }
                .accessibilityLabel(L10n.string(.nameLabel))
                .accessibilityHint(L10n.string(.nameSubtitle))
                .accessibilityIdentifier(OnboardingID.nameField)
                .pnFieldStyle(isError: viewModel.state.error != nil)

            ErrorMessageView(error: viewModel.state.error)
        } actions: {
            PNButton(L10n.string(.actionContinue), isLoading: viewModel.state.isSubmitting) {
                Task { await viewModel.submit() }
            }
            .accessibilityIdentifier(OnboardingID.nameContinue)
        }
        .announcesError(viewModel.state.error)
        .onAppear {
            isFieldFocused = true
        }
    }
}
